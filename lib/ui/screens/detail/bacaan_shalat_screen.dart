import 'package:flutter/material.dart';
import 'package:muslim_pocket/config/configs.dart';
import 'package:muslim_pocket/models/models.dart';
import 'package:muslim_pocket/ui/widgets/widgets.dart';

class BacaanShalatScreen extends StatelessWidget {
  final List<NiatBacaanShalat> bacaanShalat;

  const BacaanShalatScreen({required this.bacaanShalat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Word.bacaanShalat),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(
            horizontal: Measure.horizontalPadding,
            vertical: Measure.verticalPadding),
        itemBuilder: (context, index) {
          NiatBacaanShalat data = bacaanShalat[index];

          return ArabicCard(
            title: '${index + 1}. ${data.name}',
            arabic: data.arabic,
            latin: data.latin,
            translate: data.translate,
          );
        },
        itemCount: bacaanShalat.length,
      ),
    );
  }
}
