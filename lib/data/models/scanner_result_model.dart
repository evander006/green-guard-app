// lib/data/models/scanner_result_model.dart
import 'package:green_guard/core/consts/enums.dart';
import '../../domain/entities/scanner_result_entity.dart';

class ScannerResultModel extends ScannerResultEntity {
  final String? originalPath;

  ScannerResultModel({
    required super.imagePath,
    required super.source,
    required super.timestamp,
    this.originalPath,
  });

  factory ScannerResultModel.fromEntity(ScannerResultEntity entity) {
    return ScannerResultModel(
      imagePath: entity.imagePath,
      source: entity.source,
      timestamp: entity.timestamp,
    );
  }

  ScannerResultModel copyWith({
    String? imagePath,
    ScanResource? source,
    DateTime? timestamp,
    String? originalPath,
  }) {
    return ScannerResultModel(
      imagePath: imagePath ?? this.imagePath,
      source: source ?? this.source,
      timestamp: timestamp ?? this.timestamp,
      originalPath: originalPath ?? this.originalPath,
    );
  }

  @override
  List<Object?> get props => [imagePath, source, timestamp, originalPath];
}
