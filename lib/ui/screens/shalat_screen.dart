import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:muslim_pocket/blocs/blocs.dart';
import 'package:muslim_pocket/config/configs.dart';
import 'package:muslim_pocket/models/models.dart';
import 'package:muslim_pocket/ui/screens/screens.dart';
import 'package:muslim_pocket/ui/widgets/widgets.dart';

class ShalatScreen extends StatefulWidget {
  @override
  _ShalatScreenState createState() => _ShalatScreenState();
}

class _ShalatScreenState extends State<ShalatScreen> {
  late ShalatScreenBloc _shalatScreenBloc;
  DateTime _dateNow = DateTime.now();

  @override
  void initState() {
    _shalatScreenBloc = BlocProvider.of<ShalatScreenBloc>(context);

    super.initState();
  }

  void _cityAction(ShalatScreenFetchSuccess state) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: Measure.horizontalPadding,
              vertical: Measure.verticalPadding,
            ),
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: Measure.verticalPadding * 0.5),
                  child: Text(Word.chooseCity),
                );
              } else {
                String city = state.cities[index - 1];

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: Measure.verticalPadding * 0.5),
                  child: SecondaryButton(
                      label: city,
                      onTap: () {
                        _selectedCityAction(city);

                        Get.back();
                      }),
                );
              }
            },
            itemCount: state.cities.length + 1,
          ),
        );
      },
    );
  }

  void _selectedCityAction(String city) {
    _shalatScreenBloc.add(ShalatFetchCity(city: city));
  }

  void _prevDateAction() {
    setState(() {
      if (_dateNow.day != 1) _dateNow = _dateNow.subtract(Duration(days: 1));
    });
  }

  void _nextDateAction() {
    setState(() {
      int lastDay = DateTime(_dateNow.year, _dateNow.month + 1, 0).day;
      if (_dateNow.day != lastDay) _dateNow = _dateNow.add(Duration(days: 1));
    });
  }

  void _toNiatShalatScreen(List<NiatBacaanShalat> niatShalat) {
    Get.to(() => NiatShalatScreen(niatShalat: niatShalat));
  }

  void _toBacaanShalatScreen(List<NiatBacaanShalat> bacaanShalat) {
    Get.to(() => BacaanShalatScreen(bacaanShalat: bacaanShalat));
  }

  void _navigationListener(BuildContext context, int state) {
    if (state == 1 && !(_shalatScreenBloc.state is ShalatScreenFetchSuccess)) {
      _shalatScreenBloc.add(ShalatScreenFetch());
    }
  }

  void _toArahQiblatScreen() {
    Get.to(() => ArahQiblat());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NavigationCubit, int>(
      listener: _navigationListener,
      child: Scaffold(
        body: BlocBuilder<ShalatScreenBloc, ShalatState>(
          builder: (context, state) {
            if (state is ShalatScreenFetchSuccess) {
              return ListView(
                padding: const EdgeInsets.only(
                  left: Measure.screenHorizontalPadding,
                  right: Measure.screenHorizontalPadding,
                  bottom: Measure.screenBottomPadding,
                ),
                children: [
                  SecondaryButton(
                    label: state.shalatLocation,
                    icon: Icons.expand_more,
                    onTap: () => _cityAction(state),
                  ),
                  const SizedBox(height: 20.0),
                  _buildPrayerTime(state),
                  const SizedBox(height: 20.0),
                  _buildDetailPrayerTime(state),
                  const SizedBox(height: 20.0),
                  SecondaryButton(
                    label: Word.niatShalat,
                    onTap: () => _toNiatShalatScreen(state.niatShalat),
                  ),
                  const SizedBox(height: 10.0),
                  SecondaryButton(
                    label: Word.bacaanShalat,
                    onTap: () => _toBacaanShalatScreen(state.bacaanShalat),
                  ),
                  const SizedBox(height: 10.0),
                  SecondaryButton(
                    label: Word.arahQiblat,
                    onTap: () => _toArahQiblatScreen(),
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

  Widget _buildPrayerTime(ShalatScreenFetchSuccess state) {
    return Container(
      height: 160.0,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: Pallette.boxShadow,
        borderRadius: BorderRadius.circular(Measure.borderRadius),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: Transform(
              alignment: Alignment.bottomCenter,
              transform: Matrix4.rotationY(math.pi),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(Measure.borderRadius)),
                child: Image.asset(
                  Asset.mosqueImage,
                  height: 130.0,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: Measure.horizontalPadding,
                  vertical: Measure.verticalPadding),
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(Measure.borderRadius),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.nextShalatSchedule.shalat,
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  const Spacer(),
                  Text(
                    state.nextShalatSchedule.time,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  const SizedBox(height: 5.0),
                  Text('Sholat selanjutnya'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailPrayerTime(ShalatScreenFetchSuccess state) {
    JadwalShalat schedule =
        state.listShalatSchedule.where((e) => e.date.day == _dateNow.day).first;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
              vertical: Measure.verticalPadding,
              horizontal: Measure.horizontalPadding),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: Pallette.boxShadow,
            borderRadius: BorderRadius.circular(Measure.borderRadius),
          ),
          child: Row(
            children: [
              MaterialButton(
                onPressed: _prevDateAction,
                minWidth: 0.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Measure.borderRadius)),
                child: Icon(Icons.chevron_left),
              ),
              const Spacer(),
              Text(
                schedule.dateFormat,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              const Spacer(),
              MaterialButton(
                onPressed: _nextDateAction,
                minWidth: 0.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Measure.borderRadius)),
                child: Icon(Icons.chevron_right),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20.0),
        Container(
          padding:
              const EdgeInsets.symmetric(vertical: Measure.verticalPadding),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: Pallette.boxShadow,
            borderRadius: BorderRadius.circular(Measure.borderRadius),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PrayerScheduleItem(label: 'Imsyak', time: schedule.imsyak),
              PrayerScheduleItem(label: 'Shubuh', time: schedule.shubuh),
              PrayerScheduleItem(label: 'Terbit', time: schedule.rise),
              PrayerScheduleItem(label: 'Dhuha', time: schedule.dhuha),
              PrayerScheduleItem(label: 'Dzuhur', time: schedule.dzuhur),
              PrayerScheduleItem(label: 'Ashr', time: schedule.ashr),
              PrayerScheduleItem(label: 'Magrib', time: schedule.magrib),
              PrayerScheduleItem(label: 'Isya', time: schedule.isya),
            ],
          ),
        ),
      ],
    );
  }
}
