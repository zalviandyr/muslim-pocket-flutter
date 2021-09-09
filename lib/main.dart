import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_pocket/blocs/blocs.dart';
import 'package:muslim_pocket/config/pallette.dart';
import 'package:muslim_pocket/ui/screens/screens.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NavigationCubit>(create: (_) => NavigationCubit()),
        BlocProvider<HomeScreenBloc>(create: (_) => HomeScreenBloc()),
        BlocProvider<ShalatScreenBloc>(create: (_) => ShalatScreenBloc()),
        BlocProvider<QuranScreenBloc>(create: (_) => QuranScreenBloc()),
        BlocProvider<QuranDetailScreenBloc>(
            create: (_) => QuranDetailScreenBloc()),
        BlocProvider<QuranLastReadBloc>(create: (_) => QuranLastReadBloc()),
        BlocProvider<QuranAudioBloc>(create: (_) => QuranAudioBloc()),
        BlocProvider<PrayerScreenBloc>(create: (_) => PrayerScreenBloc()),
        BlocProvider<NabiScreenBloc>(create: (_) => NabiScreenBloc()),
        BlocProvider<NabiDetailScreenBloc>(
            create: (_) => NabiDetailScreenBloc()),
        BlocProvider<UserBloc>(create: (_) => UserBloc()),
      ],
      child: GetMaterialApp(
        title: 'Muslim Pocket',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
          textTheme: TextTheme(
            headline1: GoogleFonts.manrope(
              fontSize: 27.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              letterSpacing: 0.15,
            ),
            headline2: GoogleFonts.manrope(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              letterSpacing: 0.15,
            ),
            bodyText1: GoogleFonts.manrope(
              fontSize: 13.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              letterSpacing: 0.5,
            ),
            bodyText2: GoogleFonts.manrope(
              fontSize: 13.0,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              letterSpacing: 0.5,
            ),
            // text form field
            subtitle1: GoogleFonts.manrope(
              fontSize: 13.0,
              color: Colors.black,
              letterSpacing: 0.5,
            ),
            subtitle2: GoogleFonts.amiri(
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              letterSpacing: 0.5,
            ),
            caption: GoogleFonts.manrope(
              fontSize: 10.0,
              color: Colors.black,
            ),
            button: GoogleFonts.manrope(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
            textTheme: TextTheme(
              headline6: GoogleFonts.manrope(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Pallette.primaryColor,
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Pallette.black),
            ),
            hintStyle: GoogleFonts.manrope(
              fontSize: 13.0,
            ),
          ),
          primaryColor: Pallette.primaryColor,
          accentColor: Pallette.accentColor,
          scaffoldBackgroundColor: Pallette.scaffoldBackground,
        ),
        home: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: Pallette.scaffoldBackground,
            statusBarIconBrightness: Brightness.dark,
          ),
          child: SplashScreen(),
        ),
      ),
    );
  }
}
