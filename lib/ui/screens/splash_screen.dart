import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muslim_pocket/blocs/blocs.dart';
import 'package:muslim_pocket/config/configs.dart';
import 'package:muslim_pocket/ui/screens/screens.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late UserBloc _userBloc;
  final Future<FirebaseApp> _initialization =
      Future.delayed(Duration(seconds: 3), () => Firebase.initializeApp());

  @override
  void initState() {
    _userBloc = BlocProvider.of<UserBloc>(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          FirebaseAuth auth = FirebaseAuth.instance;
          FirebaseDatabase.instance.setPersistenceEnabled(true);

          if (auth.currentUser == null) {
            return LoginScreen();
          } else {
            _userBloc.add(UserReLogin());

            return NavigationBarScreen();
          }
        }

        return Scaffold(
          body: Center(
            child: Image.asset(
              Asset.mainIcon,
              fit: BoxFit.fill,
              height: 250.0,
            ),
          ),
        );
      },
    );
  }
}
