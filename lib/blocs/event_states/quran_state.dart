import 'package:equatable/equatable.dart';
import 'package:muslim_pocket/models/models.dart';

abstract class QuranState extends Equatable {
  QuranState();
}

class QuranUninitialized extends QuranState {
  @override
  List<Object?> get props => [];
}

class QuranLoading extends QuranState {
  @override
  List<Object?> get props => [];
}

class QuranError extends QuranState {
  @override
  List<Object?> get props => [];
}

class QuranFetchLastReadSuccess extends QuranState {
  final QuranSurat? lastRead;

  QuranFetchLastReadSuccess({required this.lastRead});

  @override
  List<Object?> get props => [lastRead];
}

class QuranScreenFetchSuccess extends QuranState {
  final List<QuranSurat> quranSurat;

  QuranScreenFetchSuccess({required this.quranSurat});

  @override
  List<Object?> get props => [quranSurat];
}

class QuranDetailScreenFetchSuccess extends QuranState {
  final List<QuranAyat> quranAyat;
  final QuranSurat? lastRead;

  QuranDetailScreenFetchSuccess(
      {required this.quranAyat, required this.lastRead});

  @override
  List<Object?> get props => [quranAyat, lastRead];
}

class QuranCheckAudioExist extends QuranState {
  @override
  List<Object?> get props => [];
}

class QuranCheckAudioNotExist extends QuranState {
  @override
  List<Object?> get props => [];
}

class QuranDownloadAudioProgress extends QuranState {
  final QuranSurat quranSurat;
  final Stream<List> downloadStream;

  QuranDownloadAudioProgress({
    required this.quranSurat,
    required this.downloadStream,
  });

  @override
  List<Object?> get props => [quranSurat, downloadStream];
}

class QuranAudioPlaying extends QuranState {
  final QuranSurat quranSurat;
  final Duration duration;
  final Stream<Duration> audioStream;

  QuranAudioPlaying({
    required this.quranSurat,
    required this.duration,
    required this.audioStream,
  });

  @override
  List<Object?> get props => [quranSurat, duration, audioStream];
}

class QuranAudioPausing extends QuranState {
  final QuranSurat quranSurat;
  final Duration duration;
  final Duration positionDuration;

  QuranAudioPausing({
    required this.quranSurat,
    required this.duration,
    required this.positionDuration,
  });

  @override
  List<Object?> get props => [quranSurat, positionDuration];
}
