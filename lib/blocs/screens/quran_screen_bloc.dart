import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_pocket/blocs/blocs.dart';
import 'package:muslim_pocket/config/configs.dart';
import 'package:muslim_pocket/service.dart';
import 'package:muslim_pocket/ui/widgets/widgets.dart';

class QuranScreenBloc extends Bloc<QuranEvent, QuranState> {
  QuranScreenBloc() : super(QuranUninitialized()) {
    on<QuranScreenFetch>(_onQuranScreenFetch);
  }

  Future<void> _onQuranScreenFetch(
      QuranScreenFetch event, Emitter<QuranState> emit) async {
    try {
      emit(QuranLoading());

      final quranSurat = await Service.getQuranSurat();

      emit(QuranScreenFetchSuccess(quranSurat: quranSurat));
    } catch (err, trace) {
      onError(err, trace);
      showError(ValidationWord.globalError);
      emit(QuranError());
    }
  }
}
