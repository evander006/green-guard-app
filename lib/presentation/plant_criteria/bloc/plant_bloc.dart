import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_guard/domain/usecases/plants_usecase.dart';
import 'package:green_guard/presentation/plant_criteria/bloc/plant_event.dart';
import 'package:green_guard/presentation/plant_criteria/bloc/plant_state.dart';

class PlantBloc extends Bloc<PlantEvent, PlantState> {
  final AddPlantUseCase addPlantUseCase;
  final WatchPlantsUseCase watchPlantsUseCase;
  StreamSubscription? _plantsSubscription;
  PlantBloc({required this.addPlantUseCase, required this.watchPlantsUseCase})
    : super(PlantInitial()) {
    on<LoadPlantsRequested>(_loadPlantsRequested);
    on<AddPlantRequested>(_addPlantRequested);
    on<DeletePlantRequested>(_deletePlantRequested);
  }

  Future<void> _deletePlantRequested(
    DeletePlantRequested event,
    Emitter<PlantState> emit,
  ) async {
    try {
      // Implement delete use case if needed
      // For now stream will update automatically if delete works
    } catch (e) {
      emit(PlantError(e.toString()));
    }
  }

  Future<void> _addPlantRequested(
    AddPlantRequested event,
    Emitter<PlantState> emit,
  ) async {
    try {
      await addPlantUseCase(event.plant);
      emit(PlantSaved(plant: event.plant));
    } catch (e) {
      emit(PlantError(e.toString()));
    }
  }

  Future<void> _loadPlantsRequested(
    LoadPlantsRequested event,
    Emitter<PlantState> emit,
  ) async {
    emit(PlantLoading());
    try {
      await _plantsSubscription?.cancel();
      _plantsSubscription=watchPlantsUseCase(category: event.category).listen((plants)=>emit(PlantsLoaded(plants: plants)),
      onError: (err) =>emit(PlantError(err)) ,
      );
    } catch (e) {
      emit(PlantError(e.toString()));
    }
  }
  @override
  Future<void> close() {
    _plantsSubscription?.cancel();
    return super.close();
  }
}
