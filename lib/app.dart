import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config/dependencies.dart';
import 'data/repositories/auth_repository.dart';
import 'ui/auth/onboarding_screen.dart';
import 'ui/auth/welcome_screen.dart';
import 'ui/core/app_theme.dart';
import 'ui/shell/app_shell.dart';

class BudgetPelajarApp extends StatelessWidget {
  const BudgetPelajarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return withDependencies(
      child: MaterialApp(
        title: 'BudgetPelajar',
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        home: const _RootGate(),
      ),
    );
  }
}

/// Belum login -> Welcome, baru daftar -> Onboarding, selebihnya -> AppShell.
class _RootGate extends StatelessWidget {
  const _RootGate();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthRepository>();
    if (!auth.isLoggedIn) return const WelcomeScreen();
    if (!auth.onboardingSelesai) return const OnboardingScreen();
    return const AppShell();
  }
}