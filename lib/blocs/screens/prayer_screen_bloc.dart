import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_pocket/blocs/blocs.dart';
import 'package:muslim_pocket/config/configs.dart';
import 'package:muslim_pocket/service.dart';
import 'package:muslim_pocket/ui/widgets/widgets.dart';

class PrayerScreenBloc extends Bloc<PrayerEvent, PrayerState> {
  PrayerScreenBloc() : super(PrayerUninitialized()) {
    on<PrayerScreenFetch>(_onPrayerScreenFetch);
  }

  Future<void> _onPrayerScreenFetch(
      PrayerScreenFetch event, Emitter<PrayerState> emit) async {
    try {
      emit(PrayerLoading());

      final wirid = await Service.getPrayer(PrayerEnum.wirid);
      final daily = await Service.getPrayer(PrayerEnum.daily);
      final tahlil = await Service.getPrayer(PrayerEnum.tahlil);
      final ayatKursi = await Service.getPrayer(PrayerEnum.ayatKursi);

      emit(PrayerScreenFetchSuccess(
        wirid: wirid,
        daily: daily,
        tahlil: tahlil,
        ayatKursi: ayatKursi,
      ));
    } catch (err) {
      print(err);
      showError(ValidationWord.globalError);
      emit(PrayerError());
    }
  }
}
