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
      createdAt: plant.createdAt,
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
}
