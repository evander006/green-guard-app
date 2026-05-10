import 'package:flutter/material.dart';

import '../entities/plant_entity.dart';
import '../repositories/plant_repository.dart';

class GetWateringScheduleUseCase {
  final PlantRepository repository;

  GetWateringScheduleUseCase(this.repository);

  Future<Map<DateTime, List<PlantEntity>>> call({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final plants = await repository.getPlants();
    final schedule = <DateTime, List<PlantEntity>>{};
    final now = DateTime.now();
    debugPrint('🌿 [Schedule] Total plants fetched: ${plants.length}');
    debugPrint('🌿 [Schedule] Date range: $startDate → $endDate');
    for (final plant in plants) {
      debugPrint(
        '  🪴 ${plant.name}: '
        'reminderEnabled=${plant.reminderEnabled}, '
        'reminderTime=${plant.reminderTime?.hour}:${plant.reminderTime?.minute}, '
        'nextWatering=${plant.nextWatering}, '
        'frequency=${plant.frequency.name}',
      );
      final wateringDates = _calculateWateringDates(
        plant: plant,
        startDate: startDate,
        endDate: endDate,
        now: now,
      );
      debugPrint('  📅 Calculated dates for ${plant.name}: $wateringDates');

      for (final date in wateringDates) {
        schedule.putIfAbsent(date, () => []).add(plant);
      }
    }
    debugPrint('📆 [Schedule] Final keys: ${schedule.keys.toList()}');

    return schedule;
  }

  List<DateTime> _calculateWateringDates({
    required PlantEntity plant,
    required DateTime startDate,
    required DateTime endDate,
    required DateTime now,
  }) {
    final dates = <DateTime>[];

    DateTime? baseDate;
    if (plant.nextWatering != null) {
      baseDate = plant.nextWatering;
    } else if (plant.lastWatered != null) {
      baseDate = _addFrequency(plant.lastWatered!, plant.frequency);
    } else if (plant.createdAt != null) {
      baseDate = _addFrequency(plant.createdAt!, plant.frequency);
    }

    if (baseDate == null) return dates;
    final reminderHour = plant.reminderTime?.hour ?? 8;
    final reminderMinute = plant.reminderTime?.minute ?? 0;
    DateTime currentDate = baseDate;
    while (currentDate.isBefore(endDate.add(const Duration(days: 1)))) {
      if (currentDate.isAfter(startDate.subtract(const Duration(days: 1)))) {
        dates.add(
          DateTime(currentDate.year, currentDate.month, currentDate.day),
        );
      }
      currentDate = _addFrequency(currentDate, plant.frequency);
    }

    return dates;
  }

  DateTime _addFrequency(DateTime date, WateringFrequency frequency) {
    switch (frequency) {
      case WateringFrequency.daily:
        return date.add(const Duration(days: 1));
      case WateringFrequency.every2Days:
        return date.add(const Duration(days: 2));
      case WateringFrequency.every3Days:
        return date.add(const Duration(days: 3));
      case WateringFrequency.weekly:
        return date.add(const Duration(days: 7));
    }
  }
}
