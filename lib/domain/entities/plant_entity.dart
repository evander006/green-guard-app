import 'package:equatable/equatable.dart';

// lib/domain/entities/plant_entity.dart
class PlantEntity extends Equatable {
  final String id;
  final String userId;
  final String name;
  final String subtitle;
  final String category;
  final double waterPercent;
  final double lightPercent;
  final double tempPercent;
  final double airQualityPercent;
  final String image;
  final DateTime? createdAt;

  const PlantEntity({
    required this.id,
    required this.userId,
    required this.name,
    required this.subtitle,
    required this.category,
    required this.waterPercent,
    required this.lightPercent,
    required this.tempPercent,
    required this.airQualityPercent,
    required this.image,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, userId];
}