import 'package:intl/intl.dart';

class StringHelper {
  static String removeHtmlTag(String html) {
    return Bidi.stripHtmlIfNeeded(html);
  }
}
