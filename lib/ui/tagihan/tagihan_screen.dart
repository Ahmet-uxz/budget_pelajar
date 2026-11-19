import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/tagihan_repository.dart';
import '../../domain/models/tagihan.dart';
import '../core/app_theme.dart';
import '../core/async_body.dart';
import '../core/formatters.dart';
import 'tagihan_view_model.dart';

class TagihanScreen extends StatefulWidget {
  const TagihanScreen({super.key});

  @override
  State<TagihanScreen> createState() => _TagihanScreenState();
}

class _TagihanScreenState extends State<TagihanScreen> {
  late final TagihanViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = TagihanViewModel(tagihanRepository: context.read<TagihanRepository>())
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
      appBar: AppBar(title: const Text('Tagihan & Pengingat')),
      body: ListenableBuilder(
        listenable: _vm,
        builder: (context, _) => AsyncBody(
          isLoading: _vm.isLoading,
          error: _vm.error,
          onRetry: _vm.load,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _judul('Belum Selesai (${_vm.belumSelesai.length})'),
              if (_vm.belumSelesai.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('Tidak ada tagihan yang tertunda.'),
                ),
              for (final t in _vm.belumSelesai) _item(t),
              const SizedBox(height: 16),
              _judul('Selesai (${_vm.selesai.length})'),
              if (_vm.selesai.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('Belum ada tagihan yang selesai.'),
                ),
              for (final t in _vm.selesai) _item(t),
            ],
          ),
        ),
      ),
    );
  }

  Widget _judul(String teks) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(teks,
        style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.hijauTua)),
  );

  Widget _item(Tagihan t) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: Colors.white,
      child: CheckboxListTile(
        value: t.isSelesai,
        activeColor: AppColors.hijau,
        controlAffinity: ListTileControlAffinity.leading,
        onChanged: (v) => _vm.toggle(t, v ?? false),
        title: Text(
          t.nama,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            decoration: t.isSelesai ? TextDecoration.lineThrough : null,
            color: t.isSelesai ? Colors.grey : null,
          ),
        ),
        subtitle: Text(
            '${rupiah(t.jumlah)} • Jatuh tempo ${tanggalPendek(t.jatuhTempo)}'),
      ),
    );
  }
}