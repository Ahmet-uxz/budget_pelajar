import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/auth_repository.dart';
import '../core/app_theme.dart';
import 'auth_widgets.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _id = TextEditingController();
  final _pw = TextEditingController();
  String? _error;
  bool _loading = false;
  bool _ingat = false;

  @override
  void dispose() {
    _id.dispose();
    _pw.dispose();
    super.dispose();
  }

  Future<void> _masuk() async {
    if (_id.text.trim().isEmpty || _pw.text.isEmpty) {
      setState(() => _error = 'Email/username dan password wajib diisi');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    final err = await context
        .read<AuthRepository>()
        .login(_id.text.trim(), _pw.text);
    if (!mounted) return;
    if (err != null) {
      setState(() {
        _loading = false;
        _error = err;
      });
      return;
    }
    // RootGate sudah berganti ke layar berikutnya; tutup layar Login.
    Navigator.of(context).popUntil((r) => r.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text('LOGIN',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 20),
          AuthField(
            label: 'Email or Username',
            hint: 'Masukkan email atau username',
            controller: _id,
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 14),
          AuthField(
            label: 'Password',
            hint: 'Masukkan Password',
            controller: _pw,
            isPassword: true,
            error: _error,
          ),
          Row(
            children: [
              Checkbox(
                value: _ingat,
                activeColor: AppColors.hijau,
                onChanged: (v) => setState(() => _ingat = v ?? false),
              ),
              const Text('Remember me', style: TextStyle(fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          PrimaryButton(label: 'Login', onPressed: _masuk, loading: _loading),
          const SizedBox(height: 12),
          Center(
            child: TextButton(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Segera hadir')),
              ),
              child: const Text('Forgot Password?'),
            ),
          ),
          const SizedBox(height: 4),
          const Center(
            child: Text('Akun demo: demo@gmail.com / 12345678',
                style: TextStyle(fontSize: 11, color: Colors.black54)),
          ),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const SignupScreen()),
              ),
              child: const Text("Don't have an account? SignUp"),
            ),
          ),
        ],
      ),
    );
  }
}