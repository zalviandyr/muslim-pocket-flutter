import 'package:equatable/equatable.dart';

abstract class PrayerEvent extends Equatable {
  PrayerEvent();
}

class PrayerScreenFetch extends PrayerEvent {
  @override
  List<Object?> get props => [];
}
