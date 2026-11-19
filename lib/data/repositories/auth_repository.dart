import 'package:flutter/foundation.dart';

import '../../domain/models/akun.dart';
import '../services/budget_pelajar_service.dart';

class AuthRepository extends ChangeNotifier {
  AuthRepository(this._service);
  final BudgetPelajarService _service;

  List<Akun>? _terdaftar;
  Akun? _aktif;
  bool _onboardingSelesai = false;

  Akun? get akun => _aktif;
  bool get isLoggedIn => _aktif != null;
  bool get onboardingSelesai => _onboardingSelesai;

  Future<List<Akun>> _muat() async {
    if (_terdaftar == null) {
      final raw = await _service.fetchAkun();
      _terdaftar = raw.map(Akun.fromJson).toList();
    }
    return _terdaftar!;
  }

  /// Mengembalikan pesan error, atau null jika berhasil.
  Future<String?> login(String id, String password) async {
    final daftar = await _muat();
    final cocok = daftar.where(
          (a) => a.email.toLowerCase() == id.toLowerCase() && a.password == password,
    );
    if (cocok.isEmpty) return 'Email/username atau password salah';
    _aktif = cocok.first;
    _onboardingSelesai = true;
    notifyListeners();
    return null;
  }

  /// Mengembalikan pesan error, atau null jika berhasil.
  Future<String?> daftar(String id, String password) async {
    final daftar = await _muat();
    if (daftar.any((a) => a.email.toLowerCase() == id.toLowerCase())) {
      return 'Email atau username sudah ada';
    }
    final baru = Akun(
      email: id,
      password: password,
      nama: id.split('@').first,
      noHp: '-',
    );
    daftar.add(baru);
    _aktif = baru;
    _onboardingSelesai = false;
    notifyListeners();
    return null;
  }

  void selesaikanOnboarding() {
    _onboardingSelesai = true;
    notifyListeners();
  }

  void ubahProfil({String? nama, String? noHp}) {
    final a = _aktif;
    if (a == null) return;
    final baru = a.copyWith(nama: nama, noHp: noHp);
    final i = _terdaftar?.indexWhere((x) => x.email == a.email) ?? -1;
    if (i != -1) _terdaftar![i] = baru;
    _aktif = baru;
    notifyListeners();
  }

  void logout() {
    _aktif = null;
    notifyListeners();
  }
}