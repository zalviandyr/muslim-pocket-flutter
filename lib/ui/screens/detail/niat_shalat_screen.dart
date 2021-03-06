import 'package:flutter/material.dart';
import 'package:muslim_pocket/config/configs.dart';
import 'package:muslim_pocket/models/models.dart';
import 'package:muslim_pocket/ui/widgets/widgets.dart';

class NiatShalatScreen extends StatelessWidget {
  final List<NiatBacaanShalat> niatShalat;

  const NiatShalatScreen({required this.niatShalat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Word.niatShalat),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(
            horizontal: Measure.horizontalPadding,
            vertical: Measure.verticalPadding),
        itemBuilder: (context, index) {
          NiatBacaanShalat data = niatShalat[index];

          return ArabicCard(
            title: '${index + 1}. ${data.name}',
            arabic: data.arabic,
            latin: data.latin,
            translate: data.translate,
          );
        },
        itemCount: niatShalat.length,
      ),
    );
  }
}
