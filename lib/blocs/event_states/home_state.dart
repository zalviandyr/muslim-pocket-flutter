import 'package:equatable/equatable.dart';
import 'package:muslim_pocket/models/models.dart';

abstract class HomeState extends Equatable {
  HomeState();
}

class HomeUninitialized extends HomeState {
  @override
  List<Object?> get props => [];
}

class HomeLoading extends HomeState {
  @override
  List<Object?> get props => [];
}

class HomeError extends HomeState {
  @override
  List<Object?> get props => [];
}

class HomeScreenFetchSuccess extends HomeState {
  final AsmaulHusna asmaulHusna;
  final String shalatLocation;
  final NextShalat nextShalatSchedule;
  final Quote quote;
  final QuranSurat? lastRead;

  HomeScreenFetchSuccess({
    required this.asmaulHusna,
    required this.shalatLocation,
    required this.nextShalatSchedule,
    required this.quote,
    required this.lastRead,
  });

  @override
  List<Object?> get props => [
        asmaulHusna,
        shalatLocation,
        nextShalatSchedule,
        quote,
        lastRead,
      ];
}
