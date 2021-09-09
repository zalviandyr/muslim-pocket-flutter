import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:muslim_pocket/blocs/blocs.dart';
import 'package:muslim_pocket/config/configs.dart';
import 'package:muslim_pocket/models/models.dart';
import 'package:muslim_pocket/ui/screens/screens.dart';
import 'package:muslim_pocket/ui/widgets/widgets.dart';

class DoaScreen extends StatefulWidget {
  @override
  _DoaScreenState createState() => _DoaScreenState();
}

class _DoaScreenState extends State<DoaScreen> {
  late PrayerScreenBloc _prayerScreenBloc;

  @override
  void initState() {
    _prayerScreenBloc = BlocProvider.of<PrayerScreenBloc>(context);
    super.initState();
  }

  void _navigationListener(BuildContext context, int state) {
    if (state == 3 && !(_prayerScreenBloc.state is PrayerScreenFetchSuccess)) {
      _prayerScreenBloc.add(PrayerScreenFetch());
    }
  }

  void _toPrayerDetailScreen(String appBarTitle, List<Doa> prayer) {
    Get.to(() => PrayerDetailScreen(appBarTitle: appBarTitle, prayer: prayer));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NavigationCubit, int>(
      listener: _navigationListener,
      child: Scaffold(
        body: BlocBuilder<PrayerScreenBloc, PrayerState>(
          builder: (context, state) {
            if (state is PrayerScreenFetchSuccess) {
              return ListView(
                padding: const EdgeInsets.only(
                  left: Measure.screenHorizontalPadding,
                  right: Measure.screenHorizontalPadding,
                  bottom: Measure.screenBottomPadding,
                ),
                children: [
                  SecondaryButton(
                    label: Word.ayatKursi,
                    onTap: () =>
                        _toPrayerDetailScreen(Word.ayatKursi, state.ayatKursi),
                  ),
                  const SizedBox(height: 10.0),
                  SecondaryButton(
                    label: Word.daily,
                    onTap: () => _toPrayerDetailScreen(Word.daily, state.daily),
                  ),
                  const SizedBox(height: 10.0),
                  SecondaryButton(
                    label: Word.tahlil,
                    onTap: () =>
                        _toPrayerDetailScreen(Word.tahlil, state.tahlil),
                  ),
                  const SizedBox(height: 10.0),
                  SecondaryButton(
                    label: Word.wirid,
                    onTap: () => _toPrayerDetailScreen(Word.wirid, state.wirid),
                  ),
                ],
              );
            }

            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
