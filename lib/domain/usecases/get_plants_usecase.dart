// lib/domain/usecases/get_plants_usecase.dart
import 'package:green_guard/domain/entities/plant_entity.dart';
import '../repositories/plant_repository.dart';

class GetPlantsUseCase {
  final PlantRepository repository;
  GetPlantsUseCase(this.repository);

  Future<List<PlantEntity>> call({String? category}) =>
      repository.getPlants(category: category);
}
