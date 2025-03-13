import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_pocket/blocs/blocs.dart';
import 'package:muslim_pocket/config/configs.dart';
import 'package:muslim_pocket/service.dart';
import 'package:muslim_pocket/ui/widgets/widgets.dart';

class NabiScreenBloc extends Bloc<NabiEvent, NabiState> {
  NabiScreenBloc() : super(NabiUninitialized()) {
    on<NabiScreenFetch>(_onNabiScreenFetch);
  }

  Future<void> _onNabiScreenFetch(
      NabiScreenFetch event, Emitter<NabiState> emit) async {
    try {
      emit(NabiLoading());

      final nabi = await Service.getNabi();

      emit(NabiScreenFetchSuccess(nabi: nabi));
    } catch (err, trace) {
      onError(err, trace);
      showError(ValidationWord.globalError);
      emit(NabiError());
    }
  }
}
