import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_pocket/blocs/blocs.dart';
import 'package:muslim_pocket/config/configs.dart';
import 'package:muslim_pocket/helpers/helpers.dart';
import 'package:muslim_pocket/models/models.dart';
import 'package:muslim_pocket/service.dart';
import 'package:muslim_pocket/ui/widgets/widgets.dart';

class HomeScreenBloc extends Bloc<HomeEvent, HomeState> {
  HomeScreenBloc() : super(HomeUninitialized());

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    try {
      if (event is HomeScreenFetch) {
        yield HomeLoading();

        DatabaseReference ref = FirebaseHelper.userRef();
        String city = JadwalShalat.getCityFromMap((await ref.get()).value);

        AsmaulHusna asmaulHusna = await Service.getRandomAsmaulHusna();
        List<JadwalShalat> shalatSchedule =
            await Service.getShalatSchedule(city.toLowerCase());
        NextShalat nextShalat = ShalatHelper.getNextShalat(shalatSchedule);
        Quote quote = await Service.getRandomQuote();
        QuranSurat? quranSurat =
            QuranSurat.fromMap((await ref.child(QuranSurat.path).get()).value);

        yield HomeScreenFetchSuccess(
          asmaulHusna: asmaulHusna,
          shalatLocation: city,
          nextShalatSchedule: nextShalat,
          quote: quote,
          lastRead: quranSurat,
        );
      }
    } catch (err) {
      print(err);

      showError(ValidationWord.globalError);

      yield HomeError();
    }
  }
}
