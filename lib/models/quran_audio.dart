import 'dart:io';

import 'package:path_provider/path_provider.dart';

class QuranAudio {
  static final Future<Directory> downloadedPath =
      getApplicationSupportDirectory();
  final String orderSurat;
  final String audioPath;
  final String audioUrl;

  QuranAudio({
    required this.orderSurat,
    required this.audioPath,
    required this.audioUrl,
  });
}
