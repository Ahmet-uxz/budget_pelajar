import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/tagihan_repository.dart';
import '../core/app_theme.dart';
import '../home/home_screen.dart';
import '../promo/promo_screen.dart';
import '../riwayat/riwayat_screen.dart';
import '../tagihan/tagihan_screen.dart';
import '../tambah_transaksi/tambah_transaksi_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final tagihanRepo = context.read<TagihanRepository>();

    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          HomeScreen(onLihatTagihan: () => setState(() => _index = 2)),
          const RiwayatScreen(),
          const TagihanScreen(),
          const PromoScreen(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.oranye,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const TambahTransaksiScreen()),
        ),
        child: const Icon(Icons.add, size: 30),
      ),
      bottomNavigationBar: ListenableBuilder(
        listenable: tagihanRepo,
        builder: (context, _) {
          final n = tagihanRepo.jumlahBelumSelesai;
          return NavigationBar(
            selectedIndex: _index,
            onDestinationSelected: (i) => setState(() => _index = i),
            destinations: [
              const NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Home',
              ),
              const NavigationDestination(
                icon: Icon(Icons.receipt_long_outlined),
                selectedIcon: Icon(Icons.receipt_long),
                label: 'Catatan',
              ),
              NavigationDestination(
                icon: Badge(
                  isLabelVisible: n > 0,
                  label: Text('$n'),
                  child: const Icon(Icons.checklist_outlined),
                ),
                selectedIcon: Badge(
                  isLabelVisible: n > 0,
                  label: Text('$n'),
                  child: const Icon(Icons.checklist),
                ),
                label: 'Tagihan',
              ),
              const NavigationDestination(
                icon: Icon(Icons.percent_outlined),
                selectedIcon: Icon(Icons.percent),
                label: 'Promo',
              ),
            ],
          );
        },
      ),
    );
  }
}