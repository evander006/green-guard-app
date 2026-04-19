import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:green_guard/core/consts/app_theme.dart';
import 'package:green_guard/presentation/scanner/bloc/scanner_bloc.dart';
import 'package:green_guard/presentation/scanner/bloc/scanner_event.dart';
import 'package:green_guard/presentation/scanner/bloc/scanner_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> with WidgetsBindingObserver {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  bool _isTakingPicture = false;
  bool _hasCameraPermission = false;
  bool _isProcessing = false;
  bool _isCameraDisposed = false;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkAndRequestPermission();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _disposeCameraSync();
    } else if (state == AppLifecycleState.resumed) {
      // ✅ Only reinitialize if not already initialized AND not disposed
      if (_hasCameraPermission && !_isCameraInitialized && !_isCameraDisposed) {
        _initializeCamera();
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _disposeCamera();
    super.dispose();
  }

  // ─────────────────────────────────────────────────────────────
  // 🔐 Permission Handling
  // ─────────────────────────────────────────────────────────────

  Future<void> _checkAndRequestPermission() async {
    final status = await Permission.camera.status;

    if (status.isGranted) {
      setState(() => _hasCameraPermission = true);
      await _initializeCamera();
    } else if (status.isDenied || status.isRestricted) {
      final result = await Permission.camera.request();
      if (result.isGranted) {
        setState(() => _hasCameraPermission = true);
        await _initializeCamera();
      } else if (result.isPermanentlyDenied) {
        _showPermissionSettingsDialog();
      } else {
        _showPermissionDeniedSnackBar();
      }
    } else if (status.isPermanentlyDenied) {
      _showPermissionSettingsDialog();
    }
  }

  void _showPermissionSettingsDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('📷 Camera Access Required'),
        content: const Text(
          'Camera permission is permanently denied. '
          'Please enable it in Settings to scan plants.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await openAppSettings();
              // Re-check permission after returning from settings
              if (mounted) {
                _checkAndRequestPermission();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  void _showPermissionDeniedSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Camera permission denied. Cannot scan plants.'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // 📷 Camera Initialization & Control
  // ─────────────────────────────────────────────────────────────

  Future<void> _initializeCamera() async {
    if (!mounted || _isCameraInitialized) return;

    try {
      // ✅ Reset disposed flag before initializing
      _isCameraDisposed = false;

      final cameras = await availableCameras();
      if (cameras.isEmpty) throw Exception('No cameras available');

      final camera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        camera,
        ResolutionPreset.medium,
        enableAudio: false,
       
      );

      await _cameraController!.initialize();

      // ✅ Only setState if still mounted AND not disposed
      if (mounted && !_isCameraDisposed) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('❌ Camera init error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Camera error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ✅ CORRECT: No setState in sync disposal either
  void _disposeCameraSync() {
    if (_cameraController != null) {
      if (_cameraController!.value.isInitialized && !_isCameraDisposed) {
        try {
          _cameraController!.dispose(); // Sync dispose
        } catch (_) {}
      }
      _cameraController = null;
    }
    // ✅ Update flags only, no setState
    _isCameraInitialized = false;
    _isCameraDisposed = true;
  }

  // ✅ CORRECT: Don't call setState in dispose()
  Future<void> _disposeCamera() async {
    if (_cameraController != null) {
      if (_cameraController!.value.isInitialized && !_isCameraDisposed) {
        try {
          await _cameraController!.dispose();
        } catch (e) {
          debugPrint('Camera dispose error: $e');
        }
      }
      _cameraController = null;
    }
    // ✅ Don't call setState here - widget is being destroyed anyway!
    // Just update the flag for safety
    _isCameraInitialized = false;
    _isCameraDisposed = true;
  }

  Widget _buildSafeCameraPreview() {
    if (_cameraController == null || _isCameraDisposed) {
      return _buildPermissionPlaceholder();
    }

    if (!_cameraController!.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    return ValueListenableBuilder<CameraValue>(
      valueListenable: _cameraController!,
      builder: (context, value, child) {
        // Final guard: re-check initialization state
        if (!value.isInitialized || _isCameraDisposed) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }
        return CameraPreview(_cameraController!);
      },
    );
  }

  Future<void> _toggleFlash() async {
    if (!_isCameraInitialized ||
        _cameraController == null ||
        _isCameraDisposed) {
      return;
    }
    try {
      final current = _cameraController!.value.flashMode;
      await _cameraController!.setFlashMode(
        current == FlashMode.torch ? FlashMode.off : FlashMode.torch,
      );
    } catch (e) {
      debugPrint('Flash toggle error: $e');
    }
  }

  // ─────────────────────────────────────────────────────────────
  // 📸 Capture & Gallery
  // ─────────────────────────────────────────────────────────────

  Future<void> _takePicture() async {
    // ✅ Use manual disposed flag
    if (!_isCameraInitialized ||
        _cameraController == null ||
        _isCameraDisposed ||
        _isTakingPicture ||
        _isProcessing) {
      return;
    }

    setState(() {
      _isTakingPicture = true;
      _isProcessing = true;
    });

    try {
      if (_cameraController!.value.isInitialized &&
          !_isCameraDisposed &&
          !_cameraController!.value.isTakingPicture) {
        final XFile photo = await _cameraController!.takePicture();

        if (mounted) {
          context.read<ScannerBloc>().add(
            CaptureFromCameraRequested(imagePath: photo.path),
          );
        }
      }
    } catch (e) {
      debugPrint('❌ Capture error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Capture failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isTakingPicture = false;
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _pickFromGallery() async {
    if (_isProcessing) return;

    setState(() => _isProcessing = true);

    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (image == null) {
        // User cancelled
        return;
      }

      // Dispatch to BLoC
      if (mounted) {
        context.read<ScannerBloc>().add(
          PickFromGalleryRequested(imagePath: image.path),
        );
      }
    } catch (e) {
      debugPrint('❌ Gallery pick error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to select image: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  // ─────────────────────────────────────────────────────────────
  // 🎨 UI Builders
  // ─────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocListener<ScannerBloc, ScannerState>(
      listener: (context, state) {
        if (state is ImageCaptured) {
          _navigateToAnalysis(state.result.imagePath);
        } else if (state is ScannerError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          fit: StackFit.expand,
          children: [
            // ✅ Camera Preview with safety wrapper
            if (_hasCameraPermission)
              _buildSafeCameraPreview()
            else
              _buildPermissionPlaceholder(),

            // Dark overlay gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.5),
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                  stops: const [0.0, 0.25, 0.75, 1.0],
                ),
              ),
            ),

            // Top bar: Back + Flash
            Positioned(
              top: 50,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTopButton(
                    icon: Icons.arrow_back,
                    onTap: () => Navigator.pop(context),
                  ),
                  if (_hasCameraPermission && _isCameraInitialized)
                    _buildTopButton(
                      icon:
                          _cameraController?.value.flashMode == FlashMode.torch
                          ? Icons.flash_on
                          : Icons.flash_off,
                      onTap: _toggleFlash,
                    ),
                ],
              ),
            ),

            // Scanner frame with corner markers
            Positioned.fill(child: Center(child: _buildScannerFrame())),

            // Instruction text
            Positioned(
              bottom: 150,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Align plant in frame',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.95),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Bottom controls
            Positioned(
              left: 0,
              right: 0,
              bottom: 30,
              child: _buildBottomControls(),
            ),

            // Processing overlay
            if (_isProcessing)
              Container(
                color: Colors.black54,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Processing...',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionPlaceholder() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1B5E20), Color(0xFF4CAF50), Color(0xFF2E7D32)],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _hasCameraPermission ? Icons.camera_alt : Icons.no_photography,
              size: 72,
              color: Colors.white.withOpacity(0.8),
            ),
            const SizedBox(height: 20),
            Text(
              _hasCameraPermission
                  ? 'Initializing camera...'
                  : 'Camera access required',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (!_hasCameraPermission) ...[
              const SizedBox(height: 8),
              Text(
                'Allow permission to scan plants',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 13,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildScannerFrame() {
    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Outer border
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withOpacity(0.7),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.2),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          // Corner markers
          _buildCornerMarker(topLeft: true),
          _buildCornerMarker(topRight: true),
          _buildCornerMarker(bottomLeft: true),
          _buildCornerMarker(bottomRight: true),
        ],
      ),
    );
  }

  Widget _buildCornerMarker({
    bool topLeft = false,
    bool topRight = false,
    bool bottomLeft = false,
    bool bottomRight = false,
  }) {
    return Positioned(
      top: topLeft || topRight ? 0 : null,
      bottom: bottomLeft || bottomRight ? 0 : null,
      left: topLeft || bottomLeft ? 0 : null,
      right: topRight || bottomRight ? 0 : null,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          border: Border(
            top: (topLeft || topRight)
                ? const BorderSide(color: Colors.white, width: 3.5)
                : BorderSide.none,
            bottom: (bottomLeft || bottomRight)
                ? const BorderSide(color: Colors.white, width: 3.5)
                : BorderSide.none,
            left: (topLeft || bottomLeft)
                ? const BorderSide(color: Colors.white, width: 3.5)
                : BorderSide.none,
            right: (topRight || bottomRight)
                ? const BorderSide(color: Colors.white, width: 3.5)
                : BorderSide.none,
          ),
          borderRadius: BorderRadius.only(
            topLeft: topLeft ? const Radius.circular(10) : Radius.zero,
            topRight: topRight ? const Radius.circular(10) : Radius.zero,
            bottomLeft: bottomLeft ? const Radius.circular(10) : Radius.zero,
            bottomRight: bottomRight ? const Radius.circular(10) : Radius.zero,
          ),
        ),
      ),
    );
  }

  Widget _buildTopButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white30),
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }

  Widget _buildBottomControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Gallery button
        _buildControlButton(
          icon: Icons.photo_library_outlined,
          label: 'Gallery',
          onTap: _pickFromGallery,
          isEnabled: !_isProcessing,
        ),

        // Capture button
        GestureDetector(
          onTap: _isProcessing ? null : _takePicture,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: _isTakingPicture ? 64 : 74,
            height: _isTakingPicture ? 64 : 74,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
              color: _isTakingPicture
                  ? Colors.grey.withOpacity(0.3)
                  : Colors.transparent,
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.3),
                  blurRadius: _isTakingPicture ? 0 : 8,
                  spreadRadius: _isTakingPicture ? 0 : 2,
                ),
              ],
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isTakingPicture ? Colors.grey[400] : Colors.white,
              ),
            ),
          ),
        ),

        // Help/Info button
        _buildControlButton(
          icon: Icons.info_outline,
          label: 'Help',
          onTap: _showHelpDialog,
          isEnabled: !_isProcessing,
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isEnabled = true,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: isEnabled ? onTap : null,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: isEnabled ? 1.0 : 0.5,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white30),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(children: [Text('🌿 '), Text('Scanning Tips')]),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• Place plant in good, even lighting'),
            SizedBox(height: 10),
            Text('• Center the plant in the frame'),
            SizedBox(height: 10),
            Text('• Avoid shadows on the leaves'),
            SizedBox(height: 10),
            Text('• Hold steady while capturing'),
            SizedBox(height: 10),
            Text('• Fill the frame with the plant'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  void _navigateToAnalysis(String imgPath) {
    context.goNamed('plantCriteria', extra: imgPath);
  }
}
