import 'package:green_guard/core/consts/enums.dart';

class ScannerResultEntity {
  final String imagePath;
  final ScanResource source;
  final DateTime timestamp;
  final String? originalPath;

  ScannerResultEntity({
    required this.imagePath,
    required this.source,
    required this.timestamp,
    this.originalPath,
  });
  bool get isFromCamera => source == ScanResource.camera;
  bool get isFromGallery => source == ScanResource.gallery;
}
