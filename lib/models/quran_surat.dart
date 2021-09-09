import 'package:equatable/equatable.dart';
import 'package:muslim_pocket/helpers/helpers.dart';

// ignore: must_be_immutable
class QuranSurat extends Equatable {
  final String surat;
  final String asma;
  final String order;
  final String meaning;
  final String type;
  final String description;
  final String countOfAyat;
  final String audioUrl;
  double lastReadPosition;

  QuranSurat({
    required this.surat,
    required this.asma,
    required this.order,
    required this.meaning,
    required this.type,
    required this.description,
    required this.countOfAyat,
    required this.audioUrl,
    this.lastReadPosition = 0.0,
  });

  static final String path = 'quran_surat';

  Map<String, String> toMap() {
    return {
      'surat': surat,
      'asma': asma,
      'order': order,
      'meaning': meaning,
      'type': type,
      'description': description,
      'countOfAyat': countOfAyat,
      'audioUrl': audioUrl,
      'lastReadPosition': lastReadPosition.toString(),
    };
  }

  static QuranSurat? fromMap(dynamic map) {
    if (map == null) return null;

    return QuranSurat(
      surat: map['surat'],
      asma: map['asma'],
      order: map['order'],
      meaning: map['meaning'],
      type: map['type'],
      description: map['description'],
      countOfAyat: map['countOfAyat'],
      audioUrl: map['audioUrl'],
      lastReadPosition: double.parse(map['lastReadPosition']),
    );
  }

  static List<QuranSurat> fromJson(dynamic json) {
    List<QuranSurat> quranSurat = [];

    for (var data in json) {
      quranSurat.add(QuranSurat(
        surat: data['surat'],
        asma: data['asma'],
        order: data['surat_ke'].toString(),
        meaning: data['arti'],
        type: data['tipe'],
        description: StringHelper.removeHtmlTag(data['keterangan']),
        audioUrl: data['audio_url_full'],
        countOfAyat: data['jumlah_ayat'].toString(),
      ));
    }

    return quranSurat;
  }

  @override
  List<Object?> get props => [
        surat,
        asma,
        order,
        meaning,
        type,
        description,
        audioUrl,
        countOfAyat,
      ];
}
