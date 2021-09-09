import 'package:equatable/equatable.dart';

abstract class ShalatEvent extends Equatable {
  ShalatEvent();
}

class ShalatScreenFetch extends ShalatEvent {
  @override
  List<Object?> get props => [];
}

class ShalatFetchCity extends ShalatEvent {
  final String city;

  ShalatFetchCity({required this.city});

  @override
  List<Object?> get props => [city];
}
