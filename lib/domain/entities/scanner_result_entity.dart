import 'package:green_guard/core/consts/enums.dart';

class ScannerResultEntity {
  final String imagePath;
  final ScanResource source;
  final DateTime timespan;

  ScannerResultEntity({required this.imagePath, required this.source, required this.timespan});
}