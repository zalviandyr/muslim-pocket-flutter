import 'package:equatable/equatable.dart';
import 'package:muslim_pocket/models/models.dart';

abstract class ShalatState extends Equatable {
  ShalatState();
}

class ShalatUninitialized extends ShalatState {
  @override
  List<Object?> get props => [];
}

class ShalatLoading extends ShalatState {
  @override
  List<Object?> get props => [];
}

class ShalatError extends ShalatState {
  @override
  List<Object?> get props => [];
}

class ShalatScreenFetchSuccess extends ShalatState {
  final String shalatLocation;
  final List<String> cities;
  final List<JadwalShalat> listShalatSchedule;
  final NextShalat nextShalatSchedule;
  final List<NiatBacaanShalat> niatShalat;
  final List<NiatBacaanShalat> bacaanShalat;

  ShalatScreenFetchSuccess({
    required this.shalatLocation,
    required this.cities,
    required this.listShalatSchedule,
    required this.nextShalatSchedule,
    required this.niatShalat,
    required this.bacaanShalat,
  });

  @override
  List<Object?> get props => [
        cities,
        shalatLocation,
        listShalatSchedule,
        nextShalatSchedule,
        niatShalat,
        bacaanShalat,
      ];
}
