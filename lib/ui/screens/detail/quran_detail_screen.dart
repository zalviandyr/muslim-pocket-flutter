import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:muslim_pocket/blocs/blocs.dart';
import 'package:muslim_pocket/config/configs.dart';
import 'package:muslim_pocket/models/models.dart';
import 'package:muslim_pocket/ui/widgets/widgets.dart';

class QuranDetailScreen extends StatefulWidget {
  final QuranSurat quranSurat;

  const QuranDetailScreen({required this.quranSurat});

  @override
  _QuranDetailScreenState createState() => _QuranDetailScreenState();
}

class _QuranDetailScreenState extends State<QuranDetailScreen>
    with WidgetsBindingObserver {
  late QuranDetailScreenBloc _quranDetailScreenBloc;
  late QuranLastReadBloc _quranLastReadBloc;
  late QuranAudioBloc _quranAudioBloc;
  final ScrollController _scrollController = ScrollController();
  double counter = 0;

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);

    _quranDetailScreenBloc = BlocProvider.of<QuranDetailScreenBloc>(context);
    _quranLastReadBloc = BlocProvider.of<QuranLastReadBloc>(context);
    _quranAudioBloc = BlocProvider.of<QuranAudioBloc>(context);

    // fetch
    _quranDetailScreenBloc
        .add(QuranDetailScreenFetch(quranSurat: widget.quranSurat));
    _quranLastReadBloc.add(QuranFetchLastRead());

    // check audio, dont check when audio while downloading
    if (!(_quranAudioBloc.state is QuranDownloadAudioProgress) &&
        !(_quranAudioBloc.state is QuranAudioPlaying) &&
        !(_quranAudioBloc.state is QuranAudioPausing)) {
      _quranAudioBloc.add(QuranCheckAudio(quranSurat: widget.quranSurat));
    }

    // scroll listener
    _scrollController.addListener(() {
      widget.quranSurat.lastReadPosition = _scrollController.offset;
    });

    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      // trigger when user click home or tab button
      _quranLastReadBloc.add(QuranSaveLastRead(lastRead: widget.quranSurat));
    }

    super.didChangeAppLifecycleState(state);
  }

  @override
  void deactivate() {
    // trigger when user click back button
    _quranLastReadBloc.add(QuranSaveLastRead(lastRead: widget.quranSurat));

    super.deactivate();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);

    _scrollController.dispose();

    super.dispose();
  }

  void _quranAudioAction(QuranState state) {
    if (state is QuranCheckAudioExist) {
      _quranAudioBloc.add(QuranAudioPlay(quranSurat: widget.quranSurat));
    } else if (state is QuranCheckAudioNotExist) {
      _quranAudioBloc.add(QuranDownloadAudio(quranSurat: widget.quranSurat));
    } else if (state is QuranDownloadAudioProgress) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(Word.downloadAudioCancel),
            content: Text(Word.downloadAudioCancelInfo),
            actions: [
              MaterialButton(
                onPressed: () => Get.back(),
                child: Text(Word.no),
              ),
              MaterialButton(
                onPressed: () {
                  _quranAudioBloc.add(QuranDownloadAudioCancel());

                  Get.back();
                },
                child: Text(
                  Word.yes,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        },
      );
    } else if (state is QuranAudioPlaying) {
      _quranAudioBloc.add(QuranAudioPause(quranSurat: state.quranSurat));
    } else if (state is QuranAudioPausing) {
      _quranAudioBloc.add(QuranAudioResume(quranSurat: state.quranSurat));
    }
  }

  void _quranAudioStopAction() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(Word.downloadAudioStop),
          content: Text(Word.downloadAudioStopInfo),
          actions: [
            MaterialButton(
              onPressed: () => Get.back(),
              child: Text(Word.no),
            ),
            MaterialButton(
              onPressed: () {
                _quranAudioBloc
                    .add(QuranAudioStop(quranSurat: widget.quranSurat));

                Get.back();
              },
              child: Text(
                Word.yes,
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _quranListener(BuildContext context, QuranState state) {
    if (state is QuranDetailScreenFetchSuccess) {
      // if current and last read same
      if (state.lastRead == widget.quranSurat) {
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          _scrollController.animateTo(
            state.lastRead?.lastReadPosition ??
                widget.quranSurat.lastReadPosition,
            duration: Duration(seconds: 1),
            curve: Curves.decelerate,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quranSurat.surat),
      ),
      body: BlocConsumer<QuranDetailScreenBloc, QuranState>(
        listener: _quranListener,
        builder: (context, state) {
          if (state is QuranDetailScreenFetchSuccess) {
            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                _buildSuratDescription(context),
                SliverToBoxAdapter(
                  child: Image.asset(
                    Asset.bismillahImage,
                    height: 80.0,
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Measure.horizontalPadding),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        QuranAyat quranAyat = state.quranAyat[index];

                        return AyatItem(quranAyat: quranAyat);
                      },
                      childCount: state.quranAyat.length,
                    ),
                  ),
                ),
              ],
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
      bottomNavigationBar: BlocBuilder<QuranDetailScreenBloc, QuranState>(
        builder: (context, state) {
          if (state is QuranDetailScreenFetchSuccess) {
            return _buildQuranAudio();
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSuratDescription(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: Measure.horizontalPadding,
          vertical: Measure.verticalPadding,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: Measure.verticalPadding,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor.withOpacity(0.3),
          borderRadius: BorderRadius.circular(Measure.borderRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  Asset.numberIcon,
                  width: 35.0,
                ),
                Text(widget.quranSurat.order),
              ],
            ),
            const SizedBox(height: 10.0),
            Text(
              widget.quranSurat.surat,
              style: Theme.of(context).textTheme.headline2,
            ),
            Text(widget.quranSurat.meaning),
            const SizedBox(height: 5.0),
            Text(
                '${widget.quranSurat.type} - ${widget.quranSurat.countOfAyat} Ayat'),
          ],
        ),
      ),
    );
  }

  Widget _buildQuranAudio() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5.0,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: BlocBuilder<QuranAudioBloc, QuranState>(
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              state is QuranAudioPlaying
                  ? StreamBuilder(
                      stream: state.audioStream,
                      builder: (context, AsyncSnapshot<Duration> snapshot) {
                        double progress = 0.0;
                        if (snapshot.hasData) {
                          progress = snapshot.data!.inSeconds /
                              state.duration.inSeconds;
                        }

                        return LinearProgressIndicator(
                          value: progress,
                        );
                      },
                    )
                  : state is QuranAudioPausing
                      ? LinearProgressIndicator(
                          value: state.positionDuration.inSeconds /
                              state.duration.inSeconds,
                        )
                      : const SizedBox.shrink(),
              Row(
                children: [
                  MaterialButton(
                    onPressed: () => _quranAudioAction(state),
                    minWidth: 0.0,
                    height: 40.0,
                    shape: CircleBorder(),
                    child: state is QuranCheckAudioExist
                        ? Icon(Icons.play_circle)
                        : state is QuranAudioPlaying
                            ? Icon(Icons.pause_circle)
                            : state is QuranAudioPausing
                                ? Icon(Icons.play_circle)
                                : state is QuranDownloadAudioProgress
                                    ? Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Icon(Icons.cancel),
                                          SizedBox(
                                            width: 30.0,
                                            height: 30.0,
                                            child: StreamBuilder(
                                              stream: state.downloadStream,
                                              builder: (context,
                                                  AsyncSnapshot<List>
                                                      snapshot) {
                                                if (snapshot.hasData) {
                                                  return CircularProgressIndicator(
                                                    value: snapshot.data![0],
                                                  );
                                                }

                                                return const SizedBox.shrink();
                                              },
                                            ),
                                          ),
                                        ],
                                      )
                                    : Icon(Icons.download),
                  ),
                  const SizedBox(width: 5.0),
                  if (state is QuranDownloadAudioProgress)
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            '${Word.downloadAudioSurat} ${state.quranSurat.surat}'),
                        StreamBuilder(
                          stream: state.downloadStream,
                          builder: (context, AsyncSnapshot<List> snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                  '${snapshot.data![1]} / ${snapshot.data![2]} MB');
                            }

                            return const SizedBox.shrink();
                          },
                        ),
                      ],
                    )
                ]..addAll(
                    state is QuranDownloadAudioProgress
                        ? []
                        : _buildAudioDescription(state),
                  ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildAudioDescription(QuranState state) {
    if (state is QuranAudioPlaying || state is QuranAudioPausing) {
      String text = '';
      if (state is QuranAudioPlaying)
        text = '${Word.playingAudioSurat} ${state.quranSurat.surat}';
      else if (state is QuranAudioPausing)
        text = '${Word.playingAudioSurat} ${state.quranSurat.surat}';

      return [
        Text(text),
        const Spacer(),
        MaterialButton(
          onPressed: _quranAudioStopAction,
          minWidth: 0.0,
          height: 40.0,
          shape: CircleBorder(),
          child: Icon(Icons.stop_circle_outlined),
        ),
      ];
    }

    return [Text('${Word.audioSurat} ${widget.quranSurat.surat}')];
  }
}
