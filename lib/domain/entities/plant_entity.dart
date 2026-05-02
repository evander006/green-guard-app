import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum WateringFrequency {
  daily,
  every2Days,
  every3Days,
  weekly,
}

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
  final bool reminderEnabled;
  final TimeOfDay? reminderTime;
  final WateringFrequency frequency;
  final DateTime? lastWatered;
  final DateTime? nextWatering;

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
    this.reminderEnabled = false,
    this.reminderTime,
    this.frequency = WateringFrequency.every3Days,
    this.lastWatered,
    this.nextWatering,
  });

  @override
  List<Object?> get props => [
    id, userId, name, subtitle, category,
    waterPercent, lightPercent, tempPercent, airQualityPercent, image,
    createdAt, reminderEnabled, reminderTime, frequency, lastWatered, nextWatering,
  ];
}