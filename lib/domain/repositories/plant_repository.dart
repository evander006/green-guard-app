// lib/domain/repositories/plant_repository.dart
import 'package:green_guard/domain/entities/plant_entity.dart';


abstract class PlantRepository {
  Future<List<PlantEntity>> getPlants({String? category});
  Future<PlantEntity?> getPlantById(String id);
}
