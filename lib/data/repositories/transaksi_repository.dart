import 'package:flutter/foundation.dart';

import '../../domain/models/transaksi.dart';
import '../services/budget_pelajar_service.dart';

class TransaksiRepository extends ChangeNotifier {
  TransaksiRepository(this._service);
  final BudgetPelajarService _service;

  List<Transaksi> _remote = [];
  final List<Transaksi> _lokal = []; // transaksi buatan pengguna
  final List<String> _dompetBaru = [];
  bool _loaded = false;
  Future<void>? _inFlight;
  int _nextId = 1000;

  List<Transaksi> get semua {
    final list = [..._remote, ..._lokal];
    list.sort((a, b) => b.tanggal.compareTo(a.tanggal));
    return list;
  }

  List<String> get daftarDompet =>
      <String>{..._dompetBaru, ...semua.map((t) => t.dompet)}.toList();

  int buatId() => _nextId++;

  Future<void> load({bool force = false}) {
    if (_loaded && !force) return Future.value();
    return _inFlight ??= _fetch().whenComplete(() => _inFlight = null);
  }

  Future<void> _fetch() async {
    final raw = await _service.fetchTransaksi();
    _remote = raw.map(Transaksi.fromJson).toList();
    _loaded = true;
    notifyListeners();
  }

  void tambah(Transaksi t) {
    _lokal.add(t);
    notifyListeners();
  }

  void tambahDompet(String nama) {
    if (daftarDompet.contains(nama)) return;
    _dompetBaru.insert(0, nama);
    notifyListeners();
  }
}