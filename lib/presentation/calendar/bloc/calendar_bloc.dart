import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_guard/domain/usecases/get_watering_schedule_use_case.dart';
import 'package:green_guard/domain/usecases/plants_usecase.dart';
import 'package:green_guard/presentation/calendar/bloc/calendar_event.dart';
import 'package:green_guard/presentation/calendar/bloc/calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final GetWateringScheduleUseCase getWateringScheduleUseCase;
  final UpdatePlantUseCase updatePlantUseCase;
  CalendarBloc({
    required this.getWateringScheduleUseCase,
    required this.updatePlantUseCase,
  }) : super(CalendarInitial()) {
    on<LoadWateringScheduleRequested>(_onLoadSchedule);
    on<MarkPlantWatered>(_onMarkWatered);
  }

  Future<void> _onLoadSchedule(
    LoadWateringScheduleRequested event,
    Emitter<CalendarState> emit,
  ) async {
    emit(CalendarLoading());
    try {
      final schedule = await getWateringScheduleUseCase(
        startDate: event.startDate,
        endDate: event.endDate,
      );
      emit(WateringScheduleLoaded(schedule));
    } catch (e) {
      emit(CalendarError(e.toString()));
    }
  }

  Future<void> _onMarkWatered(
    MarkPlantWatered event,
    Emitter<CalendarState> emit,
  ) async {
    try {
      emit(PlantWatered(event.plantId));
    } catch (e) {
      emit(CalendarError(e.toString()));
    }
  }
}
