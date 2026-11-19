// tagihan.dart  (DATA AKSI)
class Tagihan {
  final int id;
  final String nama;
  final int jumlah;
  final DateTime jatuhTempo;
  final bool isSelesai;

  const Tagihan({
    required this.id,
    required this.nama,
    required this.jumlah,
    required this.jatuhTempo,
    required this.isSelesai,
  });

  factory Tagihan.fromJson(Map<String, dynamic> json) => Tagihan(
    id: json['id'] as int,
    nama: json['nama'] as String,
    jumlah: json['jumlah'] as int,
    jatuhTempo: DateTime.parse(json['jatuhTempo'] as String),
    isSelesai: json['isSelesai'] as bool,
  );

  Tagihan copyWith({
    int? id,
    String? nama,
    int? jumlah,
    DateTime? jatuhTempo,
    bool? isSelesai,
  }) =>
      Tagihan(
        id: id ?? this.id,
        nama: nama ?? this.nama,
        jumlah: jumlah ?? this.jumlah,
        jatuhTempo: jatuhTempo ?? this.jatuhTempo,
        isSelesai: isSelesai ?? this.isSelesai,
      );
}