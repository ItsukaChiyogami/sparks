import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/security_auth_viewmodel.dart';
import 'security_shell_page.dart';

class SecurityLoginPage extends ConsumerStatefulWidget {
  const SecurityLoginPage({super.key});

  @override
  ConsumerState<SecurityLoginPage> createState() => _SecurityLoginPageState();
}

class _SecurityLoginPageState extends ConsumerState<SecurityLoginPage> {
  final _nipController = TextEditingController();
  final _passController = TextEditingController();
  bool _obscure = true;

  static const _navy = Color(0xFF0F1F35);
  static const _navyLight = Color(0xFF162840);

  @override
  void dispose() {
    _nipController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(securityAuthProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ── Logo ──────────────────────────────────────────
              Image.asset('assets/Logo.jpg', height: 80),

              const SizedBox(height: 40),

              // ── Login Card ────────────────────────────────────
              Container(
                width: 380,
                decoration: BoxDecoration(
                  color: _navy,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.fromLTRB(28, 26, 28, 0),
                      child: Row(
                        children: [
                          Icon(Icons.shield_outlined,
                              color: Colors.white60, size: 18),
                          const SizedBox(width: 8),
                          const Text(
                            'Login Security',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Divider(color: Colors.white12, height: 24),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(28, 0, 28, 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // NIP Label
                          const Text(
                            'NIP (NOMOR INDUK PEGAWAI)',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // NIP Field
                          _WebTextField(
                            controller: _nipController,
                            hint: 'Enter 18-digit ID',
                            icon: Icons.badge_outlined,
                            keyboardType: TextInputType.number,
                          ),

                          const SizedBox(height: 20),

                          // Password Label
                          const Text(
                            'PASSWORD',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Password Field
                          _WebTextField(
                            controller: _passController,
                            hint: '••••••••••••',
                            icon: Icons.lock_outline,
                            obscure: _obscure,
                            suffix: IconButton(
                              icon: Icon(
                                _obscure
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: Colors.white38,
                                size: 18,
                              ),
                              onPressed: () =>
                                  setState(() => _obscure = !_obscure),
                            ),
                          ),

                          if (auth.error != null) ...[
                            const SizedBox(height: 10),
                            Text(
                              auth.error!,
                              style: const TextStyle(
                                color: Colors.redAccent,
                                fontSize: 12,
                              ),
                            ),
                          ],

                          const SizedBox(height: 20),

                          // Masuk Button
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFCBD5E0),
                                foregroundColor: _navy,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: auth.isLoading
                                  ? null
                                  : () async {
                                      final ok = await ref
                                          .read(securityAuthProvider.notifier)
                                          .login(
                                            _nipController.text,
                                            _passController.text,
                                          );
                                      if (ok && context.mounted) {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const SecurityShellPage(),
                                          ),
                                        );
                                      }
                                    },
                              child: auth.isLoading
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Color(0xFF0F1F35),
                                      ),
                                    )
                                  : const Text(
                                      'MASUK',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ── Disclaimer ────────────────────────────────────
              const Text(
                'Akses tanpa izin ke terminal ini\ndilarang keras dan dipantau oleh\nProtokol Keamanan Kampus.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF8A9BB0),
                  fontSize: 12.5,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// REUSABLE WEB TEXT FIELD
// ─────────────────────────────────────────────────────────────────────────────

class _WebTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscure;
  final Widget? suffix;
  final TextInputType? keyboardType;

  const _WebTextField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.suffix,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white70, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white24, fontSize: 14),
        prefixIcon: Icon(icon, color: Colors.white38, size: 18),
        suffixIcon: suffix,
        filled: true,
        fillColor: const Color(0xFF1A2F4A),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF243B55), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF4A90A4), width: 1.5),
        ),
      ),
    );
  }
}