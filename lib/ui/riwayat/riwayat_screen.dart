import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/transaksi_repository.dart';
import '../../domain/models/transaksi.dart';
import '../core/app_theme.dart';
import '../core/async_body.dart';
import '../core/formatters.dart';
import '../core/transaksi_tile.dart';
import 'riwayat_view_model.dart';

class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({super.key});

  @override
  State<RiwayatScreen> createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  late final RiwayatViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = RiwayatViewModel(transaksiRepository: context.read<TransaksiRepository>())
      ..load();
  }

  @override
  void dispose() {
    _vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Pencatatan')),
      body: ListenableBuilder(
        listenable: _vm,
        builder: (context, _) => AsyncBody(
          isLoading: _vm.isLoading,
          error: _vm.error,
          onRetry: _vm.load,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<FilterTransaksi>(
                    style: SegmentedButton.styleFrom(
                      selectedBackgroundColor: AppColors.hijau,
                      selectedForegroundColor: Colors.white,
                    ),
                    segments: const [
                      ButtonSegment(
                          value: FilterTransaksi.semua, label: Text('Semua')),
                      ButtonSegment(
                          value: FilterTransaksi.pengeluaran,
                          label: Text('Pengeluaran')),
                      ButtonSegment(
                          value: FilterTransaksi.pemasukan,
                          label: Text('Pemasukan')),
                    ],
                    selected: {_vm.filter},
                    onSelectionChanged: (s) => _vm.setFilter(s.first),
                  ),
                ),
              ),
              Expanded(
                child: _vm.grup.isEmpty
                    ? const Center(child: Text('Belum ada catatan.'))
                    : ListView(
                  padding: const EdgeInsets.only(bottom: 16),
                  children: [
                    for (final g in _vm.grup) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        child: Row(
                          children: [
                            Text(g.label,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('Pengeluaran : ${rupiah(g.pengeluaran)}',
                                    style: const TextStyle(fontSize: 11)),
                                Text('Pemasukan : ${rupiah(g.pemasukan)}',
                                    style: const TextStyle(fontSize: 11)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: AppColors.hijau,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        child: Column(
                          children: [
                            for (final t in g.items)
                              TransaksiTile(
                                transaksi: t,
                                onTap: () => _tampilDetail(context, t),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _tampilDetail(BuildContext context, Transaksi t) {
    Widget baris(String label, String nilai, {Color? warna}) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 90, child: Text(label)),
          Expanded(
            child: Text(nilai,
                style: TextStyle(color: warna, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.mint,
      showDragHandle: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.jenisLabel,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: t.isPengeluaran ? Colors.red : AppColors.hijau,
              ),
            ),
            const Divider(),
            baris('Kategori', t.kategori),
            baris(
              'Jumlah',
              '${t.isPengeluaran ? '-' : '+'}${rupiah(t.jumlah)}',
              warna: t.isPengeluaran ? Colors.red : AppColors.hijau,
            ),
            baris('Tanggal', tanggalPendek(t.tanggal)),
            baris('Dompet', t.dompet),
            baris('Catatan', t.catatan),
          ],
        ),
      ),
    );
  }
}