// lib/presentation/scanner/bloc/scanner_state.dart
import 'package:green_guard/domain/entities/scanner_result_entity.dart';

abstract class ScannerState {}

class ScannerInitial extends ScannerState {}

class ScannerLoading extends ScannerState {}

class CameraPermissionGranted extends ScannerState {}

class CameraPermissionDenied extends ScannerState {
  final bool permanentlyDenied;
  CameraPermissionDenied({this.permanentlyDenied = false});
}

class ImageCaptured extends ScannerState {
  final ScannerResultEntity result;
  ImageCaptured(this.result);
}

class ScannerError extends ScannerState {
  final String message;
  ScannerError(this.message);
}
