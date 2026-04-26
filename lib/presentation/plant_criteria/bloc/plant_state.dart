import 'package:equatable/equatable.dart';
import 'package:green_guard/domain/entities/plant_entity.dart';

abstract class PlantState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PlantInitial extends PlantState {}

class PlantLoading extends PlantState {}

class PlantsLoaded extends PlantState {
  final List<PlantEntity> plants;

  PlantsLoaded({required this.plants});
  @override
  List<Object?> get props => [plants];
}

class PlantSaved extends PlantState {
  final PlantEntity plant;
  PlantSaved({required this.plant});
  @override
  List<Object?> get props => [plant];
}

class PlantError extends PlantState {
  final String message;
  PlantError(this.message);
  @override
  List<Object?> get props => [message];
}
