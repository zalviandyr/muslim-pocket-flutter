import 'package:equatable/equatable.dart';
import 'package:muslim_pocket/models/models.dart';

abstract class PrayerState extends Equatable {
  PrayerState();
}

class PrayerUninitialized extends PrayerState {
  @override
  List<Object?> get props => [];
}

class PrayerLoading extends PrayerState {
  @override
  List<Object?> get props => [];
}

class PrayerError extends PrayerState {
  @override
  List<Object?> get props => [];
}

class PrayerScreenFetchSuccess extends PrayerState {
  final List<Doa> wirid;
  final List<Doa> daily;
  final List<Doa> tahlil;
  final List<Doa> ayatKursi;

  PrayerScreenFetchSuccess({
    required this.wirid,
    required this.daily,
    required this.tahlil,
    required this.ayatKursi,
  });

  @override
  List<Object?> get props => [wirid, daily, tahlil, ayatKursi];
}
