import 'package:flutter/material.dart';
import 'package:muslim_pocket/config/configs.dart';
import 'package:muslim_pocket/models/models.dart';
import 'package:muslim_pocket/ui/widgets/widgets.dart';

class PrayerDetailScreen extends StatelessWidget {
  final String appBarTitle;
  final List<Doa> prayer;

  const PrayerDetailScreen({required this.appBarTitle, required this.prayer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(
            horizontal: Measure.horizontalPadding,
            vertical: Measure.verticalPadding),
        itemBuilder: (context, index) {
          Doa data = prayer[index];

          if (prayer.length == 1) {
            return ArabicCard(
              title: '',
              arabic: data.arabic,
              latin: data.latin,
              translate: data.description,
            );
          } else {
            return ArabicCard(
              title: '${index + 1}. ${data.title}',
              arabic: data.arabic,
              latin: data.latin,
              translate: data.description,
            );
          }
        },
        itemCount: prayer.length,
      ),
    );
  }
}
