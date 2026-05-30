import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentation/views/login_page.dart';
import 'presentation/views/security/security_login_page.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SPARKS - Smart Parking System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),
      // kIsWeb = true  → buka di browser    → Login Security (web)
      // kIsWeb = false → buka di HP/emulator → Login User (mobile)
      home: kIsWeb ? const SecurityLoginPage() : LoginPage(),
    );
  }
}