import 'package:flutter/foundation.dart';

import '../../domain/models/tagihan.dart';
import '../services/budget_pelajar_service.dart';

class TagihanRepository extends ChangeNotifier {
  TagihanRepository(this._service);
  final BudgetPelajarService _service;

  List<Tagihan> _items = [];
  bool _loaded = false;
  Future<void>? _inFlight;

  List<Tagihan> get semua => List.unmodifiable(_items);
  List<Tagihan> get belumSelesai =>
      _items.where((t) => !t.isSelesai).toList();
  List<Tagihan> get selesai => _items.where((t) => t.isSelesai).toList();
  int get jumlahBelumSelesai => belumSelesai.length;

  /// Aman dipanggil dari Beranda dan Checklist sekaligus:
  /// data hanya diambil sekali supaya centang tidak ter-reset.
  Future<void> load({bool force = false}) {
    if (_loaded && !force) return Future.value();
    return _inFlight ??= _fetch().whenComplete(() => _inFlight = null);
  }

  Future<void> _fetch() async {
    final raw = await _service.fetchTagihan();
    _items = raw.map(Tagihan.fromJson).toList();
    _loaded = true;
    notifyListeners();
  }

  void toggle(int id, bool selesai) {
    final i = _items.indexWhere((t) => t.id == id);
    if (i == -1) return;
    _items = [..._items];
    _items[i] = _items[i].copyWith(isSelesai: selesai);
    notifyListeners(); // Beranda + badge tab ikut berubah
  }
}