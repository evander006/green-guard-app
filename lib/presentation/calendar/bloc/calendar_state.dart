// lib/presentation/calendar/bloc/calendar_state.dart
import 'package:equatable/equatable.dart';
import 'package:green_guard/domain/entities/plant_entity.dart';

abstract class CalendarState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CalendarInitial extends CalendarState {}
class CalendarLoading extends CalendarState {}
class WateringScheduleLoaded extends CalendarState {
  final Map<DateTime, List<PlantEntity>> schedule;
  
  WateringScheduleLoaded(this.schedule);
  
  @override
  List<Object?> get props => [schedule];
}
class CalendarError extends CalendarState {
  final String message;
  CalendarError(this.message);
  @override
  List<Object?> get props => [message];
}
class PlantWatered extends CalendarState {
  final String plantId;
  PlantWatered(this.plantId);
  @override
  List<Object?> get props => [plantId];
}