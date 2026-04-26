// lib/presentation/home/bloc/home_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_guard/domain/usecases/plants_usecase.dart';
import 'package:green_guard/presentation/home/bloc/home_event.dart';
import 'package:green_guard/presentation/home/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetPlantsUseCase getPlantsUseCase;

  HomeBloc({required this.getPlantsUseCase}) : super(HomeInitial()) {
    on<HomePlantsRequested>(_onPlantsRequested);
  }

  Future<void> _onPlantsRequested(
    HomePlantsRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    try {
      final plants = await getPlantsUseCase(category: event.category);
      emit(HomeLoaded(
        plants: plants,
        selectedCategory: event.category ?? 'All',
      ));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
