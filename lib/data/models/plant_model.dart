import 'package:green_guard/domain/entities/plant_entity.dart';

class PlantModel extends PlantEntity {
  const PlantModel({
    required super.id,
    required super.name,
    required super.subtitle,
    required super.category,
    required super.waterPercent,
    required super.lightPercent,
    required super.tempPercent,
    required super.airQualityPercent,
    required super.image,
  });
  factory PlantModel.fromJson(Map<String, dynamic> json) {
    return PlantModel(
      id: json['id'],
      name: json['name'],
      subtitle: json['subtitle'],
      category: json['category'],
      waterPercent: json['waterPercent'],
      lightPercent: json['lightPercent'],
      tempPercent: json['tempPercent'],
      airQualityPercent: json['airQualityPercent'],
      image: json['image'],
    );
  }
  PlantModel copying({
    String? id,
    String? name,
    String? subtitle,
    String? category,
    double? waterPercent,
    double? lightPercent,
    double? tempPercent,
    double? airQualityPercent,
    String? image,
  }) {
    return PlantModel(
      id: id ?? this.id,
      name: name ?? this.name,
      subtitle: subtitle ?? this.subtitle,
      category: category ?? this.category,
      waterPercent: waterPercent ?? this.waterPercent,
      lightPercent: lightPercent ?? this.lightPercent,
      tempPercent: tempPercent ?? this.tempPercent,
      airQualityPercent: airQualityPercent ?? this.airQualityPercent,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'subtitle': subtitle,
      'category': category,
      'waterPercent': waterPercent,
      'lightPercent': lightPercent,
      'tempPercent': tempPercent,
      'airQualityPercent': airQualityPercent,
      'image': image,
    };
  }
}
