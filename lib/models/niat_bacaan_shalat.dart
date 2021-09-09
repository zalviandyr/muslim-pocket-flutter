class NiatBacaanShalat {
  final String name;
  final String arabic;
  final String latin;
  final String translate;

  NiatBacaanShalat({
    required this.name,
    required this.arabic,
    required this.latin,
    required this.translate,
  });

  static List<NiatBacaanShalat> fromJson(dynamic json) {
    List<NiatBacaanShalat> niatShalat = [];

    for (var data in json) {
      niatShalat.add(NiatBacaanShalat(
        name: data['name'],
        arabic: data['arabic'],
        latin: data['latin'],
        translate: data['terjemahan'],
      ));
    }

    return niatShalat;
  }
}
