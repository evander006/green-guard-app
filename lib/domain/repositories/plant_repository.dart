// lib/domain/repositories/plant_repository.dart
import 'package:green_guard/domain/entities/plant_entity.dart';

// lib/domain/repositories/plant_repository.dart
abstract class PlantRepository {
  Future<void> addPlant(PlantEntity plant);
  Future<void> deletePlant(String plantId);  
  Future<List<PlantEntity>> getPlants({String? category});
  Stream<List<PlantEntity>> watchPlants({String? category});
  Future<PlantEntity?> getPlantById(String id);
}
