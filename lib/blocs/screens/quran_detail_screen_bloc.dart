import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_pocket/blocs/blocs.dart';
import 'package:muslim_pocket/config/configs.dart';
import 'package:muslim_pocket/helpers/helpers.dart';
import 'package:muslim_pocket/models/models.dart';
import 'package:muslim_pocket/service.dart';
import 'package:muslim_pocket/ui/widgets/widgets.dart';

class QuranDetailScreenBloc extends Bloc<QuranEvent, QuranState> {
  QuranDetailScreenBloc() : super(QuranUninitialized()) {
    on<QuranDetailScreenFetch>(_onQuranDetailScreenFetch);
  }

  Future<void> _onQuranDetailScreenFetch(
      QuranDetailScreenFetch event, Emitter<QuranState> emit) async {
    try {
      emit(QuranLoading());

      final quranSurat = event.quranSurat;
      final ref = FirebaseHelper.userRef();

      final lastRead =
          QuranSurat.fromMap((await ref.child(QuranSurat.path).get()).value);
      final quranAyat = await Service.getQuranAyat(
          quranSurat.order, '1-${quranSurat.countOfAyat}');

      emit(QuranDetailScreenFetchSuccess(
        quranAyat: quranAyat,
        lastRead: lastRead,
      ));
    } catch (err) {
      print(err);
      showError(ValidationWord.globalError);
      emit(QuranError());
    }
  }
}
