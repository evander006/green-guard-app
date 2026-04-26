// lib/domain/usecases/get_plants_usecase.dart
import 'package:green_guard/domain/entities/plant_entity.dart';
import '../repositories/plant_repository.dart';

class GetPlantsUseCase {
  final PlantRepository repository;
  GetPlantsUseCase(this.repository);
  Future<List<PlantEntity>> call({String? category}) =>
      repository.getPlants(category: category);
}

class AddPlantUseCase {
  final PlantRepository repository;
  AddPlantUseCase(this.repository);
  Future<void> call(PlantEntity plantEntity) =>
      repository.addPlant(plantEntity);
}

class DeletePlantUseCase {
  final PlantRepository repository;
  DeletePlantUseCase(this.repository);
  Future<void> deletePlant(String plantId) => repository.deletePlant(plantId);
}

class GetPlantByIdUseCase {
  final PlantRepository repository;
  GetPlantByIdUseCase(this.repository);
  Future<PlantEntity?> getPlantById(String id) => repository.getPlantById(id);
}

class WatchPlantsUseCase {
  final PlantRepository repository;
  WatchPlantsUseCase(this.repository);

  Stream<List<PlantEntity>> call({String? category}) =>
      repository.watchPlants(category: category);
}
