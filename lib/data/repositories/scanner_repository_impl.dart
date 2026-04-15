import 'package:green_guard/data/datasources/scanner_datasource.dart';
import 'package:green_guard/domain/entities/scanner_result_entity.dart';
import 'package:green_guard/domain/repositories/scanner_repository.dart';

class ScannerRepositoryImpl extends ScannerRepository {
  final ScannerDatasource scannerDatasource;

  ScannerRepositoryImpl(this.scannerDatasource);
  @override
  Future<ScannerResultEntity> captureFromCamera() async {
    return await scannerDatasource.captureFromCamera();
  }

  @override
  Future<void> dispose() async {
    await scannerDatasource.dispose();
  }

  @override
  Future<bool> isCameraPermissionGranted() async {
    return scannerDatasource.isCameraPermissionGranted();
  }

  @override
  Future<bool> isCameraPermissionPermanentlyDenied() async {
    return await scannerDatasource.isCameraPermissionPermanentlyDenied();
  }

  @override
  Future<void> openSettings() async {
    return await scannerDatasource.openSettings();
  }

  @override
  Future<ScannerResultEntity> pickFromGallery() async {
    return await scannerDatasource.pickFromGallery();
  }

  @override
  Future<bool> requestCameraPermission() async {
    return await scannerDatasource.requestCameraPermission();
  }
}
