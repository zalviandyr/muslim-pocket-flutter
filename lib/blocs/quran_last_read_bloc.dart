import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_pocket/blocs/blocs.dart';
import 'package:muslim_pocket/config/configs.dart';
import 'package:muslim_pocket/helpers/helpers.dart';
import 'package:muslim_pocket/models/models.dart';
import 'package:muslim_pocket/ui/widgets/widgets.dart';

class QuranLastReadBloc extends Bloc<QuranEvent, QuranState> {
  QuranLastReadBloc() : super(QuranUninitialized()) {
    on<QuranFetchLastRead>(_onQuranFetchLastRead);
    on<QuranSaveLastRead>(_onQuranSaveLastRead);
  }

  Future<void> _onQuranFetchLastRead(
      QuranFetchLastRead event, Emitter<QuranState> emit) async {
    try {
      emit(QuranLoading());

      final ref = FirebaseHelper.userRef();
      final snapshot = await ref.child(QuranSurat.path).get();
      final lastRead = QuranSurat.fromMap(snapshot.value);

      emit(QuranFetchLastReadSuccess(lastRead: lastRead));
    } catch (err) {
      print(err);
      showError(ValidationWord.globalError);
      emit(QuranError());
    }
  }

  Future<void> _onQuranSaveLastRead(
      QuranSaveLastRead event, Emitter<QuranState> emit) async {
    try {
      final ref = FirebaseHelper.userRef();
      await ref.child(QuranSurat.path).set(event.lastRead.toMap());

      // Re-fetch after saving
      add(QuranFetchLastRead());
    } catch (err) {
      print(err);
      showError(ValidationWord.globalError);
      emit(QuranError());
    }
  }
}
