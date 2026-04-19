// lib/data/repositories/plant_repository_impl.dart
import 'package:green_guard/data/models/plant_model.dart';
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

  @override
  Future<void> addPlant(PlantEntity plantEntity) async {
    await datasource.addPlant(
      PlantModel(
        id: plantEntity.id,
        name: plantEntity.name,
        subtitle: plantEntity.subtitle,
        category: plantEntity.category,
        waterPercent: plantEntity.waterPercent,
        lightPercent: plantEntity.lightPercent,
        tempPercent: plantEntity.tempPercent,
        airQualityPercent: plantEntity.airQualityPercent,
        image: plantEntity.image,
      ),
    );
  }

  @override
  Future<void> deletePlant(PlantEntity plantEntity) async {
    await datasource.deletePlant(PlantModel(
        id: plantEntity.id,
        name: plantEntity.name,
        subtitle: plantEntity.subtitle,
        category: plantEntity.category,
        waterPercent: plantEntity.waterPercent,
        lightPercent: plantEntity.lightPercent,
        tempPercent: plantEntity.tempPercent,
        airQualityPercent: plantEntity.airQualityPercent,
        image: plantEntity.image,
      ),);
  }
}
