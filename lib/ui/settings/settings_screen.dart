import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/transaksi_repository.dart';
import '../core/app_theme.dart';
import '../core/formatters.dart';
import '../core/kategori.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _biometrik = false;

  void _segera() {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Segera hadir')));
  }

  Future<String?> _dialogTeks(String judul, String awal) {
    final c = TextEditingController(text: awal == '-' ? '' : awal);
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(judul),
        content: TextField(controller: c, autofocus: true),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, c.text.trim()),
              child: const Text('Simpan')),
        ],
      ),
    );
  }

  void _info(String judul, String isi) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(judul),
        content: Text(isi),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Tutup')),
        ],
      ),
    );
  }

  void _lihatKategori() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.mintSheet,
      showDragHandle: true,
      builder: (_) => ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        children: [
          const Text('Kategori Pengeluaran',
              style: TextStyle(fontWeight: FontWeight.bold)),
          for (final k in kategoriPengeluaran) ListTile(dense: true, title: Text(k)),
          const Divider(),
          const Text('Kategori Pemasukan',
              style: TextStyle(fontWeight: FontWeight.bold)),
          for (final k in kategoriPemasukan) ListTile(dense: true, title: Text(k)),
        ],
      ),
    );
  }

  Future<void> _tambahDompet() async {
    final nama = await _dialogTeks('Nama dompet baru', '');
    if (nama == null || nama.isEmpty || !mounted) return;
    context.read<TransaksiRepository>().tambahDompet(nama);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Dompet "$nama" ditambahkan')));
  }

  Future<void> _logout() async {
    final yakin = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Yakin ingin keluar dari akun?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Batal')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Keluar')),
        ],
      ),
    );
    if (yakin != true || !mounted) return;
    final auth = context.read<AuthRepository>();
    Navigator.of(context).popUntil((r) => r.isFirst);
    auth.logout();
  }

  // ---------- komponen tampilan ----------

  Widget _judul(String teks) => Padding(
    padding: const EdgeInsets.fromLTRB(4, 14, 0, 8),
    child: Text(teks,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
  );

  Widget _grup(List<Widget> rows) {
    final isi = <Widget>[];
    for (var i = 0; i < rows.length; i++) {
      isi.add(rows[i]);
      if (i != rows.length - 1) {
        isi.add(const Divider(height: 1, color: Colors.white38));
      }
    }
    return Container(
      decoration: BoxDecoration(
        color: AppColors.hijau,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(children: isi),
    );
  }

  Widget _baris(
      IconData ikon,
      String label, {
        String? nilai,
        Widget? trailing,
        VoidCallback? onTap,
      }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Icon(ikon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label,
                  style: const TextStyle(color: Colors.white, fontSize: 14)),
            ),
            if (nilai != null)
              Text(nilai,
                  style: const TextStyle(color: Colors.white70, fontSize: 13)),
            trailing ??
                const Icon(Icons.chevron_right, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthRepository>();
    final akun = auth.akun;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          _judul('Profile saya'),
          _grup([
            _baris(
              Icons.person_outline,
              'Foto profile',
              onTap: _segera,
              trailing: CircleAvatar(
                radius: 14,
                backgroundColor: Colors.grey,
                child: Text(inisial(akun?.nama ?? '?'),
                    style: const TextStyle(color: Colors.white, fontSize: 11)),
              ),
            ),
            _baris(Icons.badge_outlined, 'Nama', nilai: akun?.nama, onTap: () async {
              final v = await _dialogTeks('Ubah nama', akun?.nama ?? '');
              if (v != null && v.isNotEmpty) auth.ubahProfil(nama: v);
            }),
            _baris(Icons.phone_outlined, 'No. Handphone', nilai: akun?.noHp,
                onTap: () async {
                  final v = await _dialogTeks('Ubah No. Handphone', akun?.noHp ?? '');
                  if (v != null && v.isNotEmpty) auth.ubahProfil(noHp: v);
                }),
            _baris(Icons.email_outlined, 'Email',
                nilai: akun?.email,
                trailing: const SizedBox(width: 4)),
          ]),
          _judul('Pengelolaan'),
          _grup([
            _baris(Icons.account_balance_wallet_outlined, 'Tambah dompet',
                onTap: _tambahDompet),
            _baris(Icons.attach_money, 'Mata Uang',
                nilai: 'IDR',
                onTap: () => _info('Mata Uang', 'IDR - Indonesia Rupiah')),
            _baris(Icons.category_outlined, 'Kategori', onTap: _lihatKategori),
            _baris(Icons.savings_outlined, 'Anggaran', onTap: _segera),
            _baris(Icons.handshake_outlined, 'Utang', onTap: _segera),
          ]),
          _judul('Konfigurasi'),
          _grup([
            _baris(
              Icons.fingerprint,
              'Login Biometrik',
              trailing: Switch(
                value: _biometrik,
                onChanged: (v) => setState(() => _biometrik = v),
              ),
            ),
            _baris(Icons.notifications_none, 'Notifikasi & Reminder',
                onTap: _segera),
            _baris(Icons.language, 'Bahasa', nilai: 'Indonesia', onTap: _segera),
            _baris(Icons.lock_outline, 'Kata sandi', onTap: _segera),
          ]),
          _judul('Lainnya'),
          _grup([
            _baris(Icons.star_border, 'Kasih Ulasan', onTap: _segera),
            _baris(Icons.description_outlined, 'Syarat dan Ketentuan',
                onTap: () => _info('Syarat dan Ketentuan',
                    'BudgetPelajar dibuat untuk membantu pelajar mencatat keuangan. Data pada aplikasi ini hanya contoh.')),
            _baris(Icons.help_outline, 'Pusat Bantuan',
                onTap: () => _info('Pusat Bantuan',
                    'Butuh bantuan? Hubungi tim BudgetPelajar melalui email bantuan@budgetpelajar.id')),
          ]),
          const SizedBox(height: 12),
          const Center(child: Text('Version 1.0', style: TextStyle(fontSize: 12))),
          const SizedBox(height: 12),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.hijau,
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: _logout,
            child: const Text('Log Out',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}