class Doa {
  final String title;
  final String arabic;
  final String latin;
  final String description;

  Doa({
    required this.title,
    required this.arabic,
    required this.latin,
    required this.description,
  });

  static List<Doa> wiridFromJson(dynamic json) {
    List<Doa> wirid = [];

    for (var data in json) {
      wirid.add(Doa(
        title: 'Sebanyak ${data["times"]} kali',
        arabic: data['arabic'],
        latin: '',
        description: data['tnc'] ?? '',
      ));
    }

    return wirid;
  }

  static List<Doa> dailyFromJson(dynamic json) {
    List<Doa> daily = [];

    for (var data in json) {
      daily.add(Doa(
        title: data['title'],
        arabic: data['arabic'],
        latin: data['latin'],
        description: data['translation'],
      ));
    }

    return daily;
  }

  static List<Doa> tahlilFromJson(dynamic json) {
    List<Doa> tahlil = [];

    for (var data in json) {
      tahlil.add(Doa(
        title: data['title'],
        arabic: data['arabic'],
        latin: '',
        description: data['translation'],
      ));
    }

    return tahlil;
  }

  static List<Doa> ayatKursiFromJson(dynamic json) {
    List<Doa> ayatKursi = [
      Doa(
        title: '',
        arabic: json['arabic'],
        latin: json['latin'],
        description: json['translation'],
      )
    ];

    return ayatKursi;
  }
}
