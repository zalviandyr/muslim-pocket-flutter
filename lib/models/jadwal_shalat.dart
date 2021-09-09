import 'package:intl/intl.dart';

class JadwalShalat {
  final DateTime date;
  final String dateFormat;
  final String imsyak;
  final String shubuh;
  final String rise;
  final String dhuha;
  final String dzuhur;
  final String ashr;
  final String magrib;
  final String isya;

  JadwalShalat({
    required this.date,
    required this.dateFormat,
    required this.imsyak,
    required this.shubuh,
    required this.rise,
    required this.dhuha,
    required this.dzuhur,
    required this.ashr,
    required this.magrib,
    required this.isya,
  });

  static final String path = 'shalat';

  static Map<String, String> setCityToMap({String city = 'muarabungo'}) {
    return {'city': city};
  }

  static String getCityFromMap(dynamic map) {
    return map[JadwalShalat.path]['city'];
  }

  static List<JadwalShalat> fromJson(dynamic json) {
    List<JadwalShalat> list = [];
    DateFormat format = DateFormat('dd MMMM yyyy');

    for (var data in json) {
      list.add(JadwalShalat(
        date: DateTime.parse(data['tanggal']),
        dateFormat: format.format(DateTime.parse(data['tanggal'])),
        imsyak: data['imsyak'],
        shubuh: data['shubuh'],
        rise: data['terbit'],
        dhuha: data['dhuha'],
        dzuhur: data['dzuhur'],
        ashr: data['ashr'],
        magrib: data['magrib'],
        isya: data['isya'],
      ));
    }

    return list;
  }
}

class NextShalat {
  final String shalat;
  final String time;

  NextShalat({
    required this.shalat,
    required this.time,
  });
}
