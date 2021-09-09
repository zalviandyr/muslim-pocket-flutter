import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  HomeEvent();
}

class HomeScreenFetch extends HomeEvent {
  @override
  List<Object?> get props => [];
}
