import 'dart:async';
import 'dart:io';

import 'package:flowder/flowder.dart';
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
        super(QuranUninitialized());

  @override
  Stream<QuranState> mapEventToState(QuranEvent event) async* {
    try {
      if (event is QuranCheckAudio) {
        String fileName = event.quranSurat.surat + '.mp3';
        String downloadPath = (await QuranAudio.downloadedPath).path;
        File file = File(downloadPath + '/' + fileName);

        if (await file.exists()) {
          yield QuranCheckAudioExist();
        } else {
          yield QuranCheckAudioNotExist();
        }
      }

      if (event is QuranDownloadAudio) {
        String fileName = event.quranSurat.surat + '.mp3';
        String downloadPath = (await QuranAudio.downloadedPath).path;
        QuranSurat quranSurat = event.quranSurat;
        File downloadedFile = File(downloadPath + '/' + fileName);

        DownloaderUtils utils = DownloaderUtils(
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

        yield QuranDownloadAudioProgress(
          quranSurat: quranSurat,
          downloadStream: _quranAudioDownloadCubit.stream,
        );
      }

      if (event is QuranDownloadAudioCancel) {
        if (_downloaderCore != null) {
          await _downloaderCore!.cancel();
        }

        yield QuranCheckAudioNotExist();
      }

      if (event is QuranAudioPlay) {
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

        yield QuranAudioPlaying(
          quranSurat: event.quranSurat,
          duration: _audioPlayer!.duration!,
          audioStream: _audioPlayer!.positionStream,
        );
      }

      if (event is QuranAudioPause) {
        await _audioPlayer!.pause();
        Duration duration = _audioPlayer!.duration!;
        Duration durationPosition = _audioPlayer!.position;

        yield QuranAudioPausing(
          quranSurat: event.quranSurat,
          duration: duration,
          positionDuration: durationPosition,
        );
      }

      if (event is QuranAudioResume) {
        this.add(QuranAudioPlay(quranSurat: event.quranSurat));
      }

      if (event is QuranAudioStop) {
        await _audioPlayer!.stop();
        this.add(QuranCheckAudio(quranSurat: event.quranSurat));
      }
    } catch (err) {
      print(err);

      showError(ValidationWord.globalError);

      yield QuranError();
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
