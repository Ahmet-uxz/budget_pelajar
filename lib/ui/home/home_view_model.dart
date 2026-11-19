import 'package:flutter/foundation.dart';

import '../../data/repositories/tagihan_repository.dart';
import '../../data/repositories/transaksi_repository.dart';
import '../../domain/models/tagihan.dart';
import '../../domain/models/transaksi.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({
    required TransaksiRepository transaksiRepository,
    required TagihanRepository tagihanRepository,
  })  : _transaksiRepo = transaksiRepository,
        _tagihanRepo = tagihanRepository {
    _transaksiRepo.addListener(notifyListeners);
    _tagihanRepo.addListener(notifyListeners);
  }

  final TransaksiRepository _transaksiRepo;
  final TagihanRepository _tagihanRepo;

  bool isLoading = false;
  String? error;
  String? dompetTerpilih; // null = semua dompet

  Future<void> load() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      await _transaksiRepo.load();
      await _tagihanRepo.load();
    } catch (e) {
      error = 'Gagal memuat data beranda.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void pilihDompet(String dompet) {
    dompetTerpilih = dompetTerpilih == dompet ? null : dompet;
    notifyListeners();
  }

  List<String> get daftarDompet => _transaksiRepo.daftarDompet;

  List<Transaksi> get _terfilter => dompetTerpilih == null
      ? _transaksiRepo.semua
      : _transaksiRepo.semua.where((t) => t.dompet == dompetTerpilih).toList();

  List<Transaksi> get transaksiTerbaru => _terfilter.take(3).toList();

  int get totalPemasukan => _terfilter
      .where((t) => !t.isPengeluaran)
      .fold<int>(0, (a, t) => a + t.jumlah);

  int get totalPengeluaran => _terfilter
      .where((t) => t.isPengeluaran)
      .fold<int>(0, (a, t) => a + t.jumlah);

  int get saldo => totalPemasukan - totalPengeluaran;

  List<MapEntry<String, int>> get ringkasanKategori {
    final map = <String, int>{};
    for (final t in _terfilter.where((t) => t.isPengeluaran)) {
      map[t.kategori] = (map[t.kategori] ?? 0) + t.jumlah;
    }
    final list = map.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return list.take(4).toList();
  }

  List<Tagihan> get tagihanBelumSelesai => _tagihanRepo.belumSelesai;

  @override
  void dispose() {
    _transaksiRepo.removeListener(notifyListeners);
    _tagihanRepo.removeListener(notifyListeners);
    super.dispose();
  }
}