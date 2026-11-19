# BudgetPelajar

Aplikasi Flutter untuk mencatat dan mengelola keuangan pelajar/mahasiswa, dibuat dengan arsitektur berlapis (View, ViewModel, Repository, Service) sesuai panduan resmi Flutter.

## Tema dan Alasan Memilih

Tema aplikasi ini adalah **manajemen keuangan pelajar**. Saya memilih tema ini karena uang saku, biaya kos, UKT, dan tagihan bulanan adalah masalah nyata yang saya dan teman-teman alami, tetapi jarang tercatat dengan rapi. Tema ini juga cocok untuk tugas karena punya tiga jenis data yang jelas: transaksi yang punya tanggal dan kategori, tagihan yang bisa dicentang selesai, serta informasi promo/diskon yang membantu pelajar berhemat.

## Desain UI

Desain antarmuka dibuat di Figma:
[https://www.figma.com/design/vjG3QRGwLjP7ZF2LetBLWs/BudgetPelajar?node-id=1-2&p=f&t=yu1Co9WQC14zLJR1-0](https://www.figma.com/design/vjG3QRGwLjP7ZF2LetBLWs/BudgetPelajar?node-id=1-2&p=f&t=yu1Co9WQC14zLJR1-0)

## Pemetaan Data

| Jenis data | Model | Isi | Repository | Halaman |
|---|---|---|---|---|
| Data utama | `Transaksi` | Pemasukan/pengeluaran dengan tanggal, kategori, dompet, catatan | `TransaksiRepository` | Beranda dan Catatan (Daftar per kategori) |
| Data aksi | `Tagihan` | Tagihan yang bisa dicentang selesai (UKT, kos, listrik, dll.) | `TagihanRepository` (`ChangeNotifier`) | Beranda dan Tagihan (Checklist) |
| Data informasi | `Promo` | Voucher diskon dan cashback | `PromoRepository` | Promo (Fitur buatan sendiri) |

## Empat Halaman dalam NavigationBar

| Tab | Isi |
|---|---|
| **Home** | Gabungan dua repository: transaksi pada dompet yang dipilih (saldo, riwayat terbaru, ringkasan kategori) dan tagihan yang belum selesai. |
| **Catatan** | Daftar transaksi dengan `SegmentedButton` 3 segmen: Semua, Pengeluaran, Pemasukan. Dikelompokkan per bulan. |
| **Tagihan** | Checklist dengan `CheckboxListTile`. Item yang dicentang pindah ke bagian *Selesai*. Badge pada tab menunjukkan jumlah tagihan yang belum selesai. |
| **Promo** | Fitur buatan sendiri (lihat di bawah). |

## Fitur Buatan Sendiri: Promo Diskon & Cashback

Halaman ini menampilkan voucher dari `PromoRepository` dengan filter **Diskon / CashBack** (`SegmentedButton`). Setiap voucher punya kode, nilai, masa berlaku, serta syarat dan ketentuan. Menekan kartu voucher membuka detail syarat dan ketentuan, dan tombol **Apply Code** menyalin kode voucher ke clipboard. Fitur ini dibuat agar pelajar mudah menemukan potongan harga untuk kebutuhan sehari-hari.

## Fitur Tambahan (di luar 4 tab wajib)

- **Welcome, Login, dan Signup** dengan validasi form.
- **Onboarding 4 langkah** setelah mendaftar: akun berhasil dibuat, nama dompet, mata uang, dan saldo awal.
- **Catatan Transaksi**: tombol **+** untuk menambah pemasukan/pengeluaran dengan kategori khas pelajar (Pendidikan, Kos, Makanan, Transportasi, Beasiswa, Uang saku, dll.).
- **Settings**: ubah nama dan nomor HP, tambah dompet, lihat kategori, dan Log Out. Dibuka dari ikon gear di Beranda.
- Ikon lonceng di Beranda membuka tab Tagihan sebagai pengingat.

> Akun demo: `demo@gmail.com` / `12345678`

## Arsitektur

```
lib/
├── main.dart
├── app.dart
├── config/
│   └── dependencies.dart          # MultiProvider (Service + semua Repository)
├── domain/models/
│   ├── transaksi.dart             # data utama
│   ├── tagihan.dart               # data aksi (punya copyWith)
│   ├── promo.dart                 # data informasi
│   └── akun.dart
├── data/
│   ├── services/budget_pelajar_service.dart   # data contoh + Future.delayed
│   └── repositories/
│       ├── transaksi_repository.dart
│       ├── tagihan_repository.dart            # ChangeNotifier
│       ├── promo_repository.dart
│       └── auth_repository.dart
└── ui/
    ├── core/                      # tema, formatter, widget bersama
    ├── shell/app_shell.dart       # NavigationBar
    ├── home/
    ├── riwayat/                   # halaman daftar (Catatan)
    ├── tagihan/                   # halaman checklist
    ├── promo/                     # fitur buatan sendiri
    ├── auth/                      # welcome, login, signup, onboarding
    ├── settings/
    └── tambah_transaksi/
```

- Setiap halaman utama memiliki satu `ViewModel` (`ChangeNotifier`) berisi `isLoading`, `error`, dan `load()`, yang ditampilkan di View memakai `ListenableBuilder`.
- Service dan semua Repository didaftarkan di `config/dependencies.dart` memakai `MultiProvider`, lalu diambil dengan `context.read()`.
- `TagihanRepository` adalah `ChangeNotifier`, sehingga Beranda dan badge tab Tagihan ikut berubah saat item dicentang.

## Cara Menjalankan

```bash
git clone <URL-REPOSITORY-KAMU>
cd budget_pelajar
flutter pub get
flutter run
```

Menjalankan test:

```bash
flutter test
```

## Screenshot

### Setiap Tab

| Home | Catatan |
|---|---|
| ![Home](<img width="1209" height="2553" alt="Screenshot_20261119_134924" src="https://github.com/user-attachments/assets/83dcbb28-a466-47ee-b7b5-32edc089803f" />
) | ![Catatan](<img width="1209" height="2553" alt="Screenshot_20261119_134939" src="https://github.com/user-attachments/assets/18e6506b-e6bb-49b4-bf15-2ab77b23f041" />
) |

| Tagihan | Promo |
|---|---|
| ![Tagihan](<img width="1209" height="2553" alt="Screenshot_20261119_134946" src="https://github.com/user-attachments/assets/b85c2f69-1fe3-417b-94ce-d4338f148418" />
) | ![Promo](<img width="1209" height="2553" alt="Screenshot_20261119_134957" src="https://github.com/user-attachments/assets/4503f9c5-6a0d-4995-b399-efec6462f3da" />
) |

### Catatan Transaksi

|  | Catatan Transaksi | 
|---|---|
| ![Catatan Transaksi](<img width="1209" height="2553" alt="Screenshot_20261119_135013" src="https://github.com/user-attachments/assets/3dec47f4-b769-4b3b-8c9a-51d1bcfaf282" />
) |


### Layar Tambahan

| Welcome | Login | Settings |
|---|---|---|
| ![Welcome](<img width="1209" height="2553" alt="Screenshot_20261119_134734" src="https://github.com/user-attachments/assets/8b14dab8-1a7f-40de-b6a9-8e297e0faa00" />
) | ![Login](<img width="1209" height="2553" alt="Screenshot_20261119_134743" src="https://github.com/user-attachments/assets/a790e3d1-1e47-430a-97ed-873966c1d332" />
) | ![Settings](<img width="1209" height="2553" alt="Screenshot_20261119_135044" src="https://github.com/user-attachments/assets/9b9e1122-4729-4728-8ac2-e2f9c2541bf0" />
) |
