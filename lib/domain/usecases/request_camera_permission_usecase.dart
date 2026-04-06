import 'package:green_guard/domain/entities/scanner_result_entity.dart';
import 'package:green_guard/domain/repositories/scanner_repository.dart';

class RequestCameraPermissionUseCase {
  final ScannerRepository scannerRepository;

  RequestCameraPermissionUseCase(this.scannerRepository);
  Future<bool> call() async {
    return scannerRepository.requestCameraPermission();
  }
}

class CheckIsCameraPermissionGrantedUseCase {
  final ScannerRepository scannerRepository;

  CheckIsCameraPermissionGrantedUseCase(this.scannerRepository);
  Future<bool> call() async {
    return scannerRepository.isCameraPermissionGranted();
  }
}

class CheckIsCameraPermissionPermanentlyDeniedUseCase {
  final ScannerRepository scannerRepository;

  CheckIsCameraPermissionPermanentlyDeniedUseCase(this.scannerRepository);
  Future<bool> call() async {
    return scannerRepository.isCameraPermissionPermanentlyDenied();
  }
}

class PickFromGalleryUseCase {
  final ScannerRepository scannerRepository;

  PickFromGalleryUseCase(this.scannerRepository);
  Future<ScannerResultEntity> call() async {
    return scannerRepository.pickFromGallery();
  }
}

class CaptureFromCameraUseCase {
  final ScannerRepository scannerRepository;

  CaptureFromCameraUseCase(this.scannerRepository);
  Future<ScannerResultEntity> call() async {
    return scannerRepository.captureFromCamera();
  }
}
