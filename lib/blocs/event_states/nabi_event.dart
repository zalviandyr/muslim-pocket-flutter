import 'package:equatable/equatable.dart';

abstract class NabiEvent extends Equatable {
  NabiEvent();
}

class NabiScreenFetch extends NabiEvent {
  @override
  List<Object?> get props => [];
}

class NabiDetailScreenFetch extends NabiEvent {
  final String slug;

  NabiDetailScreenFetch({required this.slug});

  @override
  List<Object?> get props => [slug];
}
