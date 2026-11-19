import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/transaksi_repository.dart';
import '../../domain/models/transaksi.dart';
import '../core/app_theme.dart';
import '../core/formatters.dart';
import '../core/kategori.dart';

class TambahTransaksiScreen extends StatefulWidget {
  const TambahTransaksiScreen({super.key});

  @override
  State<TambahTransaksiScreen> createState() => _TambahTransaksiScreenState();
}

class _TambahTransaksiScreenState extends State<TambahTransaksiScreen> {
  final _jumlah = TextEditingController();
  final _catatan = TextEditingController();
  bool _pengeluaran = true;
  String? _kategori;
  String? _dompet;
  DateTime _tanggal = DateTime.now();
  String? _error;

  @override
  void dispose() {
    _jumlah.dispose();
    _catatan.dispose();
    super.dispose();
  }

  Future<void> _pilihTanggal() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _tanggal,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (d != null) setState(() => _tanggal = d);
  }

  void _simpan() {
    final jumlah = int.tryParse(_jumlah.text) ?? 0;
    if (jumlah <= 0) {
      setState(() => _error = 'Jumlah harus lebih dari 0');
      return;
    }
    if (_kategori == null || _dompet == null) {
      setState(() => _error = 'Kategori dan dompet wajib dipilih');
      return;
    }

    final repo = context.read<TransaksiRepository>();
    final messenger = ScaffoldMessenger.of(context);
    repo.tambah(Transaksi(
      id: repo.buatId(),
      isPengeluaran: _pengeluaran,
      kategori: _kategori!,
      jumlah: jumlah,
      tanggal: _tanggal,
      dompet: _dompet!,
      catatan: _catatan.text.trim().isEmpty ? '-' : _catatan.text.trim(),
    ));
    Navigator.of(context).pop();
    messenger.showSnackBar(
      const SnackBar(content: Text('Catatan transaksi tersimpan')),
    );
  }

  Widget _label(String teks) => Padding(
    padding: const EdgeInsets.only(top: 16, bottom: 6),
    child: Text(teks, style: const TextStyle(fontWeight: FontWeight.w600)),
  );

  InputDecoration _dekor({String? hint, String? prefix}) => InputDecoration(
    hintText: hint,
    prefixText: prefix,
    filled: true,
    fillColor: const Color(0xFFFAFAFA),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.hijau),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.hijau),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final dompet = context.read<TransaksiRepository>().daftarDompet;
    final kategori = _pengeluaran ? kategoriPengeluaran : kategoriPemasukan;

    return Scaffold(
      appBar: AppBar(title: const Text('Catatan Transaksi')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<bool>(
              style: SegmentedButton.styleFrom(
                selectedBackgroundColor: AppColors.hijau,
                selectedForegroundColor: Colors.white,
              ),
              segments: const [
                ButtonSegment(value: true, label: Text('Pengeluaran')),
                ButtonSegment(value: false, label: Text('Pemasukan')),
              ],
              selected: {_pengeluaran},
              onSelectionChanged: (s) => setState(() {
                _pengeluaran = s.first;
                _kategori = null;
              }),
            ),
          ),
          _label('Jumlah'),
          TextField(
            controller: _jumlah,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: _dekor(hint: 'Masukkan jumlah', prefix: 'Rp '),
          ),
          _label('Kategori'),
          DropdownButtonFormField<String>(
            key: ValueKey(_pengeluaran),
            value: _kategori,
            hint: Text(_pengeluaran
                ? 'Pilih kategori pengeluaran'
                : 'Pilih kategori pemasukan'),
            items: kategori
                .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                .toList(),
            onChanged: (v) => setState(() => _kategori = v),
            decoration: _dekor(),
          ),
          _label('Tanggal'),
          OutlinedButton.icon(
            onPressed: _pilihTanggal,
            icon: const Icon(Icons.calendar_today, size: 18),
            label: Align(
              alignment: Alignment.centerLeft,
              child: Text(tanggalPendek(_tanggal)),
            ),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              foregroundColor: Colors.black87,
              side: const BorderSide(color: AppColors.hijau),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
          ),
          _label('Pilih dompet'),
          DropdownButtonFormField<String>(
            value: _dompet,
            hint: const Text('Pilih dompet yang digunakan'),
            items: dompet
                .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                .toList(),
            onChanged: (v) => setState(() => _dompet = v),
            decoration: _dekor(),
          ),
          _label('Catatan'),
          TextField(
            controller: _catatan,
            decoration: _dekor(hint: 'Masukan catatan, mis. Bayar UKT'),
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            ),
          const SizedBox(height: 24),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.hijau,
              minimumSize: const Size.fromHeight(48),
              shape: const StadiumBorder(),
            ),
            onPressed: _simpan,
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}