import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:muslim_pocket/blocs/blocs.dart';
import 'package:muslim_pocket/config/configs.dart';
import 'package:muslim_pocket/models/models.dart';
import 'package:muslim_pocket/ui/screens/screens.dart';
import 'package:muslim_pocket/ui/widgets/widgets.dart';

class NabiScreen extends StatefulWidget {
  @override
  _NabiScreenState createState() => _NabiScreenState();
}

class _NabiScreenState extends State<NabiScreen> {
  late NabiScreenBloc _nabiScreenBloc;

  @override
  void initState() {
    _nabiScreenBloc = BlocProvider.of<NabiScreenBloc>(context);

    super.initState();
  }

  void _navigationListener(BuildContext context, int state) {
    if (state == 4 && !(_nabiScreenBloc.state is NabiScreenFetchSuccess)) {
      _nabiScreenBloc.add(NabiScreenFetch());
    }
  }

  void _toNabiDetailScreen(Nabi nabi) {
    Get.to(() => NabiDetailScreen(nabi: nabi));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NavigationCubit, int>(
      listener: _navigationListener,
      child: Scaffold(
        body: BlocBuilder<NabiScreenBloc, NabiState>(
          builder: (context, state) {
            if (state is NabiScreenFetchSuccess) {
              return ListView.builder(
                padding: const EdgeInsets.only(
                  left: Measure.screenHorizontalPadding,
                  right: Measure.screenHorizontalPadding,
                  bottom: Measure.screenBottomPadding,
                ),
                itemBuilder: (context, index) {
                  Nabi nabi = state.nabi[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: Measure.verticalPadding * 0.5),
                    child: SecondaryButton(
                      label: nabi.nabi,
                      onTap: () => _toNabiDetailScreen(nabi),
                    ),
                  );
                },
                itemCount: state.nabi.length,
              );
            }

            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
