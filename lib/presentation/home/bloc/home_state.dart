// lib/presentation/home/bloc/home_state.dart
import 'package:equatable/equatable.dart';
import 'package:green_guard/domain/entities/plant_entity.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}
class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<PlantEntity> plants;
  final String selectedCategory;
  HomeLoaded({required this.plants, required this.selectedCategory});
  @override
  List<Object?> get props => [plants, selectedCategory];
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
  @override
  List<Object?> get props => [message];
}
