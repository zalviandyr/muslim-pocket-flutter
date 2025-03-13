import 'dart:async';
import 'dart:io';

import 'package:flowder_ex/flowder_ex.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:muslim_pocket/blocs/blocs.dart';
import 'package:muslim_pocket/config/configs.dart';
import 'package:muslim_pocket/models/models.dart';
import 'package:muslim_pocket/ui/widgets/widgets.dart';

class QuranAudioBloc extends Bloc<QuranEvent, QuranState> {
  final _QuranAudioDownloadCubit _quranAudioDownloadCubit;
  DownloaderCore? _downloaderCore;
  AudioPlayer? _audioPlayer;

  QuranAudioBloc()
      : _quranAudioDownloadCubit = _QuranAudioDownloadCubit(),
        super(QuranUninitialized()) {
    on(_onQuranCheckAudio);
    on(_onQuranDownloadAudio);
    on(_onQuranDownloadAudioCancel);
    on(_onQuranAudioPlay);
    on(_onQuranAudioPause);
    on(_onQuranAudioResume);
    on(_onQuranAudioStop);
  }

  Future<void> _onQuranCheckAudio(
      QuranCheckAudio event, Emitter<QuranState> emit) async {
    try {
      String fileName = event.quranSurat.surat + '.mp3';
      String downloadPath = (await QuranAudio.downloadedPath).path;
      File file = File(downloadPath + '/' + fileName);

      if (await file.exists()) {
        emit(QuranCheckAudioExist());
      } else {
        emit(QuranCheckAudioNotExist());
      }
    } catch (err, trace) {
      onError(err, trace);

      showError(ValidationWord.globalError);

      emit(QuranError());
    }
  }

  Future<void> _onQuranDownloadAudio(
      QuranDownloadAudio event, Emitter<QuranState> emit) async {
    try {
      String fileName = event.quranSurat.surat + '.mp3';
      String downloadPath = (await QuranAudio.downloadedPath).path;
      QuranSurat quranSurat = event.quranSurat;
      File downloadedFile = File(downloadPath + '/' + fileName);

      DownloaderUtils utils = DownloaderUtils(
        accessToken: "",
        progress: ProgressImplementation(),
        file: downloadedFile,
        deleteOnCancel: true,
        onDone: () {
          this.add(QuranCheckAudio(quranSurat: quranSurat));
        },
        progressCallback: (current, total) {
          double progress = (current / total);
          String curMb = (current * 0.00000095367432).toStringAsFixed(2);
          String totMb = (total * 0.00000095367432).toStringAsFixed(2);

          _quranAudioDownloadCubit.refreshProgress(progress, curMb, totMb);
        },
      );

      _downloaderCore =
          await Flowder.download(event.quranSurat.audioUrl, utils);

      emit(QuranDownloadAudioProgress(
        quranSurat: quranSurat,
        downloadStream: _quranAudioDownloadCubit.stream,
      ));
    } catch (err, trace) {
      onError(err, trace);

      showError(ValidationWord.globalError);

      emit(QuranError());
    }
  }

  Future<void> _onQuranDownloadAudioCancel(
      QuranDownloadAudioCancel event, Emitter<QuranState> emit) async {
    try {
      if (_downloaderCore != null) {
        await _downloaderCore!.cancel();
      }

      emit(QuranCheckAudioNotExist());
    } catch (err, trace) {
      onError(err, trace);

      showError(ValidationWord.globalError);

      emit(QuranError());
    }
  }

  Future<void> _onQuranAudioPlay(
      QuranAudioPlay event, Emitter<QuranState> emit) async {
    try {
      String fileName = event.quranSurat.surat + '.mp3';
      String downloadPath = (await QuranAudio.downloadedPath).path;
      File file = File(downloadPath + '/' + fileName);

      if (_audioPlayer == null) {
        _audioPlayer = AudioPlayer();
      }

      if (_audioPlayer!.playerState.processingState == ProcessingState.idle ||
          _audioPlayer!.playerState.processingState ==
              ProcessingState.completed) {
        await _audioPlayer!.setFilePath(file.path);
      }
      _audioPlayer!.play();

      emit(QuranAudioPlaying(
        quranSurat: event.quranSurat,
        duration: _audioPlayer!.duration!,
        audioStream: _audioPlayer!.positionStream,
      ));
    } catch (err, trace) {
      onError(err, trace);

      showError(ValidationWord.globalError);

      emit(QuranError());
    }
  }

  Future<void> _onQuranAudioPause(
      QuranAudioPause event, Emitter<QuranState> emit) async {
    try {
      await _audioPlayer!.pause();
      Duration duration = _audioPlayer!.duration!;
      Duration durationPosition = _audioPlayer!.position;

      emit(QuranAudioPausing(
        quranSurat: event.quranSurat,
        duration: duration,
        positionDuration: durationPosition,
      ));
    } catch (err, trace) {
      onError(err, trace);

      showError(ValidationWord.globalError);

      emit(QuranError());
    }
  }

  Future<void> _onQuranAudioResume(
      QuranAudioResume event, Emitter<QuranState> emit) async {
    try {
      this.add(QuranAudioPlay(quranSurat: event.quranSurat));
    } catch (err, trace) {
      onError(err, trace);

      showError(ValidationWord.globalError);

      emit(QuranError());
    }
  }

  Future<void> _onQuranAudioStop(
      QuranAudioStop event, Emitter<QuranState> emit) async {
    try {
      await _audioPlayer!.stop();
      this.add(QuranCheckAudio(quranSurat: event.quranSurat));
    } catch (err, trace) {
      onError(err, trace);

      showError(ValidationWord.globalError);

      emit(QuranError());
    }
  }
}

class _QuranAudioDownloadCubit extends Cubit<List> {
  _QuranAudioDownloadCubit() : super([0, '0', '0']);

  void refreshProgress(double progress, String curMb, String totMb) {
    List refreshState = List.empty(growable: true);

    refreshState.add(progress);
    refreshState.add(curMb);
    refreshState.add(totMb);

    emit(refreshState);
  }
}
