import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/tagihan_repository.dart';
import '../../data/repositories/transaksi_repository.dart';
import '../core/app_theme.dart';
import '../core/async_body.dart';
import '../core/formatters.dart';
import '../core/transaksi_tile.dart';
import '../settings/settings_screen.dart';
import 'home_view_model.dart';

const _warnaPie = [
  Color(0xFFB8832A),
  Color(0xFFFFE6B3),
  Color(0xFF5A3410),
  Color(0xFF7A4A12),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.onLihatTagihan});
  final VoidCallback? onLihatTagihan;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeViewModel _vm;
  bool _saldoTersembunyi = false;

  @override
  void initState() {
    super.initState();
    _vm = HomeViewModel(
      transaksiRepository: context.read<TransaksiRepository>(),
      tagihanRepository: context.read<TagihanRepository>(),
    )..load();
  }

  @override
  void dispose() {
    _vm.dispose();
    super.dispose();
  }

  void _bukaSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SettingsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nama = context.watch<AuthRepository>().akun?.nama ?? 'Pelajar';

    return Scaffold(
      backgroundColor: AppColors.hijauTua,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _header(nama),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.hijauMuda,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: ListenableBuilder(
                  listenable: _vm,
                  builder: (context, _) => AsyncBody(
                    isLoading: _vm.isLoading,
                    error: _vm.error,
                    onRetry: _vm.load,
                    child: _isi(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(String nama) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 8, 4, 12),
    child: Row(
      children: [
        GestureDetector(
          onTap: _bukaSettings,
          child: CircleAvatar(
            backgroundColor: Colors.grey,
            child: Text(inisial(nama),
                style: const TextStyle(color: Colors.white)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(sapaan(),
                  style: const TextStyle(color: Colors.white, fontSize: 12)),
              Text(nama,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Pengingat tagihan',
          icon: const Icon(Icons.notifications_none, color: Colors.white),
          onPressed: widget.onLihatTagihan,
        ),
        IconButton(
          tooltip: 'Pengaturan',
          icon: const Icon(Icons.settings_outlined, color: Colors.white),
          onPressed: _bukaSettings,
        ),
      ],
    ),
  );

  Widget _isi() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      children: [
        _kartuSaldo(),
        const SizedBox(height: 14),
        _kartuRiwayat(),
        const SizedBox(height: 14),
        _kartuRingkasan(),
        const SizedBox(height: 14),
        _bagianTagihan(),
      ],
    );
  }

  Widget _pill(String teks) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
    decoration: BoxDecoration(
      color: AppColors.hijauTua,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(teks,
        style: const TextStyle(
            color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
  );

  Widget _kartuSaldo() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.hijau,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('Total Saldo',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () =>
                          setState(() => _saldoTersembunyi = !_saldoTersembunyi),
                      child: Icon(
                        _saldoTersembunyi
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    const Spacer(),
                    _pill(_vm.dompetTerpilih ?? 'Semua dompet'),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  _saldoTersembunyi ? 'Rp ••••••' : rupiah(_vm.saldo),
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
                const Divider(color: Colors.white54),
                const Row(
                  children: [
                    Text('Pilih dompet di bawah untuk memfilter',
                        style: TextStyle(color: Colors.white, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _vm.daftarDompet.map((d) {
                final aktif = _vm.dompetTerpilih == d;
                return InkWell(
                  onTap: () => _vm.pilihDompet(d),
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    child: Column(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: aktif ? AppColors.hijau : AppColors.mintSheet,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            d.toLowerCase().startsWith('bank')
                                ? Icons.credit_card
                                : Icons.account_balance_wallet_outlined,
                            color: aktif ? Colors.white : AppColors.hijauTua,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(d, style: const TextStyle(fontSize: 11)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _kartuRiwayat() {
    final data = _vm.transaksiTerbaru;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.hijau,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Spacer(),
              _pill('Riwayat Pencatatan'),
              const Spacer(),
              const Icon(Icons.history, color: Colors.white),
            ],
          ),
          const Divider(color: Colors.white54),
          if (data.isEmpty)
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text('Belum ada catatan di dompet ini.',
                  style: TextStyle(color: Colors.white)),
            )
          else
            for (final t in data) TransaksiTile(transaksi: t),
        ],
      ),
    );
  }

  Widget _kartuRingkasan() {
    final kategori = _vm.ringkasanKategori;
    final totalKeluar = _vm.totalPengeluaran;

    Widget baris(String label, String nilai, Color warna) => Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: warna, fontSize: 12)),
        Text(nilai, style: TextStyle(color: warna, fontSize: 12)),
      ],
    );

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.hijau,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _pill('Ringkasan'),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 90,
                height: 90,
                child: CustomPaint(
                  painter: _PiePainter(
                    kategori.map((e) => e.value.toDouble()).toList(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  children: [
                    baris('pemasukan', rupiah(_vm.totalPemasukan),
                        AppColors.pemasukan),
                    baris('pengeluaran', rupiah(totalKeluar),
                        AppColors.pengeluaran),
                    baris('Total', rupiah(_vm.saldo), Colors.white),
                    const Divider(color: Colors.white54),
                    for (var i = 0; i < kategori.length; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          children: [
                            Icon(Icons.circle, size: 10, color: _warnaPie[i]),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(kategori[i].key,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 12)),
                            ),
                            Text(
                              '(${(kategori[i].value / totalKeluar * 100).toStringAsFixed(1)}%)',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bagianTagihan() {
    final data = _vm.tagihanBelumSelesai;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.hijauTua,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Tagihan Belum Selesai (${data.length})',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              TextButton(
                onPressed: widget.onLihatTagihan,
                child: const Text('Lihat semua →',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          if (data.isEmpty)
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text('Semua tagihan sudah selesai.',
                  style: TextStyle(color: Colors.white)),
            )
          else
            for (final t in data.take(3))
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.mint,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(t.nama,
                              style:
                              const TextStyle(fontWeight: FontWeight.w600)),
                          Text('Jatuh tempo ${tanggalPendek(t.jatuhTempo)}',
                              style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                    Text(rupiah(t.jumlah),
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}

class _PiePainter extends CustomPainter {
  _PiePainter(this.values);
  final List<double> values;

  @override
  void paint(Canvas canvas, Size size) {
    final total = values.fold<double>(0, (a, b) => a + b);
    if (total == 0) return;
    final rect = Offset.zero & size;
    var mulai = -math.pi / 2;
    for (var i = 0; i < values.length; i++) {
      final sapuan = values[i] / total * 2 * math.pi;
      canvas.drawArc(rect, mulai, sapuan, true,
          Paint()..color = _warnaPie[i % _warnaPie.length]);
      mulai += sapuan;
    }
  }

  @override
  bool shouldRepaint(covariant _PiePainter old) => true;
}