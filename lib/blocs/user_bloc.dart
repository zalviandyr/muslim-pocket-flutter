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
  UserBloc() : super(UserUninitialized());

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    try {
      if (event is UserRegister) {
        yield UserLoading();

        FirebaseAuth auth = FirebaseAuth.instance;
        UserCredential credential = await auth.createUserWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        User user = credential.user!;
        user.updateDisplayName(event.name);

        // create init data
        DatabaseReference ref = FirebaseHelper.userRef();
        ref.child(JadwalShalat.path).set(JadwalShalat.setCityToMap());

        showInfo(Word.registerSuccess);

        yield UserRegisterSuccess();
      }

      if (event is UserLogin) {
        yield UserLoading();

        FirebaseAuth auth = FirebaseAuth.instance;
        await auth.signInWithEmailAndPassword(
            email: event.email, password: event.password);

        showInfo(Word.loginSuccess);

        User user = auth.currentUser!;
        String? imageProfile = await FirebaseHelper.imageProfile(user.uid);

        yield UserLoginSuccess(
            name: user.displayName!, imageProfile: imageProfile);
      }

      if (event is UserReLogin) {
        User user = FirebaseAuth.instance.currentUser!;
        String? imageProfile = await FirebaseHelper.imageProfile(user.uid);

        yield UserLoginSuccess(
            name: user.displayName!, imageProfile: imageProfile);
      }

      if (event is UserLogout) {
        FirebaseAuth.instance.signOut();
        yield UserUninitialized();
      }

      if (event is UserUpdateProfile) {
        yield UserLoading();

        User user = FirebaseAuth.instance.currentUser!;
        await user.updateDisplayName(event.name);

        // upload image to fire storage
        if (event.imageToUpload != null) {
          File file = File(event.imageToUpload!);
          String ext = path.extension(event.imageToUpload!);
          String filePath = user.uid + ext;
          FirebaseStorage storage = FirebaseStorage.instance;

          // delete old file if exist
          List<Reference> items = (await storage.ref().list()).items;
          for (Reference item in items) {
            String uid = item.name.split('.')[0];
            if (uid == user.uid) {
              await storage.ref(item.fullPath).delete();
            }
          }

          // upload
          await storage.ref(filePath).putFile(file);
        }

        showInfo(Word.updateNameSuccess);

        this.add(UserReLogin());
      }
    } on FirebaseAuthException catch (err) {
      print(err);

      if (err.code == 'email-already-in-use') {
        showError(ValidationWord.emailAlreadyUse);
      } else if (err.code == 'user-not-found') {
        showError(ValidationWord.userNotFound);
      }

      yield UserError();
    } catch (err) {
      print(err);

      showError(ValidationWord.globalError);

      yield UserError();
    }
  }
}
