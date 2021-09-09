class NabiDetail {
  final String name;
  final String bornDate;
  final String age;
  final String description;
  final String thumb;

  NabiDetail({
    required this.name,
    required this.bornDate,
    required this.age,
    required this.description,
    required this.thumb,
  });

  factory NabiDetail.fromJson(dynamic json) {
    return NabiDetail(
      name: json['name'],
      bornDate: json['thn_kelahiran'].toString(),
      age: json['usia'].toString(),
      description: json['description'],
      thumb: json['image_url'],
    );
  }
}
