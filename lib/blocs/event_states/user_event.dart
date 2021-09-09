part of '../user_bloc.dart';

abstract class UserEvent extends Equatable {
  UserEvent();
}

class UserUpdateProfile extends UserEvent {
  final String name;
  final String? imageToUpload;

  UserUpdateProfile({required this.name, required this.imageToUpload});

  @override
  List<Object?> get props => [name, imageToUpload];
}

class UserReLogin extends UserEvent {
  @override
  List<Object?> get props => [];
}

class UserLogout extends UserEvent {
  @override
  List<Object?> get props => [];
}

class UserLogin extends UserEvent {
  final String email;
  final String password;

  UserLogin({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class UserRegister extends UserEvent {
  final String name;
  final String email;
  final String password;

  UserRegister({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [name, email, password];
}
