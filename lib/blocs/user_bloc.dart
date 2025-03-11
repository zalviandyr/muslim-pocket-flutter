import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_pocket/config/configs.dart';
import 'package:muslim_pocket/helpers/helpers.dart';
import 'package:muslim_pocket/models/models.dart';
import 'package:muslim_pocket/ui/widgets/widgets.dart';

part 'event_states/user_event.dart';
part 'event_states/user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  UserBloc() : super(UserUninitialized()) {
    on(_onUserRegister);
    on(_onUserLogin);
    on(_onUserReLogin);
    on(_onUserLogout);
    on(_onUserUpdateProfile);
  }

  Future<void> _onUserRegister(
      UserRegister event, Emitter<UserState> emit) async {
    try {
      emit(UserLoading());

      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      User user = credential.user!;
      await user.updateDisplayName(event.name);

      // Inisialisasi data di Firebase Realtime Database
      DatabaseReference ref = FirebaseHelper.userRef();
      await ref.child(JadwalShalat.path).set(JadwalShalat.setCityToMap());

      showInfo(Word.registerSuccess);
      emit(UserRegisterSuccess());
    } on FirebaseAuthException catch (err) {
      _handleAuthError(err, emit);
    } catch (err) {
      print(err);
      showError(ValidationWord.globalError);
      emit(UserError());
    }
  }

  Future<void> _onUserLogin(UserLogin event, Emitter<UserState> emit) async {
    try {
      emit(UserLoading());

      await _auth.signInWithEmailAndPassword(
          email: event.email, password: event.password);

      showInfo(Word.loginSuccess);

      User user = _auth.currentUser!;
      String? imageProfile = await FirebaseHelper.imageProfile(user.uid);

      emit(UserLoginSuccess(
          name: user.displayName!, imageProfile: imageProfile));
    } on FirebaseAuthException catch (err) {
      _handleAuthError(err, emit);
    } catch (err) {
      print(err);
      showError(ValidationWord.globalError);
      emit(UserError());
    }
  }

  Future<void> _onUserReLogin(
      UserReLogin event, Emitter<UserState> emit) async {
    User user = _auth.currentUser!;
    String? imageProfile = await FirebaseHelper.imageProfile(user.uid);

    emit(UserLoginSuccess(name: user.displayName!, imageProfile: imageProfile));
  }

  Future<void> _onUserLogout(UserLogout event, Emitter<UserState> emit) async {
    await _auth.signOut();
    emit(UserUninitialized());
  }

  Future<void> _onUserUpdateProfile(
      UserUpdateProfile event, Emitter<UserState> emit) async {
    try {
      emit(UserLoading());

      User user = _auth.currentUser!;
      await user.updateDisplayName(event.name);

      // Upload image jika ada
      if (event.imageToUpload != null) {
        await _uploadProfileImage(user.uid, event.imageToUpload!);
      }

      showInfo(Word.updateNameSuccess);

      add(UserReLogin());
    } on FirebaseAuthException catch (err) {
      _handleAuthError(err, emit);
    } catch (err) {
      print(err);
      showError(ValidationWord.globalError);
      emit(UserError());
    }
  }

  Future<void> _uploadProfileImage(String userId, String imagePath) async {
    File file = File(imagePath);
    String ext = path.extension(imagePath);
    String filePath = "$userId$ext";

    // Hapus file lama jika ada
    List<Reference> items = (await _storage.ref().list()).items;
    for (Reference item in items) {
      String uid = item.name.split('.')[0];
      if (uid == userId) {
        await _storage.ref(item.fullPath).delete();
      }
    }

    // Upload file baru
    await _storage.ref(filePath).putFile(file);
  }

  void _handleAuthError(FirebaseAuthException err, Emitter<UserState> emit) {
    print(err);

    if (err.code == 'email-already-in-use') {
      showError(ValidationWord.emailAlreadyUse);
    } else if (err.code == 'user-not-found') {
      showError(ValidationWord.userNotFound);
    } else {
      showError(ValidationWord.globalError);
    }

    emit(UserError());
  }
}
