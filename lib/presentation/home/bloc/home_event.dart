// lib/presentation/home/bloc/home_event.dart
import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomePlantsRequested extends HomeEvent {
  final String? category;
  HomePlantsRequested({this.category});
  @override
  List<Object?> get props => [category];
}

