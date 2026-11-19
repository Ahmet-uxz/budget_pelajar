import 'package:flutter/foundation.dart';

import '../../data/repositories/promo_repository.dart';
import '../../domain/models/promo.dart';

enum TipePromo { diskon, cashback }

class PromoViewModel extends ChangeNotifier {
  PromoViewModel({required PromoRepository promoRepository})
      : _repo = promoRepository;

  final PromoRepository _repo;

  bool isLoading = false;
  String? error;
  TipePromo tipe = TipePromo.diskon;
  List<Promo> _semua = [];

  List<Promo> get promoTerfilter =>
      _semua.where((p) => p.tipe == tipe.name).toList();

  Future<void> load() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      _semua = await _repo.getPromo();
    } catch (e) {
      error = 'Gagal memuat promo.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setTipe(TipePromo t) {
    tipe = t;
    notifyListeners();
  }
}