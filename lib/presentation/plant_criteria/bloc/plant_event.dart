import 'package:equatable/equatable.dart';
import 'package:green_guard/domain/entities/plant_entity.dart';

abstract class PlantEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadPlantsRequested extends PlantEvent {
  final String? category;

  LoadPlantsRequested({this.category});
  @override
  List<Object?> get props => [category];
}

class AddPlantRequested extends PlantEvent {
  final PlantEntity plant;

  AddPlantRequested({required this.plant});
  @override
  List<Object?> get props => [plant];
}

class DeletePlantRequested extends PlantEvent {
  final String plantId;

  DeletePlantRequested({required this.plantId});
  @override
  List<Object?> get props => [plantId];
}
