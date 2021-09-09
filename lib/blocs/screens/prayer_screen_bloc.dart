import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_pocket/blocs/blocs.dart';
import 'package:muslim_pocket/config/configs.dart';
import 'package:muslim_pocket/models/models.dart';
import 'package:muslim_pocket/service.dart';
import 'package:muslim_pocket/ui/widgets/widgets.dart';

class PrayerScreenBloc extends Bloc<PrayerEvent, PrayerState> {
  PrayerScreenBloc() : super(PrayerUninitialized());

  @override
  Stream<PrayerState> mapEventToState(PrayerEvent event) async* {
    try {
      if (event is PrayerScreenFetch) {
        yield PrayerLoading();

        List<Doa> wirid = await Service.getPrayer(PrayerEnum.wirid);
        List<Doa> daily = await Service.getPrayer(PrayerEnum.daily);
        List<Doa> tahlil = await Service.getPrayer(PrayerEnum.tahlil);
        List<Doa> ayatKursi = await Service.getPrayer(PrayerEnum.ayatKursi);

        yield PrayerScreenFetchSuccess(
          wirid: wirid,
          daily: daily,
          tahlil: tahlil,
          ayatKursi: ayatKursi,
        );
      }
    } catch (err) {
      print(err);

      showError(ValidationWord.globalError);

      yield PrayerError();
    }
  }
}
