import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:muslim_pocket/config/configs.dart';
import 'package:muslim_pocket/ui/widgets/widgets.dart';

class ArahQiblat extends StatelessWidget {
  final _deviceSupport = FlutterQiblah.androidDeviceSensorSupport();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Word.arahQiblat),
      ),
      body: FutureBuilder(
        future: _deviceSupport,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return QiblatCompass();
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
