// lib/data/repositories/plant_repository_impl.dart
import 'package:green_guard/data/models/plant_model.dart';
import 'package:green_guard/domain/entities/plant_entity.dart';
import '../../domain/repositories/plant_repository.dart';
import '../datasources/plant_local_datasource.dart';

class PlantRepositoryImpl implements PlantRepository {
  final PlantDatasource datasource;

  PlantRepositoryImpl(this.datasource);

  @override
  Future<void> addPlant(PlantEntity plant) async {
    final createdAt = plant.createdAt ?? DateTime.now();
    final nextWatering = plant.nextWatering ?? _computeNextWatering(createdAt, plant.frequency);

    final model = PlantModel(
      id: plant.id,
      userId: plant.userId,
      name: plant.name,
      subtitle: plant.subtitle,
      category: plant.category,
      waterPercent: plant.waterPercent,
      lightPercent: plant.lightPercent,
      tempPercent: plant.tempPercent,
      airQualityPercent: plant.airQualityPercent,
      image: plant.image,
      reminderEnabled: plant.reminderEnabled,
      reminderTime: plant.reminderTime,
      frequency: plant.frequency,
      createdAt: plant.createdAt,
      lastWatered: plant.lastWatered,
      nextWatering: nextWatering,
    );
    await datasource.addPlant(model);
  }

  @override
  Future<List<PlantEntity>> getPlants({String? category}) =>
      datasource.getPlants(category: category);

  @override
  Future<PlantEntity?> getPlantById(String id) => datasource.getPlantById(id);

  @override
  Stream<List<PlantEntity>> watchPlants({String? category}) =>
      datasource.watchPlants(category: category);

  @override
  Future<void> deletePlant(String plantId) => datasource.deletePlant(plantId);

  @override
  Future<void> updatePlant(PlantEntity plant) async {
    final updatedPlant = PlantModel(
      id: plant.id,
      userId: plant.userId,
      name: plant.name,
      subtitle: plant.subtitle,
      category: plant.category,
      waterPercent: plant.waterPercent,
      lightPercent: plant.lightPercent,
      tempPercent: plant.tempPercent,
      airQualityPercent: plant.airQualityPercent,
      image: plant.image,
      createdAt: plant.createdAt,
      reminderEnabled: plant.reminderEnabled,
      reminderTime: plant.reminderTime,
      frequency: plant.frequency,
      lastWatered: plant.lastWatered,
      nextWatering: plant.nextWatering,
    );
    await datasource.updatePlant(updatedPlant);
  }
}

DateTime _computeNextWatering(DateTime from, WateringFrequency frequency) {
  switch (frequency) {
    case WateringFrequency.daily:
      return from.add(const Duration(days: 1));
    case WateringFrequency.every2Days:
      return from.add(const Duration(days: 2));
    case WateringFrequency.every3Days:
      return from.add(const Duration(days: 3));
    case WateringFrequency.weekly:
      return from.add(const Duration(days: 7));
  }
}
