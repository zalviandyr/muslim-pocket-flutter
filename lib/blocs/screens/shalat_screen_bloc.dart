import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:muslim_pocket/blocs/blocs.dart';
import 'package:muslim_pocket/config/configs.dart';
import 'package:muslim_pocket/helpers/helpers.dart';
import 'package:muslim_pocket/models/models.dart';
import 'package:muslim_pocket/service.dart';
import 'package:muslim_pocket/ui/widgets/widgets.dart';

class ShalatScreenBloc extends Bloc<ShalatEvent, ShalatState> {
  final HomeScreenBloc _homeScreenBloc;

  ShalatScreenBloc()
      : _homeScreenBloc = BlocProvider.of<HomeScreenBloc>(Get.context!),
        super(ShalatUninitialized()) {
    on<ShalatScreenFetch>(_onShalatScreenFetch);
    on<ShalatFetchCity>(_onShalatFetchCity);
  }

  Future<void> _onShalatScreenFetch(
      ShalatScreenFetch event, Emitter<ShalatState> emit) async {
    try {
      emit(ShalatLoading());

      final ref = FirebaseHelper.userRef();
      final city = JadwalShalat.getCityFromMap((await ref.get()).value);

      final cities = await Service.getShalatCity();
      final shalatSchedule =
          await Service.getShalatSchedule(city.toLowerCase());
      final nextShalat = ShalatHelper.getNextShalat(shalatSchedule);
      final niatShalat = await Service.getNiatShalat();
      final bacaanShalat = await Service.getBacaanShalat();

      emit(ShalatScreenFetchSuccess(
        cities: cities,
        shalatLocation: city,
        listShalatSchedule: shalatSchedule,
        nextShalatSchedule: nextShalat,
        niatShalat: niatShalat,
        bacaanShalat: bacaanShalat,
      ));
    } catch (err) {
      print(err);
      showError(ValidationWord.globalError);
      emit(ShalatError());
    }
  }

  Future<void> _onShalatFetchCity(
      ShalatFetchCity event, Emitter<ShalatState> emit) async {
    try {
      final ref = FirebaseHelper.userRef();
      await ref
          .child(JadwalShalat.path)
          .set(JadwalShalat.setCityToMap(city: event.city));

      // Re-fetch home screen
      _homeScreenBloc.add(HomeScreenFetch());

      // Fetch updated shalat data
      add(ShalatScreenFetch());
    } catch (err) {
      print(err);
      showError(ValidationWord.globalError);
      emit(ShalatError());
    }
  }
}
