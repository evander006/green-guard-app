// lib/data/repositories/plant_repository_impl.dart
import 'package:green_guard/domain/entities/plant_entity.dart';
import '../../domain/repositories/plant_repository.dart';
import '../datasources/plant_local_datasource.dart';

class PlantRepositoryImpl implements PlantRepository {
  final PlantLocalDatasource datasource;
  PlantRepositoryImpl(this.datasource);

  @override
  Future<List<PlantEntity>> getPlants({String? category}) =>
      datasource.getPlants(category: category);

  @override
  Future<PlantEntity?> getPlantById(String id) => datasource.getPlantById(id);
}
