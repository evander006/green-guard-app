import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_guard/domain/usecases/request_camera_permission_usecase.dart';
import 'package:green_guard/presentation/scanner/bloc/scanner_event.dart';
import 'package:green_guard/presentation/scanner/bloc/scanner_state.dart';

class ScannerBloc extends Bloc<ScannerEvent, ScannerState> {
  final RequestCameraPermissionUseCase requestCameraPermissionUseCase;
  final CheckIsCameraPermissionGrantedUseCase cameraPermissionGrantedUseCase;
  final CheckIsCameraPermissionPermanentlyDeniedUseCase
  checkIsCameraPermissionPermanentlyDeniedUseCase;
  final PickFromGalleryUseCase pickFromGalleryUseCase;
  final CaptureFromCameraUseCase captureFromCameraUseCase;
  final OpenSettingsUseCase openSettingsUseCase;
  final DisposeUseCase disposeUseCase;
  ScannerBloc({
    required this.requestCameraPermissionUseCase,
    required this.cameraPermissionGrantedUseCase,
    required this.checkIsCameraPermissionPermanentlyDeniedUseCase,
    required this.pickFromGalleryUseCase,
    required this.captureFromCameraUseCase,
    required this.openSettingsUseCase,
    required this.disposeUseCase,
  }) : super(ScannerInitial()) {
    on<CheckCameraPermissionRequested>(_onCheckPermission);
    on<RequestCameraPermissionRequested>(_onRequestPermission);
    on<CaptureFromCameraRequested>(_onCaptureFromCamera);
    on<PickFromGalleryRequested>(_onPickFromGallery);
    on<OpenSettingsRequested>(_onOpenSettings);
    on<DisposeScannerRequested>(_onDispose);
  }
  Future<void> _onCheckPermission(
    CheckCameraPermissionRequested event,
    Emitter<ScannerState> emit,
  ) async {
    emit(ScannerLoading());
    try {
      final granted = await cameraPermissionGrantedUseCase();
      if (granted) {
        emit(CameraPermissionGranted());
      } else {
        final permanentlyDenied =
            await checkIsCameraPermissionPermanentlyDeniedUseCase();
        emit(CameraPermissionDenied(permanentlyDenied: permanentlyDenied));
      }
    } catch (e) {
      emit(ScannerError(e.toString()));
    }
  }

  Future<void> _onRequestPermission(
    RequestCameraPermissionRequested event,
    Emitter<ScannerState> emit,
  ) async {
    emit(ScannerLoading());
    try {
      final granted = await requestCameraPermissionUseCase();
      if (granted) {
        emit(CameraPermissionGranted());
      } else {
        final permanentlyDenied =
            await checkIsCameraPermissionPermanentlyDeniedUseCase();
        emit(CameraPermissionDenied(permanentlyDenied: permanentlyDenied));
      }
    } catch (e) {
      emit(ScannerError(e.toString()));
    }
  }

  Future<void> _onCaptureFromCamera(
    CaptureFromCameraRequested event,
    Emitter<ScannerState> emit,
  ) async {
    emit(ScannerLoading());
    try {
      final result = await captureFromCameraUseCase();
      emit(ImageCaptured(result));
    } catch (e) {
      emit(ScannerError(e.toString()));
    }
  }

  Future<void> _onPickFromGallery(
    PickFromGalleryRequested event,
    Emitter<ScannerState> emit,
  ) async {
    emit(ScannerLoading());
    try {
      final result = await pickFromGalleryUseCase();
      emit(ImageCaptured(result));
    } catch (e) {
      emit(ScannerError(e.toString()));
    }
  }

  Future<void> _onOpenSettings(
    OpenSettingsRequested event,
    Emitter<ScannerState> emit,
  ) async {
    await openSettingsUseCase();
    emit(ScannerInitial());
  }

  Future<void> _onDispose(
    DisposeScannerRequested event,
    Emitter<ScannerState> emit,
  ) async {
    await disposeUseCase();
    emit(ScannerInitial());
  }

  @override
  Future<void> close() {
    add(DisposeScannerRequested());
    return super.close();
  }
}
