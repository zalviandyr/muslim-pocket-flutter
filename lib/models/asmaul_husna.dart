class AsmaulHusna {
  final String latin;
  final String arabic;
  final String descriptionId;
  final String descriptionEn;

  AsmaulHusna({
    required this.latin,
    required this.arabic,
    required this.descriptionId,
    required this.descriptionEn,
  });

  factory AsmaulHusna.fromJson(dynamic json) {
    return AsmaulHusna(
      latin: json['latin'],
      arabic: json['arabic'],
      descriptionId: json['translation_id'],
      descriptionEn: json['translation_en'],
    );
  }
}
