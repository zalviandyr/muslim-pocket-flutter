import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_pocket/blocs/blocs.dart';
import 'package:muslim_pocket/config/configs.dart';
import 'package:muslim_pocket/helpers/helpers.dart';
import 'package:muslim_pocket/models/models.dart';
import 'package:muslim_pocket/service.dart';
import 'package:muslim_pocket/ui/widgets/widgets.dart';

class HomeScreenBloc extends Bloc<HomeEvent, HomeState> {
  HomeScreenBloc() : super(HomeUninitialized()) {
    on<HomeScreenFetch>(_onHomeScreenFetch);
  }

  Future<void> _onHomeScreenFetch(
      HomeScreenFetch event, Emitter<HomeState> emit) async {
    try {
      emit(HomeLoading());

      DatabaseReference ref = FirebaseHelper.userRef();
      DataSnapshot snapshot = await ref.get();
      String city = JadwalShalat.getCityFromMap(snapshot.value);

      final asmaulHusna = await Service.getRandomAsmaulHusna();
      final shalatSchedule =
          await Service.getShalatSchedule(city.toLowerCase());
      final nextShalat = ShalatHelper.getNextShalat(shalatSchedule);
      final quote = await Service.getRandomQuote();

      DataSnapshot quranSnapshot = await ref.child(QuranSurat.path).get();
      final quranSurat = quranSnapshot.value != null
          ? QuranSurat.fromMap(quranSnapshot.value)
          : null;

      emit(HomeScreenFetchSuccess(
        asmaulHusna: asmaulHusna,
        shalatLocation: city,
        nextShalatSchedule: nextShalat,
        quote: quote,
        lastRead: quranSurat,
      ));
    } catch (err) {
      print(err);
      showError(ValidationWord.globalError);
      emit(HomeError());
    }
  }
}
