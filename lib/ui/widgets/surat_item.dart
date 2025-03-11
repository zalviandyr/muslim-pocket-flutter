import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muslim_pocket/config/configs.dart';
import 'package:muslim_pocket/models/models.dart';

class SuratItem extends StatelessWidget {
  final QuranSurat quranSurat;
  final Function(QuranSurat) onTap;

  const SuratItem({required this.quranSurat, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onTap(quranSurat),
              borderRadius: BorderRadius.circular(Measure.borderRadius),
              child: Row(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset(
                        Asset.numberIcon,
                        width: 35.0,
                      ),
                      Text(quranSurat.order),
                    ],
                  ),
                  const SizedBox(width: 10.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        quranSurat.surat,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                          '${quranSurat.type} - ${quranSurat.countOfAyat} Ayat'),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    quranSurat.asma,
                    style: Theme.of(context).textTheme.titleSmall,
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
            ),
          ),
          const Divider(color: Pallette.black),
        ],
      ),
    );
  }
}
