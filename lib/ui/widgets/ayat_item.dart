import 'package:flutter/material.dart';
import 'package:muslim_pocket/config/configs.dart';
import 'package:muslim_pocket/models/models.dart';

class AyatItem extends StatelessWidget {
  final QuranAyat quranAyat;

  const AyatItem({required this.quranAyat});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: Measure.verticalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
                vertical: Measure.verticalPadding,
                horizontal: Measure.horizontalPadding),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(Measure.borderRadius),
              boxShadow: Pallette.boxShadow,
            ),
            child: Text(
              quranAyat.order,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          const SizedBox(height: 10.0),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              quranAyat.arabic,
              style: Theme.of(context).textTheme.subtitle2,
              textDirection: TextDirection.rtl,
            ),
          ),
          const SizedBox(height: 15.0),
          Text(quranAyat.translation),
        ],
      ),
    );
  }
}
