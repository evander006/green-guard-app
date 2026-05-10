// lib/data/models/plant_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/plant_entity.dart';

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
    super.reminderEnabled = false,
    super.reminderTime,
    super.frequency = WateringFrequency.every3Days,
    super.lastWatered,
    super.nextWatering,
  });

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
      reminderEnabled: data['reminderEnabled'] ?? false,
      reminderTime: _timeFromFirestore(data['reminderTime']),
      frequency: _frequencyFromFirestore(data['frequency']),
      lastWatered: (data['lastWatered'] as Timestamp?)?.toDate(),
      nextWatering: (data['nextWatering'] as Timestamp?)?.toDate(),
    );
  }

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
      'reminderEnabled': reminderEnabled,
      'reminderTime': _timeToFirestore(reminderTime),
      'lastWatered': lastWatered != null
          ? Timestamp.fromDate(lastWatered!)
          : null,
      'frequency': frequency.name,
      'nextWatering': nextWatering != null
          ? Timestamp.fromDate(nextWatering!)
          : null,
    };
  }

  static Map<String, int>? _timeToFirestore(TimeOfDay? time) {
    if (time == null) return null;
    return {'hour': time.hour, 'minute': time.minute};
  }

  static TimeOfDay? _timeFromFirestore(dynamic data) {
    if (data == null || data is! Map<String, dynamic>) return null;
    final hour = data['hour'] as int?;
    final minute = data['minute'] as int?;
    if (hour == null || minute == null) return null;
    return TimeOfDay(hour: hour, minute: minute);
  }


  static WateringFrequency _frequencyFromFirestore(dynamic data) {
    if (data == null || data is! String) return WateringFrequency.every3Days;
    return WateringFrequency.values.firstWhere(
      (f) => f.name == data,
      orElse: () => WateringFrequency.every3Days,
    );
  }

  PlantModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? subtitle,
    String? category,
    double? waterPercent,
    double? lightPercent,
    double? tempPercent,
    double? airQualityPercent,
    String? image,
    DateTime? createdAt,
    bool? reminderEnabled,
    TimeOfDay? reminderTime,
    WateringFrequency? frequency,
    DateTime? lastWatered,
    DateTime? nextWatering,
  }) {
    return PlantModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      subtitle: subtitle ?? this.subtitle,
      category: category ?? this.category,
      waterPercent: waterPercent ?? this.waterPercent,
      lightPercent: lightPercent ?? this.lightPercent,
      tempPercent: tempPercent ?? this.tempPercent,
      airQualityPercent: airQualityPercent ?? this.airQualityPercent,
      image: image ?? this.image,
      createdAt: createdAt ?? this.createdAt,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderTime: reminderTime ?? this.reminderTime,
      frequency: frequency ?? this.frequency,
      lastWatered: lastWatered ?? this.lastWatered,
      nextWatering: nextWatering ?? this.nextWatering,
    );
  }
}
