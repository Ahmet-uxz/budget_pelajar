import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/app_theme.dart';

/// Header hijau dengan ilustrasi + lembar mint melengkung (Welcome/Login/Signup).
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.child,
    this.showBack = true,
    this.headerHeight = 170,
  });

  final Widget child;
  final bool showBack;
  final double headerHeight;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.hijauTua,
      body: Column(
        children: [
          SizedBox(
            height: headerHeight,
            child: SafeArea(
              child: Stack(
                children: [
                  const Center(child: Ilustrasi(ikon: Icons.account_balance_wallet, ukuran: 110)),
                  if (showBack)
                    Positioned(
                      left: 4,
                      bottom: 0,
                      child: BackButton(
                        color: Colors.white,
                        onPressed: () => Navigator.of(context).maybePop(),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.mint,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: SafeArea(
                top: false,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: child,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Pengganti ilustrasi: ikon di lingkaran krem. Ganti dengan Image.asset jika punya gambarnya.
class Ilustrasi extends StatelessWidget {
  const Ilustrasi({super.key, required this.ikon, this.ukuran = 90});
  final IconData ikon;
  final double ukuran;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ukuran * 1.6,
      height: ukuran * 1.6,
      decoration: const BoxDecoration(
        color: Color(0xFFFBE9D0),
        shape: BoxShape.circle,
      ),
      child: Icon(ikon, size: ukuran, color: AppColors.oranye),
    );
  }
}

class AuthField extends StatefulWidget {
  const AuthField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.icon,
    this.isPassword = false,
    this.error,
    this.keyboardType,
    this.inputFormatters,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final IconData? icon;
  final bool isPassword;
  final String? error;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> {
  bool _sembunyi = true;

  OutlineInputBorder _border(Color c) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: BorderSide(color: c, width: 1.2),
  );

  @override
  Widget build(BuildContext context) {
    final adaError = widget.error != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        const SizedBox(height: 6),
        TextField(
          controller: widget.controller,
          obscureText: widget.isPassword && _sembunyi,
          keyboardType: widget.keyboardType,
          inputFormatters: widget.inputFormatters,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
            filled: true,
            fillColor: const Color(0xFFFAFAFA),
            prefixIcon: widget.icon == null ? null : Icon(widget.icon),
            suffixIcon: widget.isPassword
                ? IconButton(
              icon: Icon(_sembunyi
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined),
              onPressed: () => setState(() => _sembunyi = !_sembunyi),
            )
                : null,
            errorText: widget.error,
            enabledBorder: _border(adaError ? Colors.red : AppColors.hijau),
            focusedBorder: _border(adaError ? Colors.red : AppColors.hijauTua),
            errorBorder: _border(Colors.red),
            focusedErrorBorder: _border(Colors.red),
          ),
        ),
      ],
    );
  }
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.arrow = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final bool arrow;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.hijau,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(48),
        shape: const StadiumBorder(),
      ),
      onPressed: loading ? null : onPressed,
      child: loading
          ? const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
      )
          : Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          if (arrow) ...[
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward, size: 18),
          ],
        ],
      ),
    );
  }
}