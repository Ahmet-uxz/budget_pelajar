import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/promo_repository.dart';
import '../../domain/models/promo.dart';
import '../core/app_theme.dart';
import '../core/async_body.dart';
import 'promo_view_model.dart';

class PromoScreen extends StatefulWidget {
  const PromoScreen({super.key});

  @override
  State<PromoScreen> createState() => _PromoScreenState();
}

class _PromoScreenState extends State<PromoScreen> {
  late final PromoViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = PromoViewModel(promoRepository: context.read<PromoRepository>())
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
      appBar: AppBar(title: const Text('Diskon & CashBack')),
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
                  child: SegmentedButton<TipePromo>(
                    style: SegmentedButton.styleFrom(
                      selectedBackgroundColor: AppColors.hijau,
                      selectedForegroundColor: Colors.white,
                    ),
                    segments: const [
                      ButtonSegment(value: TipePromo.diskon, label: Text('Diskon')),
                      ButtonSegment(
                          value: TipePromo.cashback, label: Text('CashBack')),
                    ],
                    selected: {_vm.tipe},
                    onSelectionChanged: (s) => _vm.setTipe(s.first),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: _vm.promoTerfilter.length,
                  itemBuilder: (context, i) =>
                      _VoucherCard(promo: _vm.promoTerfilter[i]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VoucherCard extends StatelessWidget {
  const _VoucherCard({required this.promo});
  final Promo promo;

  @override
  Widget build(BuildContext context) {
    final label = promo.tipe == 'diskon' ? 'DISCOUNT' : 'CASHBACK';

    return GestureDetector(
      onTap: () => _tampilDetail(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 44,
                color: AppColors.voucher,
                alignment: Alignment.center,
                child: RotatedBox(
                  quarterTurns: 3,
                  child: Text(label,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1)),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(promo.judul, style: const TextStyle(fontSize: 12)),
                      Text(promo.kode,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(promo.nilai, style: const TextStyle(fontSize: 12)),
                      const SizedBox(height: 2),
                      const Text('*Terms & conditions',
                          style: TextStyle(fontSize: 10, color: Colors.blue)),
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: promo.kode));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Kode ${promo.kode} disalin')),
                            );
                          },
                          child: const Text('Apply Code'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _tampilDetail(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.mint,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(promo.judul),
            Text(promo.kode,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('${promo.nilai} • Berlaku ${promo.berlaku}'),
            const Divider(),
            const Text('Syarat & Ketentuan',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            for (var i = 0; i < promo.syarat.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text('${i + 1}. ${promo.syarat[i]}'),
              ),
          ],
        ),
      ),
    );
  }
}