import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:muslim_pocket/blocs/blocs.dart';
import 'package:muslim_pocket/config/configs.dart';
import 'package:muslim_pocket/models/models.dart';
import 'package:muslim_pocket/ui/screens/screens.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late QuranLastReadBloc _quranLastReadBloc;
  late HomeScreenBloc _homeScreenBloc;

  @override
  void initState() {
    // blocs
    _quranLastReadBloc = BlocProvider.of<QuranLastReadBloc>(context);
    _homeScreenBloc = BlocProvider.of<HomeScreenBloc>(context);

    _quranLastReadBloc.add(QuranFetchLastRead());
    _homeScreenBloc.add(HomeScreenFetch());

    super.initState();
  }

  void _toUserDetailAction() {
    Get.to(() => UserDetailScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HomeScreenBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeScreenFetchSuccess) {
            return ListView(
              padding: const EdgeInsets.only(
                left: Measure.screenHorizontalPadding,
                right: Measure.screenHorizontalPadding,
                bottom: Measure.screenBottomPadding,
              ),
              children: [
                _buildHeader(),
                const SizedBox(height: 20.0),
                _buildAsmaulHusna(state),
                const SizedBox(height: 20.0),
                _buildPrayerTime(state),
                const SizedBox(height: 20.0),
                _buildQuote(state),
                const SizedBox(height: 20.0),
                _buildLastRead(),
              ],
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildHeader() {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoginSuccess) {
          return GestureDetector(
            onTap: _toUserDetailAction,
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.circular(50.0),
                    boxShadow: Pallette.boxShadow,
                  ),
                  child: CircleAvatar(
                    foregroundColor: Theme.of(context).accentColor,
                    radius: 24.0,
                    child: CircleAvatar(
                      foregroundImage: (state.imageProfile != null
                          ? CachedNetworkImageProvider(state.imageProfile!)
                          : AssetImage(Asset.profilePicture)) as ImageProvider,
                      radius: 21.0,
                    ),
                  ),
                ),
                const SizedBox(width: 10.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(Word.salam),
                    const SizedBox(height: 2.0),
                    Text(
                      state.name,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildAsmaulHusna(HomeScreenFetchSuccess state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          state.asmaulHusna.latin,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        const SizedBox(height: 10.0),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            state.asmaulHusna.arabic,
            style: Theme.of(context).textTheme.subtitle2,
            textDirection: TextDirection.rtl,
          ),
        ),
        Text(state.asmaulHusna.descriptionId),
        const SizedBox(height: 3.0),
        Text(
          state.asmaulHusna.descriptionEn,
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ],
    );
  }

  Widget _buildPrayerTime(HomeScreenFetchSuccess state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          state.shalatLocation,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        const SizedBox(height: 10.0),
        Container(
          height: 160.0,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: Pallette.boxShadow,
            borderRadius: BorderRadius.circular(Measure.borderRadius),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomRight,
                child: Transform(
                  alignment: Alignment.bottomCenter,
                  transform: Matrix4.rotationY(math.pi),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(Measure.borderRadius)),
                    child: Image.asset(
                      Asset.mosqueImage,
                      height: 130.0,
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Measure.horizontalPadding,
                      vertical: Measure.verticalPadding),
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(Measure.borderRadius),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.nextShalatSchedule.shalat,
                        style: Theme.of(context).textTheme.headline1,
                      ),
                      const Spacer(),
                      Text(
                        state.nextShalatSchedule.time,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      const SizedBox(height: 5.0),
                      Text(Word.nextShalat),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildQuote(HomeScreenFetchSuccess state) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Measure.horizontalPadding,
        vertical: Measure.verticalPadding,
      ),
      constraints: BoxConstraints(minHeight: 70.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Measure.borderRadius),
        boxShadow: Pallette.boxShadow,
        color: Pallette.black,
        image: DecorationImage(
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Pallette.black, BlendMode.modulate),
          image: CachedNetworkImageProvider(state.quote.wallpaper),
        ),
      ),
      child: Text(
        state.quote.quote,
        style: Theme.of(context)
            .textTheme
            .bodyText2!
            .copyWith(color: Colors.white),
      ),
    );
  }

  Widget _buildLastRead() {
    return BlocBuilder<QuranLastReadBloc, QuranState>(
      builder: (context, state) {
        if (state is QuranFetchLastReadSuccess) {
          QuranSurat? lastRead = state.lastRead;
          if (lastRead != null) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Word.lastRead,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                const SizedBox(height: 10.0),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Measure.horizontalPadding,
                      vertical: Measure.verticalPadding),
                  width: double.infinity,
                  constraints: BoxConstraints(minHeight: 160.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: Pallette.boxShadow,
                    borderRadius: BorderRadius.circular(Measure.borderRadius),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lastRead.surat,
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      Text(lastRead.meaning),
                      const SizedBox(height: 10.0),
                      Text(lastRead.description),
                    ],
                  ),
                )
              ],
            );
          }
        }

        return const SizedBox.shrink();
      },
    );
  }
}
