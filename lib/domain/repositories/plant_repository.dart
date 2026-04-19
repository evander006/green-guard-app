// lib/domain/repositories/plant_repository.dart
import 'package:green_guard/domain/entities/plant_entity.dart';


abstract class PlantRepository {
  Future<void> addPlant(PlantEntity plantEntity);
  Future<void> deletePlant(PlantEntity plantEntity);
  Future<List<PlantEntity>> getPlants({String? category});
  Future<PlantEntity?> getPlantById(String id);
}
