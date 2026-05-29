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
    final auth = ref.watch(authProvider);

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
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(16),
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
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text("SMART PARKING SYSTEM"),
                  const SizedBox(height: 20),

                  /// NIM
                  TextField(
                    controller: nimController,
                    decoration: InputDecoration(
                      labelText: "NIM",
                      hintText: "Enter your NIM",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// Password
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Enter your password",
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
                        value: auth.rememberMe,
                        onChanged: (val) {
                          ref
                              .read(authProvider.notifier)
                              .toggleRememberMe(val ?? false);
                        },
                      ),
                      const Text("Remember me"),
                    ],
                  ),

                  /// Info
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline, size: 18),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Use your account from BMA to log in.",
                            style: TextStyle(fontSize: 12),
                          ),
                        )
                      ],
                    ),
                  ),

                  /// Button Login
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        ref.read(authProvider.notifier).login(
                          nimController.text,
                          passwordController.text,
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const DashboardPage()),
                        );
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(fontSize: 16),
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