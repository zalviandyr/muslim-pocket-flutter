import 'package:flutter/material.dart';
import 'package:muslim_pocket/config/configs.dart';

class PrayerScheduleItem extends StatelessWidget {
  final String label;
  final String time;

  const PrayerScheduleItem({required this.label, required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Measure.horizontalPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label),
                Text(
                  time,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
          ),
          Divider(color: Pallette.black),
        ],
      ),
    );
  }
}
