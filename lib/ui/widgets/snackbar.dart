import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim_pocket/config/configs.dart';

void showInfo(String message) {
  ScaffoldMessenger.of(Get.context!).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Pallette.black,
      behavior: SnackBarBehavior.floating,
    ),
  );
}

void showError(String message) {
  ScaffoldMessenger.of(Get.context!).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
    ),
  );
}
