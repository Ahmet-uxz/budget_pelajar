class Transaksi {
  final int id;
  final bool isPengeluaran;
  final String kategori;
  final int jumlah;
  final DateTime tanggal;
  final String dompet;
  final String catatan;

  const Transaksi({
    required this.id,
    required this.isPengeluaran,
    required this.kategori,
    required this.jumlah,
    required this.tanggal,
    required this.dompet,
    required this.catatan,
  });

  factory Transaksi.fromJson(Map<String, dynamic> json) => Transaksi(
    id: json['id'] as int,
    isPengeluaran: json['jenis'] == 'pengeluaran',
    kategori: json['kategori'] as String,
    jumlah: json['jumlah'] as int,
    tanggal: DateTime.parse(json['tanggal'] as String),
    dompet: json['dompet'] as String,
    catatan: json['catatan'] as String,
  );

  String get jenisLabel => isPengeluaran ? 'Pengeluaran' : 'Pemasukan';
}