import 'package:flutter/material.dart';
import 'package:muslim_pocket/config/configs.dart';

class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final IconData icon;

  const SecondaryButton({
    required this.label,
    required this.onTap,
    this.icon = Icons.chevron_right,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(Measure.borderRadius),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: Measure.horizontalPadding,
              vertical: Measure.verticalPadding),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).accentColor),
            borderRadius: BorderRadius.circular(Measure.borderRadius),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.button,
              ),
              Icon(
                icon,
                color: Pallette.black,
                size: 27.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
