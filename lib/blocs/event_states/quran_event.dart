import 'package:equatable/equatable.dart';
import 'package:muslim_pocket/models/models.dart';

abstract class QuranEvent extends Equatable {
  QuranEvent();
}

class QuranScreenFetch extends QuranEvent {
  @override
  List<Object?> get props => [];
}

class QuranDetailScreenFetch extends QuranEvent {
  final QuranSurat quranSurat;

  QuranDetailScreenFetch({required this.quranSurat});

  @override
  List<Object?> get props => [quranSurat];
}

class QuranFetchLastRead extends QuranEvent {
  @override
  List<Object?> get props => [];
}

class QuranSaveLastRead extends QuranEvent {
  final QuranSurat lastRead;

  QuranSaveLastRead({required this.lastRead});

  @override
  List<Object?> get props => [lastRead];
}

class QuranCheckAudio extends QuranEvent {
  final QuranSurat quranSurat;

  QuranCheckAudio({required this.quranSurat});

  @override
  List<Object?> get props => [quranSurat];
}

class QuranDownloadAudio extends QuranEvent {
  final QuranSurat quranSurat;

  QuranDownloadAudio({required this.quranSurat});

  @override
  List<Object?> get props => [quranSurat];
}

class QuranDownloadAudioCancel extends QuranEvent {
  @override
  List<Object?> get props => [];
}

class QuranAudioPlay extends QuranEvent {
  final QuranSurat quranSurat;

  QuranAudioPlay({required this.quranSurat});

  @override
  List<Object?> get props => [quranSurat];
}

class QuranAudioPause extends QuranEvent {
  final QuranSurat quranSurat;

  QuranAudioPause({required this.quranSurat});

  @override
  List<Object?> get props => [quranSurat];
}

class QuranAudioResume extends QuranEvent {
  final QuranSurat quranSurat;

  QuranAudioResume({required this.quranSurat});

  @override
  List<Object?> get props => [quranSurat];
}

class QuranAudioStop extends QuranEvent {
  final QuranSurat quranSurat;

  QuranAudioStop({required this.quranSurat});

  @override
  List<Object?> get props => [quranSurat];
}
