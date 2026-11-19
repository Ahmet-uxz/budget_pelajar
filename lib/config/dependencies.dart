import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../data/repositories/auth_repository.dart';
import '../data/repositories/promo_repository.dart';
import '../data/repositories/tagihan_repository.dart';
import '../data/repositories/transaksi_repository.dart';
import '../data/services/budget_pelajar_service.dart';

Widget withDependencies({required Widget child}) {
  return MultiProvider(
    providers: [
      Provider<BudgetPelajarService>(create: (_) => BudgetPelajarService()),
      ChangeNotifierProvider<AuthRepository>(
        create: (c) => AuthRepository(c.read<BudgetPelajarService>()),
      ),
      ChangeNotifierProvider<TransaksiRepository>(
        create: (c) => TransaksiRepository(c.read<BudgetPelajarService>()),
      ),
      ChangeNotifierProvider<TagihanRepository>(
        create: (c) => TagihanRepository(c.read<BudgetPelajarService>()),
      ),
      Provider<PromoRepository>(
        create: (c) => PromoRepository(c.read<BudgetPelajarService>()),
      ),
    ],
    child: child,
  );
}