class QuranAyat {
  final String order;
  final String arabic;
  final String translation;

  QuranAyat({
    required this.order,
    required this.arabic,
    required this.translation,
  });

  static List<QuranAyat> fromJson(dynamic json) {
    List<QuranAyat> quranAyat = [];

    for (var data in json) {
      quranAyat.add(QuranAyat(
        order: data['ayat_ke'].toString(),
        arabic: data['teks_ar'],
        translation: data['teks_id'],
      ));
    }

    return quranAyat;
  }
}
