import 'package:flutter/material.dart';

class AppColors {
  static const hijauTua = Color(0xFF0B5E3C);
  static const hijau = Color(0xFF047A4B);
  static const hijauMuda = Color(0xFF94CBA5);
  static const mint = Color(0xFFE8F8EE);
  static const mintSheet = Color(0xFFB5E6C8);
  static const oranye = Color(0xFFFFAB5C);
  static const voucher = Color(0xFF3DBE74);
  static const pemasukan = Color(0xFF55D17E);
  static const pengeluaran = Color(0xFFFF6B6B);
}

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.hijau,
      primary: AppColors.hijau,
    ),
    scaffoldBackgroundColor: AppColors.mint,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.hijauTua,
      foregroundColor: Colors.white,
      centerTitle: true,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: AppColors.mintSheet,
      labelTextStyle: WidgetStateProperty.all(
        const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    ),
  );
}