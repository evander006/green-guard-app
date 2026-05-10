// lib/presentation/calendar/bloc/calendar_event.dart
import 'package:equatable/equatable.dart';

abstract class CalendarEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadWateringScheduleRequested extends CalendarEvent {
  final DateTime startDate;
  final DateTime endDate;
  
  LoadWateringScheduleRequested({
    required this.startDate,
    required this.endDate,
  });
  
  @override
  List<Object?> get props => [startDate, endDate];
}

class MarkPlantWatered extends CalendarEvent {
  final String plantId;
  final DateTime wateredDate;
  
  MarkPlantWatered({
    required this.plantId,
    required this.wateredDate,
  });
  
  @override
  List<Object?> get props => [plantId, wateredDate];
}