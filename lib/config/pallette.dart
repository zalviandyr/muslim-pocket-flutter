import 'package:flutter/material.dart';

class Pallette {
  static const Color primaryColor = const Color(0xFF00B833);
  static const Color accentColor = const Color(0xFF3CC262);
  static const Color scaffoldBackground = const Color(0xFFF3FBF5);
  static const Color black = const Color(0xFF595959);
  static const Color red = const Color(0xFFEF4E4E);

  static const List<BoxShadow> boxShadow = [
    BoxShadow(
      color: Colors.grey,
      blurRadius: 5.0,
      offset: Offset(0, 2),
    ),
  ];
}
