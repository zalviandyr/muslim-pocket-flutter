import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_pocket/blocs/blocs.dart';
import 'package:muslim_pocket/config/configs.dart';
import 'package:muslim_pocket/helpers/helpers.dart';
import 'package:muslim_pocket/models/models.dart';
import 'package:muslim_pocket/service.dart';
import 'package:muslim_pocket/ui/widgets/widgets.dart';

class QuranDetailScreenBloc extends Bloc<QuranEvent, QuranState> {
  QuranDetailScreenBloc() : super(QuranUninitialized());

  @override
  Stream<QuranState> mapEventToState(QuranEvent event) async* {
    try {
      if (event is QuranDetailScreenFetch) {
        yield QuranLoading();

        QuranSurat quranSurat = event.quranSurat;

        DatabaseReference ref = FirebaseHelper.userRef();
        QuranSurat? lastRead =
            QuranSurat.fromMap((await ref.child(QuranSurat.path).get()).value);
        List<QuranAyat> quranAyat = await Service.getQuranAyat(
            quranSurat.order, '1-${quranSurat.countOfAyat}');

        yield QuranDetailScreenFetchSuccess(
          quranAyat: quranAyat,
          lastRead: lastRead,
        );
      }
    } catch (err) {
      print(err);

      showError(ValidationWord.globalError);

      yield QuranError();
    }
  }
}
