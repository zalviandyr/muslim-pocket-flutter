import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_pocket/blocs/blocs.dart';
import 'package:muslim_pocket/config/configs.dart';
import 'package:muslim_pocket/models/models.dart';
import 'package:muslim_pocket/service.dart';
import 'package:muslim_pocket/ui/widgets/widgets.dart';

class NabiDetailScreenBloc extends Bloc<NabiEvent, NabiState> {
  NabiDetailScreenBloc() : super(NabiUninitialized());

  @override
  Stream<NabiState> mapEventToState(NabiEvent event) async* {
    try {
      if (event is NabiDetailScreenFetch) {
        yield NabiLoading();

        NabiDetail nabiDetail = await Service.getNabiDetail(event.slug);

        yield NabiDetailScreenFetchSuccess(nabiDetail: nabiDetail);
      }
    } catch (err) {
      print(err);

      showError(ValidationWord.globalError);

      yield NabiError();
    }
  }
}
