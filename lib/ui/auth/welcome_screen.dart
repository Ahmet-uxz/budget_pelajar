import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import 'auth_widgets.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _segera(BuildContext context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Segera hadir')));
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      showBack: false,
      headerHeight: 260,
      child: Column(
        children: [
          const SizedBox(height: 8),
          const Text('Hallo!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 4)),
          const SizedBox(height: 12),
          const Text(
            'Selamat Datang di BudgetPelajar\nSebuah Platform Untuk Memanajemen\nKeuangan Anda',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  label: 'LOGIN',
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    shape: const StadiumBorder(),
                    side: const BorderSide(color: AppColors.hijau, width: 1.5),
                    foregroundColor: AppColors.hijauTua,
                  ),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SignupScreen()),
                  ),
                  child: const Text('SIGNUP', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Text('Or continue with', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Icons.g_mobiledata, Icons.facebook, Icons.apple]
                .map((ikon) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: InkWell(
                onTap: () => _segera(context),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 48,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.mintSheet,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(ikon, color: AppColors.hijauTua),
                ),
              ),
            ))
                .toList(),
          ),
        ],
      ),
    );
  }
}