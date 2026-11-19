import '../../domain/models/promo.dart';
import '../services/budget_pelajar_service.dart';

class PromoRepository {
  PromoRepository(this._service);
  final BudgetPelajarService _service;

  Future<List<Promo>> getPromo() async {
    final raw = await _service.fetchPromo();
    return raw.map(Promo.fromJson).toList();
  }
}