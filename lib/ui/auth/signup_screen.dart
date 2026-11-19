import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/auth_repository.dart';
import 'auth_widgets.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _id = TextEditingController();
  final _pw = TextEditingController();
  final _pw2 = TextEditingController();
  String? _errId;
  String? _errPw;
  String? _errPw2;
  bool _loading = false;

  @override
  void dispose() {
    _id.dispose();
    _pw.dispose();
    _pw2.dispose();
    super.dispose();
  }

  Future<void> _daftar() async {
    setState(() {
      _errId = _id.text.trim().isEmpty ? 'Email atau username wajib diisi' : null;
      _errPw = _pw.text.length < 6 ? 'Password minimal 6 karakter' : null;
      _errPw2 = _pw2.text != _pw.text ? 'password yang anda masukan tidak sama' : null;
    });
    if (_errId != null || _errPw != null || _errPw2 != null) return;

    setState(() => _loading = true);
    final err = await context
        .read<AuthRepository>()
        .daftar(_id.text.trim(), _pw.text);
    if (!mounted) return;
    if (err != null) {
      setState(() {
        _loading = false;
        _errId = err;
      });
      return;
    }
    Navigator.of(context).popUntil((r) => r.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text('Create  An Account',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 20),
          AuthField(
            label: 'Email or Username',
            hint: 'Masukkan email atau username',
            controller: _id,
            icon: Icons.person_outline,
            error: _errId,
          ),
          const SizedBox(height: 14),
          AuthField(
            label: 'Password',
            hint: 'Masukkan Password',
            controller: _pw,
            isPassword: true,
            error: _errPw,
          ),
          const SizedBox(height: 14),
          AuthField(
            label: 'Re-type Password',
            hint: 'Masukkan ulang password',
            controller: _pw2,
            isPassword: true,
            error: _errPw2,
          ),
          const SizedBox(height: 24),
          PrimaryButton(label: 'Continue', onPressed: _daftar, loading: _loading),
          const SizedBox(height: 24),
          Center(
            child: TextButton(
              onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              ),
              child: const Text('Already have an account? LogIn'),
            ),
          ),
        ],
      ),
    );
  }
}