import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_pocket/blocs/blocs.dart';
import 'package:muslim_pocket/config/configs.dart';
import 'package:muslim_pocket/service.dart';
import 'package:muslim_pocket/ui/widgets/widgets.dart';

class NabiDetailScreenBloc extends Bloc<NabiEvent, NabiState> {
  NabiDetailScreenBloc() : super(NabiUninitialized()) {
    on<NabiDetailScreenFetch>(_onNabiDetailScreenFetch);
  }

  Future<void> _onNabiDetailScreenFetch(
      NabiDetailScreenFetch event, Emitter<NabiState> emit) async {
    try {
      emit(NabiLoading());

      final nabiDetail = await Service.getNabiDetail(event.slug);

      emit(NabiDetailScreenFetchSuccess(nabiDetail: nabiDetail));
    } catch (err, trace) {
      onError(err, trace);
      showError(ValidationWord.globalError);
      emit(NabiError());
    }
  }
}
