// formatters.dart
String rupiah(int nilai) {
  final s = nilai.abs().toString();
  final b = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
    b.write(s[i]);
  }
  return '${nilai < 0 ? '-' : ''}Rp $b';
}

String tanggalPendek(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

const _bulan = [
  'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
  'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
];

String namaBulan(int bulan) => _bulan[bulan - 1];

String sapaan() {
  final jam = DateTime.now().hour;
  if (jam < 11) return 'Selamat pagi,';
  if (jam < 15) return 'Selamat siang,';
  if (jam < 18) return 'Selamat sore,';
  return 'Selamat malam,';
}

String inisial(String nama) {
  final p = nama.trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
  if (p.isEmpty) return '?';
  if (p.length == 1) {
    return p.first.substring(0, p.first.length >= 2 ? 2 : 1).toUpperCase();
  }
  return (p[0][0] + p[1][0]).toUpperCase();
}