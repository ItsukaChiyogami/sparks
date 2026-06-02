import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../views/dashboard_page.dart';

class LoginPage extends ConsumerWidget {
  LoginPage({super.key});

  final nimController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 🟢 Memantau state autentikasi global (loading, error, user)
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: Stack(
        children: [
          /// Background
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/parking_bg.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// Form
          Center(
            child: Container(
              width: 400, // Membatasi lebar box agar tetap rapi di platform web
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// Logo
                  const Text(
                    "SPARKS",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                      color: Color(0xFF0F1F35),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "SMART PARKING SYSTEM",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 24),

                  /// NIM Input Field
                  TextField(
                    controller: nimController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "NIM",
                      hintText: "Enter your NIM",
                      prefixIcon: const Icon(Icons.badge_outlined, size: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// Password Input Field
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Enter your password",
                      prefixIcon: const Icon(Icons.lock_outline, size: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// Remember me
                  Row(
                    children: [
                      Checkbox(
                        value: authState.rememberMe,
                        onChanged: (val) {
                          ref
                              .read(authProvider.notifier)
                              .toggleRememberMe(val ?? false);
                        },
                      ),
                      const Text("Remember me"),
                    ],
                  ),

                  const SizedBox(height: 8),

                  /// Info Box
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline, size: 18, color: Colors.blue),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Use your account from BMA to log in.",
                            style: TextStyle(fontSize: 12, color: Colors.black87),
                          ),
                        )
                      ],
                    ),
                  ),

                  /// 🟢 Error Message (Akan muncul jika gagal login dari Spring Boot)
                  if (authState.error != null) ...[
                    Text(
                      authState.error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  /// Button Login
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      // Matikan tombol jika proses login sedang berjalan (isLoading)
                      onPressed: authState.isLoading
                          ? null
                          : () async {
                              // Memanggil fungsi login ke backend dan menunggu hasilnya
                              final loginSukses = await ref
                                  .read(authProvider.notifier)
                                  .login(
                                    nimController.text,
                                    passwordController.text,
                                  );

                              // Pindah halaman hanya jika backend mengembalikan HTTP 200 (True)
                              if (loginSukses && context.mounted) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const DashboardPage(),
                                  ),
                                );
                              }
                            },
                      child: authState.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}