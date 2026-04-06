// lib/data/datasources/plant_local_datasource.dart

import 'package:green_guard/domain/entities/plant_entity.dart';

abstract class PlantLocalDatasource {
  Future<List<PlantEntity>> getPlants({String? category});
  Future<PlantEntity?> getPlantById(String id);
}

class PlantLocalDatasourceImpl implements PlantLocalDatasource {
  static final _plants = [
    const PlantEntity(
      id: '1',
      name: 'Green',
      subtitle: 'Indoor Plant',
      category: 'Indoor Plant',
      waterPercent: 26,
      lightPercent: 98,
      tempPercent: 22,
      airQualityPercent: 80,
      imageEmoji: '🌿',
    ),
    const PlantEntity(
      id: '2',
      name: 'Monstera',
      subtitle: 'Tropical Plant',
      category: 'Indoor Plant',
      waterPercent: 45,
      lightPercent: 70,
      tempPercent: 35,
      airQualityPercent: 90,
      imageEmoji: '🪴',
    ),
    const PlantEntity(
      id: '3',
      name: 'Cactus',
      subtitle: 'Desert Plant',
      category: 'Outdoor Plant',
      waterPercent: 10,
      lightPercent: 95,
      tempPercent: 60,
      airQualityPercent: 75,
      imageEmoji: '🌵',
    ),
    const PlantEntity(
      id: '4',
      name: 'Orchid',
      subtitle: 'Flowering Plant',
      category: 'Flowering',
      waterPercent: 60,
      lightPercent: 55,
      tempPercent: 28,
      airQualityPercent: 85,
      imageEmoji: '🌸',
    ),
  ];

  @override
  Future<List<PlantEntity>> getPlants({String? category}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (category == null || category == 'All') return _plants;
    return _plants.where((p) => p.category == category).toList();
  }

  @override
  Future<PlantEntity?> getPlantById(String id) async {
    try {
      return _plants.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}
