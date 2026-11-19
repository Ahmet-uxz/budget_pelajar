import 'package:flutter/foundation.dart';

import '../../data/repositories/transaksi_repository.dart';
import '../../domain/models/transaksi.dart';
import '../core/formatters.dart';

enum FilterTransaksi { semua, pengeluaran, pemasukan }

class GrupBulan {
  GrupBulan(this.label, this.items);
  final String label;
  final List<Transaksi> items;

  int get pengeluaran => items
      .where((t) => t.isPengeluaran)
      .fold<int>(0, (a, t) => a + t.jumlah);
  int get pemasukan => items
      .where((t) => !t.isPengeluaran)
      .fold<int>(0, (a, t) => a + t.jumlah);
}

class RiwayatViewModel extends ChangeNotifier {
  RiwayatViewModel({required TransaksiRepository transaksiRepository})
      : _repo = transaksiRepository {
    _repo.addListener(notifyListeners);
  }

  final TransaksiRepository _repo;

  bool isLoading = false;
  String? error;
  FilterTransaksi filter = FilterTransaksi.semua;

  Future<void> load() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      await _repo.load();
    } catch (e) {
      error = 'Gagal memuat riwayat pencatatan.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setFilter(FilterTransaksi f) {
    filter = f;
    notifyListeners();
  }

  List<Transaksi> get terfilter => switch (filter) {
    FilterTransaksi.semua => _repo.semua,
    FilterTransaksi.pengeluaran =>
        _repo.semua.where((t) => t.isPengeluaran).toList(),
    FilterTransaksi.pemasukan =>
        _repo.semua.where((t) => !t.isPengeluaran).toList(),
  };

  List<GrupBulan> get grup {
    final map = <String, List<Transaksi>>{};
    for (final t in terfilter) {
      map
          .putIfAbsent('${namaBulan(t.tanggal.month)} ${t.tanggal.year}', () => [])
          .add(t);
    }
    return map.entries.map((e) => GrupBulan(e.key, e.value)).toList();
  }

  @override
  void dispose() {
    _repo.removeListener(notifyListeners);
    super.dispose();
  }
}