import 'package:green_guard/domain/entities/plant_entity.dart';

// lib/data/models/plant_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class PlantModel extends PlantEntity {
  const PlantModel({
    required super.id,
    required super.userId,
    required super.name,
    required super.subtitle,
    required super.category,
    required super.waterPercent,
    required super.lightPercent,
    required super.tempPercent,
    required super.airQualityPercent,
    required super.image,
    super.createdAt,
  });

  //Firestore → PlantModel
  factory PlantModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PlantModel(
      id: data['id'] ?? doc.id,
      userId: data['userId'] ?? '',
      name: data['name'] ?? '',
      subtitle: data['subtitle'] ?? '',
      category: data['category'] ?? '',
      waterPercent: (data['waterPercent'] ?? 0).toDouble(),
      lightPercent: (data['lightPercent'] ?? 0).toDouble(),
      tempPercent: (data['tempPercent'] ?? 0).toDouble(),
      airQualityPercent: (data['airQualityPercent'] ?? 0).toDouble(),
      image: data['image'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  // PlantModel → Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'subtitle': subtitle,
      'category': category,
      'waterPercent': waterPercent,
      'lightPercent': lightPercent,
      'tempPercent': tempPercent,
      'airQualityPercent': airQualityPercent,
      'image': image,
      'createdAt': createdAt != null 
          ? Timestamp.fromDate(createdAt!) 
          : FieldValue.serverTimestamp(),
    };
  }
}