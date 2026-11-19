import 'package:flutter/material.dart';

import '../../domain/models/transaksi.dart';
import 'app_theme.dart';
import 'formatters.dart';

/// Baris transaksi di atas latar hijau (Beranda & Riwayat).
class TransaksiTile extends StatelessWidget {
  const TransaksiTile({super.key, required this.transaksi, this.onTap});

  final Transaksi transaksi;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final t = transaksi;
    final warna = t.isPengeluaran ? AppColors.pengeluaran : AppColors.pemasukan;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Icon(
              t.isPengeluaran ? Icons.receipt_long : Icons.account_balance_wallet,
              color: warna,
              size: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.jenisLabel,
                    style: TextStyle(
                      color: warna,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    tanggalPendek(t.tanggal),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
            Text(
              '${t.isPengeluaran ? '−' : '+'} ${rupiah(t.jumlah)}',
              style: TextStyle(color: warna, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}