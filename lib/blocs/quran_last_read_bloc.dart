import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_pocket/blocs/blocs.dart';
import 'package:muslim_pocket/config/configs.dart';
import 'package:muslim_pocket/helpers/helpers.dart';
import 'package:muslim_pocket/models/models.dart';
import 'package:muslim_pocket/ui/widgets/widgets.dart';

class QuranLastReadBloc extends Bloc<QuranEvent, QuranState> {
  QuranLastReadBloc() : super(QuranUninitialized());

  @override
  Stream<QuranState> mapEventToState(QuranEvent event) async* {
    try {
      if (event is QuranFetchLastRead) {
        yield QuranLoading();

        DatabaseReference ref = FirebaseHelper.userRef();
        QuranSurat? lastRead =
            QuranSurat.fromMap((await ref.child(QuranSurat.path).get()).value);

        yield QuranFetchLastReadSuccess(lastRead: lastRead);
      }

      if (event is QuranSaveLastRead) {
        DatabaseReference ref = FirebaseHelper.userRef();
        ref.child(QuranSurat.path).set(event.lastRead.toMap());

        // re-fetch
        this.add(QuranFetchLastRead());
      }
    } catch (err) {
      print(err);

      showError(ValidationWord.globalError);

      yield QuranError();
    }
  }
}
