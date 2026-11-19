/// Simulasi server: data contoh dikembalikan dengan Future.delayed().
class BudgetPelajarService {
  Future<List<Map<String, dynamic>>> fetchTransaksi() async {
    await Future.delayed(const Duration(milliseconds: 800));
    final now = DateTime.now();
    String hariLalu(int n) => now.subtract(Duration(days: n)).toIso8601String();

    return [
      {'id': 1, 'jenis': 'pemasukan', 'kategori': 'Uang saku', 'jumlah': 1500000, 'tanggal': hariLalu(1), 'dompet': 'Bank BRI', 'catatan': 'Kiriman orang tua'},
      {'id': 2, 'jenis': 'pengeluaran', 'kategori': 'Makanan', 'jumlah': 25000, 'tanggal': hariLalu(0), 'dompet': 'Dompet 1', 'catatan': 'Makan siang kantin'},
      {'id': 3, 'jenis': 'pengeluaran', 'kategori': 'Transportasi', 'jumlah': 15000, 'tanggal': hariLalu(0), 'dompet': 'Dompet 1', 'catatan': 'Ojek online'},
      {'id': 4, 'jenis': 'pengeluaran', 'kategori': 'Pendidikan', 'jumlah': 350000, 'tanggal': hariLalu(2), 'dompet': 'Bank BRI', 'catatan': 'Fotokopi & buku'},
      {'id': 5, 'jenis': 'pemasukan', 'kategori': 'Freelance', 'jumlah': 400000, 'tanggal': hariLalu(3), 'dompet': 'Bank BCA', 'catatan': 'Desain poster'},
      {'id': 6, 'jenis': 'pengeluaran', 'kategori': 'Hiburan', 'jumlah': 54000, 'tanggal': hariLalu(4), 'dompet': 'Dompet 2', 'catatan': 'Nonton bioskop'},
      {'id': 7, 'jenis': 'pemasukan', 'kategori': 'Uang saku', 'jumlah': 500000, 'tanggal': hariLalu(5), 'dompet': 'Dompet 1', 'catatan': 'Uang tunai'},
      {'id': 8, 'jenis': 'pengeluaran', 'kategori': 'Tagihan', 'jumlah': 150000, 'tanggal': hariLalu(6), 'dompet': 'Bank BCA', 'catatan': 'Paket internet'},
      {'id': 9, 'jenis': 'pemasukan', 'kategori': 'Uang saku', 'jumlah': 1500000, 'tanggal': hariLalu(32), 'dompet': 'Bank BRI', 'catatan': 'Kiriman bulan lalu'},
      {'id': 10, 'jenis': 'pengeluaran', 'kategori': 'Pendidikan', 'jumlah': 1200000, 'tanggal': hariLalu(35), 'dompet': 'Bank BRI', 'catatan': 'Bayar UKT'},
      {'id': 11, 'jenis': 'pengeluaran', 'kategori': 'Makanan', 'jumlah': 120000, 'tanggal': hariLalu(40), 'dompet': 'Dompet 2', 'catatan': 'Belanja bulanan'},
      {'id': 12, 'jenis': 'pemasukan', 'kategori': 'Hadiah', 'jumlah': 200000, 'tanggal': hariLalu(45), 'dompet': 'Dompet 2', 'catatan': 'Hadiah ulang tahun'},
    ];
  }

  Future<List<Map<String, dynamic>>> fetchTagihan() async {
    await Future.delayed(const Duration(milliseconds: 600));
    final now = DateTime.now();
    String hariLagi(int n) => now.add(Duration(days: n)).toIso8601String();

    return [
      {'id': 1, 'nama': 'Bayar UKT semester ini', 'jumlah': 1200000, 'jatuhTempo': hariLagi(14), 'isSelesai': false},
      {'id': 2, 'nama': 'Sewa kos', 'jumlah': 800000, 'jatuhTempo': hariLagi(5), 'isSelesai': false},
      {'id': 3, 'nama': 'Listrik kos', 'jumlah': 120000, 'jatuhTempo': hariLagi(3), 'isSelesai': false},
      {'id': 4, 'nama': 'Paket internet', 'jumlah': 150000, 'jatuhTempo': hariLagi(9), 'isSelesai': false},
      {'id': 5, 'nama': 'Cicilan laptop', 'jumlah': 450000, 'jatuhTempo': hariLagi(20), 'isSelesai': false},
      {'id': 6, 'nama': 'Iuran organisasi', 'jumlah': 25000, 'jatuhTempo': hariLagi(7), 'isSelesai': true},
    ];
  }

  Future<List<Map<String, dynamic>>> fetchPromo() async {
    await Future.delayed(const Duration(milliseconds: 700));
    const syarat = [
      'Minimum transaksi Rp0.',
      'Voucher bisa dipakai hari kapan pun.',
      'Satu voucher untuk satu pengguna.',
      'Tidak dapat digabung dengan promo lain.',
    ];
    return [
      {'id': 1, 'judul': 'Listrik Voucher', 'kode': 'FINFIRST25', 'nilai': 'Rp 5.000', 'tipe': 'diskon', 'berlaku': 's.d 01 Des 2026', 'syarat': syarat},
      {'id': 2, 'judul': 'Pulsa Voucher', 'kode': 'PULSA10', 'nilai': 'Rp 10.000', 'tipe': 'diskon', 'berlaku': 's.d 15 Des 2026', 'syarat': syarat},
      {'id': 3, 'judul': 'Makan Hemat Kampus', 'kode': 'KAMPUS15', 'nilai': 'Rp 15.000', 'tipe': 'diskon', 'berlaku': 's.d 31 Des 2026', 'syarat': syarat},
      {'id': 4, 'judul': 'Cashback Ojek', 'kode': 'GOSAVE20', 'nilai': 'Rp 20.000', 'tipe': 'cashback', 'berlaku': 's.d 20 Des 2026', 'syarat': syarat},
      {'id': 5, 'judul': 'Cashback Belanja', 'kode': 'BELANJA7', 'nilai': 'Rp 7.500', 'tipe': 'cashback', 'berlaku': 's.d 10 Des 2026', 'syarat': syarat},
      {'id': 6, 'judul': 'Cashback E-Wallet', 'kode': 'DOMPETKU', 'nilai': 'Rp 10.000', 'tipe': 'cashback', 'berlaku': 's.d 31 Des 2026', 'syarat': syarat},
    ];
  }

  Future<List<Map<String, dynamic>>> fetchAkun() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return [
      {
        'email': 'demo@gmail.com',
        'password': '12345678',
        'nama': 'Demo Pelajar',
        'noHp': '081234567890',
      },
    ];
  }
}