import 'package:flutter/material.dart';

class TertiaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const TertiaryButton({
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45.0,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.red,
      ),
      child: MaterialButton(
        onPressed: onPressed,
        textColor: Colors.white,
        height: 45.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(label),
      ),
    );
  }
}
