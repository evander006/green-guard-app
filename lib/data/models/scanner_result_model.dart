import 'package:green_guard/domain/entities/scanner_result_entity.dart';

class ScannerResultModel extends ScannerResultEntity {
  ScannerResultModel({required super.imagePath, required super.source, required super.timespan});

  factory ScannerResultModel.fromEntity(ScannerResultEntity ent){
    return ScannerResultModel(imagePath: ent.imagePath, source: ent.source, timespan: ent.timespan);
  }
}