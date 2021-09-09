part of '../user_bloc.dart';

abstract class UserState extends Equatable {
  UserState();
}

class UserUninitialized extends UserState {
  @override
  List<Object?> get props => [];
}

class UserLoading extends UserState {
  @override
  List<Object?> get props => [];
}

class UserError extends UserState {
  @override
  List<Object?> get props => [];
}

class UserLoginSuccess extends UserState {
  final String name;
  final String? imageProfile;

  UserLoginSuccess({required this.name, required this.imageProfile});

  @override
  List<Object?> get props => [name, imageProfile];
}

class UserRegisterSuccess extends UserState {
  @override
  List<Object?> get props => [];
}
