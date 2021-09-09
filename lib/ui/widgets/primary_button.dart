import 'package:flutter/material.dart';
import 'package:muslim_pocket/config/pallette.dart';

class PrimaryButton extends StatelessWidget {
  final String? label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const PrimaryButton({
    required this.label,
    required this.onPressed,
  }) : this.isLoading = false;

  const PrimaryButton.loading()
      : this.label = null,
        this.onPressed = null,
        this.isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45.0,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        gradient: LinearGradient(
          colors: [Pallette.accentColor, Pallette.primaryColor],
        ),
      ),
      child: MaterialButton(
        onPressed: isLoading ? () {} : onPressed,
        textColor: Colors.white,
        height: 45.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: isLoading
            ? SizedBox(
                width: 25.0,
                height: 25.0,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : Text(label!),
      ),
    );
  }
}
