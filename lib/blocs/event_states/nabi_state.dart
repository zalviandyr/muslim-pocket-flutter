import 'package:equatable/equatable.dart';
import 'package:muslim_pocket/models/models.dart';

abstract class NabiState extends Equatable {
  NabiState();
}

class NabiUninitialized extends NabiState {
  @override
  List<Object?> get props => [];
}

class NabiLoading extends NabiState {
  @override
  List<Object?> get props => [];
}

class NabiError extends NabiState {
  @override
  List<Object?> get props => [];
}

class NabiScreenFetchSuccess extends NabiState {
  final List<Nabi> nabi;

  NabiScreenFetchSuccess({required this.nabi});

  @override
  List<Object?> get props => [nabi];
}

class NabiDetailScreenFetchSuccess extends NabiState {
  final NabiDetail nabiDetail;

  NabiDetailScreenFetchSuccess({required this.nabiDetail});

  @override
  List<Object?> get props => [nabiDetail];
}
