import 'dart:io';

import 'package:camera/camera.dart';
import 'package:green_guard/core/consts/enums.dart';
import 'package:green_guard/data/models/scanner_result_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

abstract class ScannerDatasource {
  Future<bool> requestCameraPermission();
  Future<bool> isCameraPermissionGranted();
  Future<bool> isCameraPermissionPermanentlyDenied();
  Future<void> openSettings();
  Future<ScannerResultModel> pickFromGallery();
  Future<ScannerResultModel> captureFromCamera();
  Future<void> dispose();
}

class ScannerDatasourceImpl extends ScannerDatasource {
  final ImagePicker _imagePicker;
  CameraController? _cameraController;
  CameraDescription? _cameraDescription;
  ScannerDatasourceImpl({ImagePicker? imagePicker})
    : _imagePicker = imagePicker ?? ImagePicker();
  @override
  Future<ScannerResultModel> captureFromCamera() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      await initializeCamera();
    }
    try {
      if (!_cameraController!.value.isTakingPicture) {
        final XFile pic = await _cameraController!.takePicture();
        final savedPath = await _saveImageToStorage(pic.path, prefix: 'scan_');
        return ScannerResultModel(
          imagePath: savedPath,
          source: ScanResource.camera,
          timestamp: DateTime.now(),
        );
      } else {
        throw Exception('Camera is already taking a picture');
      }
    } on CameraException catch (e) {
      throw Exception('Camera error: ${e.description ?? e.toString()}');
    } catch (e) {
      throw Exception('Capture failed: ${e.toString()}');
    }
  }

  @override
  Future<void> dispose() async {
    if (_cameraController != null) {
      if (_cameraController!.value.isInitialized) {
        await _cameraController!.dispose();
      }
      _cameraController = null;
      _cameraDescription = null;
    }
  }

  @override
  Future<bool> isCameraPermissionGranted() async {
    return await Permission.camera.status.isGranted;
  }

  @override
  Future<bool> isCameraPermissionPermanentlyDenied() {
    return Permission.camera.status.isPermanentlyDenied;
  }

  @override
  Future<void> openSettings() async {
    await openAppSettings();
  }

  @override
  Future<ScannerResultModel> pickFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );
      if (image == null) {
        throw Exception('No image selected');
      }
      final savedPath = await _saveImageToStorage(
        image.path,
        prefix: 'gallery_',
      );
      return ScannerResultModel(
        imagePath: savedPath,
        source: ScanResource.gallery,
        timestamp: DateTime.now(),
        originalPath: image.path,
      );
    } catch (e) {
      throw Exception('Gallery pick failed: ${e.toString()}');
    }
  }

  @override
  Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    await Permission.photos.request();
    return status.isGranted;
  }

  Future<String> _saveImageToStorage(
    String sourcePath, {
    required String prefix,
  }) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final uniqueName = '${prefix}${const Uuid().v4()}.jpg';
      final savedPath = path.join(directory.path, uniqueName);

      final savedFile = await File(sourcePath).copy(savedPath);

      return savedFile.path;
    } catch (e) {
      return sourcePath;
    }
  }

  Future<void> initializeCamera() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      return;
    }

    try {
      final cameras = await availableCameras();
      
      _cameraDescription = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        _cameraDescription!,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: Platform.isIOS 
            ? ImageFormatGroup.jpeg 
            : ImageFormatGroup.yuv420,
      );

      await _cameraController!.initialize();
    } catch (e) {
      throw Exception('Failed to initialize camera: ${e.toString()}');
    }
  }
}
