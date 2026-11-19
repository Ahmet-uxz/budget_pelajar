import 'package:budget_pelajar/data/repositories/promo_repository.dart';
import 'package:budget_pelajar/data/services/budget_pelajar_service.dart';
import 'package:budget_pelajar/ui/promo/promo_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeService extends BudgetPelajarService {
  _FakeService({this.gagal = false});
  final bool gagal;

  @override
  Future<List<Map<String, dynamic>>> fetchPromo() async {
    if (gagal) throw Exception('server error');
    Map<String, dynamic> promo(int id, String tipe) => {
      'id': id,
      'judul': 'Promo $id',
      'kode': 'KODE$id',
      'nilai': 'Rp 5.000',
      'tipe': tipe,
      'berlaku': 's.d 01 Des 2026',
      'syarat': ['Syarat 1'],
    };
    return [promo(1, 'diskon'), promo(2, 'diskon'), promo(3, 'cashback')];
  }
}

void main() {
  test('state awal: tidak loading dan tidak ada error', () {
    final vm = PromoViewModel(
        promoRepository: PromoRepository(_FakeService()));
    expect(vm.isLoading, false);
    expect(vm.error, isNull);
    expect(vm.promoTerfilter, isEmpty);
  });

  test('load() berhasil mengisi data dan isLoading kembali false', () async {
    final vm = PromoViewModel(
        promoRepository: PromoRepository(_FakeService()));

    final future = vm.load();
    expect(vm.isLoading, true);
    await future;

    expect(vm.isLoading, false);
    expect(vm.error, isNull);
    expect(vm.promoTerfilter.length, 2); // default tipe = diskon
  });

  test('setTipe(cashback) memfilter promo', () async {
    final vm = PromoViewModel(
        promoRepository: PromoRepository(_FakeService()));
    await vm.load();

    vm.setTipe(TipePromo.cashback);

    expect(vm.promoTerfilter.length, 1);
    expect(vm.promoTerfilter.first.tipe, 'cashback');
  });

  test('load() gagal mengisi error', () async {
    final vm = PromoViewModel(
        promoRepository: PromoRepository(_FakeService(gagal: true)));

    await vm.load();

    expect(vm.isLoading, false);
    expect(vm.error, isNotNull);
    expect(vm.promoTerfilter, isEmpty);
  });
}