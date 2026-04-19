import 'package:equatable/equatable.dart';

class PlantEntity extends Equatable {
  final String id;
  final String name;
  final String subtitle;
  final String category;
  final double waterPercent;
  final double lightPercent;
  final double tempPercent;
  final double airQualityPercent;
  final String image;

  const PlantEntity({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.category,
    required this.waterPercent,
    required this.lightPercent,
    required this.tempPercent,
    required this.airQualityPercent,
    required this.image,
  });

  @override
  List<Object?> get props => [id];
}