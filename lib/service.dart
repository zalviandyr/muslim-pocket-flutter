import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:muslim_pocket/config/configs.dart';
import 'package:muslim_pocket/models/models.dart';

class Service {
  static const _baseUrl = 'https://zerachiuw.my.id/api/muslim';

  static Future<AsmaulHusna> getRandomAsmaulHusna() async {
    Uri url = Uri.parse('$_baseUrl/random/asmaul-husna');
    var response = await http.get(url);

    dynamic json = jsonDecode(response.body);
    return AsmaulHusna.fromJson(json['result']);
  }

  static Future<Quote> getRandomQuote() async {
    Uri urlQuote = Uri.parse('$_baseUrl/random/quote');
    Uri urlWallpaper = Uri.parse('$_baseUrl/random/wallpaper');
    var responseQuote = await http.get(urlQuote);
    var responseWallpaper = await http.get(urlWallpaper);

    dynamic jsonQuote = jsonDecode(responseQuote.body);
    dynamic jsonWallpaper = jsonDecode(responseWallpaper.body);
    return Quote(
        quote: jsonQuote['result'], wallpaper: jsonWallpaper['result']);
  }

  static Future<List<String>> getShalatCity() async {
    Uri url = Uri.parse('$_baseUrl/jadwal-shalat');
    var response = await http.get(url);

    dynamic json = jsonDecode(response.body);
    return (json['result'] as List).map((e) => e.toString()).toList();
  }

  static Future<List<JadwalShalat>> getShalatSchedule(String city) async {
    Uri url = Uri.parse('$_baseUrl/jadwal-shalat/$city');
    var response = await http.get(url);

    dynamic json = jsonDecode(response.body);
    return JadwalShalat.fromJson(json['result']);
  }

  static Future<List<NiatBacaanShalat>> getNiatShalat() async {
    Uri url = Uri.parse('$_baseUrl/niat-shalat');
    var response = await http.get(url);

    dynamic json = jsonDecode(response.body);
    return NiatBacaanShalat.fromJson(json['result']);
  }

  static Future<List<NiatBacaanShalat>> getBacaanShalat() async {
    Uri url = Uri.parse('$_baseUrl/bacaan-shalat');
    var response = await http.get(url);

    dynamic json = jsonDecode(response.body);
    return NiatBacaanShalat.fromJson(json['result']);
  }

  static Future<List<QuranSurat>> getQuranSurat() async {
    Uri url = Uri.parse('$_baseUrl/quran');
    var response = await http.get(url);

    dynamic json = jsonDecode(response.body);
    return QuranSurat.fromJson(json['result']);
  }

  static Future<List<QuranAyat>> getQuranAyat(String surat, String ayat) async {
    Uri url = Uri.parse('$_baseUrl/quran/$surat/$ayat');
    var response = await http.get(url);

    dynamic json = jsonDecode(response.body);
    return QuranAyat.fromJson(json['result']['ayat']);
  }

  static Future<List<Doa>> getPrayer(PrayerEnum prayerType) async {
    Uri url = Uri.parse(_baseUrl); // just init
    if (prayerType == PrayerEnum.ayatKursi) {
      url = Uri.parse('$_baseUrl/doa/ayat-kursi');
    } else if (prayerType == PrayerEnum.daily) {
      url = Uri.parse('$_baseUrl/doa/harian');
    } else if (prayerType == PrayerEnum.tahlil) {
      url = Uri.parse('$_baseUrl/doa/tahlil');
    } else if (prayerType == PrayerEnum.wirid) {
      url = Uri.parse('$_baseUrl/doa/wirid');
    }

    var response = await http.get(url);
    dynamic json = jsonDecode(response.body);
    List<Doa> result = [];

    if (prayerType == PrayerEnum.ayatKursi) {
      result = Doa.ayatKursiFromJson(json['result']);
    } else if (prayerType == PrayerEnum.daily) {
      result = Doa.dailyFromJson(json['result']);
    } else if (prayerType == PrayerEnum.tahlil) {
      result = Doa.tahlilFromJson(json['result']);
    } else if (prayerType == PrayerEnum.wirid) {
      result = Doa.wiridFromJson(json['result']);
    }

    return result;
  }

  static Future<List<Nabi>> getNabi() async {
    Uri url = Uri.parse('$_baseUrl/nabi');
    var response = await http.get(url);

    dynamic json = jsonDecode(response.body);
    return Nabi.fromJson(json['result']);
  }

  static Future<NabiDetail> getNabiDetail(String slug) async {
    Uri url = Uri.parse('$_baseUrl/nabi/$slug');
    var response = await http.get(url);

    dynamic json = jsonDecode(response.body);
    return NabiDetail.fromJson(json['result']);
  }
}
