class Nabi {
  final String nabi;
  final String slug;

  Nabi({required this.nabi, required this.slug});

  static List<Nabi> fromJson(dynamic json) {
    List<Nabi> nabi = [];

    for (var data in json) {
      nabi.add(Nabi(nabi: data['nama'], slug: data['slug']));
    }

    return nabi;
  }
}
