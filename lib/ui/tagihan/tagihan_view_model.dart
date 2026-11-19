import 'package:flutter/foundation.dart';

import '../../data/repositories/tagihan_repository.dart';
import '../../domain/models/tagihan.dart';

class TagihanViewModel extends ChangeNotifier {
  TagihanViewModel({required TagihanRepository tagihanRepository})
      : _repo = tagihanRepository {
    _repo.addListener(notifyListeners);
  }

  final TagihanRepository _repo;

  bool isLoading = false;
  String? error;

  List<Tagihan> get belumSelesai => _repo.belumSelesai;
  List<Tagihan> get selesai => _repo.selesai;

  Future<void> load() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      await _repo.load();
    } catch (e) {
      error = 'Gagal memuat daftar tagihan.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void toggle(Tagihan t, bool selesai) => _repo.toggle(t.id, selesai);

  @override
  void dispose() {
    _repo.removeListener(notifyListeners);
    super.dispose();
  }
}