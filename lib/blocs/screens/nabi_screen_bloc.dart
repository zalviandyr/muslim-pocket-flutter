import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_pocket/blocs/blocs.dart';
import 'package:muslim_pocket/config/configs.dart';
import 'package:muslim_pocket/models/models.dart';
import 'package:muslim_pocket/service.dart';
import 'package:muslim_pocket/ui/widgets/widgets.dart';

class NabiScreenBloc extends Bloc<NabiEvent, NabiState> {
  NabiScreenBloc() : super(NabiUninitialized());

  @override
  Stream<NabiState> mapEventToState(NabiEvent event) async* {
    try {
      if (event is NabiScreenFetch) {
        yield NabiLoading();

        List<Nabi> nabi = await Service.getNabi();

        yield NabiScreenFetchSuccess(nabi: nabi);
      }
    } catch (err) {
      print(err);

      showError(ValidationWord.globalError);

      yield NabiError();
    }
  }
}
