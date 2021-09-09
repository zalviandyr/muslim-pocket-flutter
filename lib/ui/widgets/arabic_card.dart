import 'package:flutter/material.dart';
import 'package:muslim_pocket/config/configs.dart';

class ArabicCard extends StatelessWidget {
  final String title;
  final String arabic;
  final String latin;
  final String translate;

  const ArabicCard({
    required this.title,
    required this.arabic,
    required this.latin,
    required this.translate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Measure.verticalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          const SizedBox(height: 10.0),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: Measure.horizontalPadding,
                vertical: Measure.verticalPadding),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Measure.borderRadius),
              border: Border.all(color: Theme.of(context).accentColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    arabic,
                    style: Theme.of(context).textTheme.subtitle2,
                    textDirection: TextDirection.rtl,
                  ),
                ),
                const SizedBox(height: 10.0),
                latin == ''
                    ? SizedBox.shrink()
                    : Text(
                        latin,
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                const SizedBox(height: 10.0),
                translate == '' ? SizedBox.shrink() : Text(translate),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
