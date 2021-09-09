import 'package:muslim_pocket/config/word.dart';

class Validation {
  static String? inputRequired(String? value) {
    if (value != null && value.isNotEmpty) return null;
    return ValidationWord.requiredField;
  }

  static String? emailValidator(String? value) {
    if (value != null && value.isNotEmpty) {
      if (RegExp(
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
          .hasMatch(value)) return null;
      return ValidationWord.emailInvalid;
    }
    return ValidationWord.requiredField;
  }

  static String? passwordValidator(String? value) {
    if (value != null && value.isNotEmpty) {
      if (value.length < 6) {
        return ValidationWord.passwordLimit;
      }
      return null;
    }
    return ValidationWord.requiredField;
  }
}
