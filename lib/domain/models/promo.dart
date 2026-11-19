class Promo {
  final int id;
  final String judul;
  final String kode;
  final String nilai;
  final String tipe; // 'diskon' atau 'cashback'
  final String berlaku;
  final List<String> syarat;

  const Promo({
    required this.id,
    required this.judul,
    required this.kode,
    required this.nilai,
    required this.tipe,
    required this.berlaku,
    required this.syarat,
  });

  factory Promo.fromJson(Map<String, dynamic> json) => Promo(
    id: json['id'] as int,
    judul: json['judul'] as String,
    kode: json['kode'] as String,
    nilai: json['nilai'] as String,
    tipe: json['tipe'] as String,
    berlaku: json['berlaku'] as String,
    syarat: List<String>.from(json['syarat'] as List),
  );
}