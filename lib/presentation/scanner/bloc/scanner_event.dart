abstract class ScannerEvent {}

class CheckCameraPermissionRequested extends ScannerEvent {}

class RequestCameraPermissionRequested extends ScannerEvent {}

class CaptureFromCameraRequested extends ScannerEvent {
  final String imagePath;

  CaptureFromCameraRequested({required this.imagePath});
}

class PickFromGalleryRequested extends ScannerEvent {
  final String imagePath;

  PickFromGalleryRequested({required this.imagePath});
}

class OpenSettingsRequested extends ScannerEvent {}

class DisposeScannerRequested extends ScannerEvent {}
