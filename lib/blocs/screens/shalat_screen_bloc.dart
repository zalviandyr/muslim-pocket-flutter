import 'package:firebase_database/firebase_database.dart';
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
        super(ShalatUninitialized());

  @override
  Stream<ShalatState> mapEventToState(ShalatEvent event) async* {
    try {
      if (event is ShalatScreenFetch) {
        yield ShalatLoading();

        DatabaseReference ref = FirebaseHelper.userRef();
        String city = JadwalShalat.getCityFromMap((await ref.get()).value);

        List<String> cities = await Service.getShalatCity();
        List<JadwalShalat> shalatSchedule =
            await Service.getShalatSchedule(city.toLowerCase());
        NextShalat nextShalat = ShalatHelper.getNextShalat(shalatSchedule);
        List<NiatBacaanShalat> niatShalat = await Service.getNiatShalat();
        List<NiatBacaanShalat> bacaanShalat = await Service.getBacaanShalat();

        yield ShalatScreenFetchSuccess(
          cities: cities,
          shalatLocation: city,
          listShalatSchedule: shalatSchedule,
          nextShalatSchedule: nextShalat,
          niatShalat: niatShalat,
          bacaanShalat: bacaanShalat,
        );
      }

      if (event is ShalatFetchCity) {
        DatabaseReference ref = FirebaseHelper.userRef();
        ref
            .child(JadwalShalat.path)
            .set(JadwalShalat.setCityToMap(city: event.city));

        // re-fetch home screen
        _homeScreenBloc.add(HomeScreenFetch());

        this.add(ShalatScreenFetch());
      }
    } catch (err) {
      print(err);

      showError(ValidationWord.globalError);

      yield ShalatError();
    }
  }
}
