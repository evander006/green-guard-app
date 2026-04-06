import 'package:green_guard/domain/entities/scanner_result_entity.dart';

abstract class ScannerRepository {
  Future<bool> requestCameraPermission();
  Future<bool> isCameraPermissionGranted();
  Future<bool> isCameraPermissionPermanentlyDenied();
  Future<void> openSettings();
  Future<ScannerResultEntity> pickFromGallery();
  Future<ScannerResultEntity> captureFromCamera();
  Future<void> dispose();
}
