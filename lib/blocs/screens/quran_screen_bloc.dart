import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_pocket/blocs/blocs.dart';
import 'package:muslim_pocket/config/configs.dart';
import 'package:muslim_pocket/models/models.dart';
import 'package:muslim_pocket/service.dart';
import 'package:muslim_pocket/ui/widgets/widgets.dart';

class QuranScreenBloc extends Bloc<QuranEvent, QuranState> {
  QuranScreenBloc() : super(QuranUninitialized());

  @override
  Stream<QuranState> mapEventToState(QuranEvent event) async* {
    try {
      if (event is QuranScreenFetch) {
        yield QuranLoading();

        List<QuranSurat> quranSurat = await Service.getQuranSurat();

        yield QuranScreenFetchSuccess(
          quranSurat: quranSurat,
        );
      }
    } catch (err) {
      print(err);

      showError(ValidationWord.globalError);

      yield QuranError();
    }
  }
}
