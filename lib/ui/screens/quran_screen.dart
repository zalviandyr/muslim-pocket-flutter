import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:muslim_pocket/blocs/blocs.dart';
import 'package:muslim_pocket/config/configs.dart';
import 'package:muslim_pocket/models/models.dart';
import 'package:muslim_pocket/ui/screens/screens.dart';
import 'package:muslim_pocket/ui/widgets/widgets.dart';

class QuranScreen extends StatefulWidget {
  @override
  _QuranScreenState createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  late QuranScreenBloc _quranScreenBloc;

  @override
  void initState() {
    _quranScreenBloc = BlocProvider.of<QuranScreenBloc>(context);

    super.initState();
  }

  void _toSuratDetailAction(QuranSurat quranSurat) {
    Get.to(() => QuranDetailScreen(quranSurat: quranSurat));
  }

  void _navigationListener(BuildContext context, int state) {
    if (state == 2 && !(_quranScreenBloc.state is QuranScreenFetchSuccess)) {
      _quranScreenBloc.add(QuranScreenFetch());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NavigationCubit, int>(
      listener: _navigationListener,
      child: Scaffold(
        body: BlocBuilder<QuranScreenBloc, QuranState>(
          builder: (context, state) {
            if (state is QuranScreenFetchSuccess) {
              return CustomScrollView(
                slivers: [
                  _buildSearchBar(),
                  SliverPadding(
                    padding: const EdgeInsets.only(
                      top: 10.0,
                      left: Measure.screenHorizontalPadding,
                      right: Measure.screenHorizontalPadding,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: _buildLastRead(),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.only(
                      top: 20.0,
                      bottom: Measure.screenBottomPadding,
                      left: Measure.screenHorizontalPadding,
                      right: Measure.screenHorizontalPadding,
                    ),
                    sliver: SliverFixedExtentList(
                      itemExtent: 60.0,
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          QuranSurat quranSurat = state.quranSurat[index];
                          return SuratItem(
                            quranSurat: quranSurat,
                            onTap: _toSuratDetailAction,
                          );
                        },
                        childCount: state.quranSurat.length,
                      ),
                    ),
                  ),
                ],
              );
            }

            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return SliverPadding(
      padding: const EdgeInsets.only(
        left: Measure.screenHorizontalPadding,
        right: Measure.screenHorizontalPadding,
      ),
      sliver: SliverToBoxAdapter(
        child: SecondaryButton(
          label: Word.search,
          icon: Icons.search,
          onTap: () {},
        ),
      ),
    );
  }

  Widget _buildLastRead() {
    return BlocBuilder<QuranLastReadBloc, QuranState>(
      builder: (context, state) {
        if (state is QuranFetchLastReadSuccess) {
          QuranSurat? lastRead = state.lastRead;
          if (lastRead != null)
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Measure.horizontalPadding,
                vertical: Measure.verticalPadding,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(Measure.borderRadius),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Word.lastRead,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(height: 5.0),
                  Text(lastRead.surat),
                ],
              ),
            );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
