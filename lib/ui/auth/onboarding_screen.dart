import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/transaksi_repository.dart';
import '../../domain/models/transaksi.dart';
import '../core/app_theme.dart';
import 'auth_widgets.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const _judul = [
    'Akun Berhasil di Buat',
    'Menambahkan Dompet',
    'Pilih Mata Uang',
    'Masukan Saldo Dompet',
  ];
  static const _mataUang = {
    'IDR': 'Indonesia Rupiah',
    'USD': 'US Dollar',
    'MYR': 'Malaysian Ringgit',
  };

  int _step = 0;
  final _nama = TextEditingController();
  final _saldo = TextEditingController();
  String _kode = 'IDR';
  String? _error;

  @override
  void dispose() {
    _nama.dispose();
    _saldo.dispose();
    super.dispose();
  }

  void _lanjut() {
    if (_step == 1 && _nama.text.trim().isEmpty) {
      setState(() => _error = 'Nama dompet wajib diisi');
      return;
    }
    setState(() => _error = null);
    if (_step < 3) {
      setState(() => _step++);
    } else {
      _selesai();
    }
  }

  void _selesai() {
    final repo = context.read<TransaksiRepository>();
    final nama = _nama.text.trim();
    final saldo = int.tryParse(_saldo.text) ?? 0;

    repo.tambahDompet(nama);
    if (saldo > 0) {
      repo.tambah(Transaksi(
        id: repo.buatId(),
        isPengeluaran: false,
        kategori: 'Saldo awal',
        jumlah: saldo,
        tanggal: DateTime.now(),
        dompet: nama,
        catatan: 'Saldo awal dompet',
      ));
    }
    context.read<AuthRepository>().selesaikanOnboarding();
  }

  Widget _isi() {
    switch (_step) {
      case 0:
        return const Column(
          children: [
            SizedBox(height: 16),
            Ilustrasi(ikon: Icons.check_circle_outline),
            SizedBox(height: 20),
            Text(
              'Akunmu sudah siap! Yuk atur dompet pertamamu supaya uang saku dan pengeluaran kuliahmu tercatat rapi.',
              textAlign: TextAlign.center,
            ),
          ],
        );
      case 1:
        return Column(
          children: [
            AuthField(
              label: 'Nama dompet',
              hint: 'Masukkan nama dompet anda',
              controller: _nama,
              error: _error,
            ),
            const SizedBox(height: 24),
            const Ilustrasi(ikon: Icons.savings_outlined),
          ],
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Mata Uang',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: _kode,
              items: _mataUang.entries
                  .map((e) => DropdownMenuItem(
                value: e.key,
                child: Text('${e.key}   ${e.value}'),
              ))
                  .toList(),
              onChanged: (v) => setState(() => _kode = v ?? 'IDR'),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFFAFAFA),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.hijau),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Center(child: Ilustrasi(ikon: Icons.currency_exchange)),
          ],
        );
      default:
        return Column(
          children: [
            AuthField(
              label: 'Saldo di dompet anda',
              hint: 'Masukkan Saldo Awal anda',
              controller: _saldo,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 24),
            const Ilustrasi(ikon: Icons.account_balance_wallet_outlined),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.hijauTua,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
              child: Row(
                children: [
                  _step > 0
                      ? IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => setState(() => _step--),
                  )
                      : const SizedBox(width: 48, height: 48),
                  const Spacer(),
                  Text('Step ${_step + 1} of 4',
                      style: const TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: LinearProgressIndicator(
                value: (_step + 1) / 4,
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
                backgroundColor: Colors.white,
                color: AppColors.voucher,
              ),
            ),
            const SizedBox(height: 24),
            Text(_judul[_step],
                style: const TextStyle(color: Colors.white, fontSize: 20)),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.mint,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      _isi(),
                      const SizedBox(height: 24),
                      PrimaryButton(
                        label: _step == 3 ? 'Selesai' : 'Continue',
                        arrow: true,
                        onPressed: _lanjut,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}