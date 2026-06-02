import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/security_auth_viewmodel.dart'; // Pastikan path import ini sesuai struktur foldermu
import 'security_login_page.dart';
import 'live_cam_page.dart';
import 'security_notification_page.dart';

// Provider untuk track halaman aktif
final activeSecurityPageProvider = StateProvider<String>((ref) => 'livecam');

class SecurityShellPage extends ConsumerWidget {
  const SecurityShellPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activePage = ref.watch(activeSecurityPageProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: Row(
        children: [
          // ── Sidebar ───────────────────────────────────────────
          _Sidebar(activePage: activePage),

          // ── Main Content ──────────────────────────────────────
          Expanded(
            child: activePage == 'livecam'
                ? const LiveCamPage()
                : const SecurityNotificationPage(),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SIDEBAR
// ─────────────────────────────────────────────────────────────────────────────

class _Sidebar extends ConsumerWidget {
  final String activePage;
  const _Sidebar({required this.activePage});

  static const _navy = Color(0xFF0F1F35);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 🟢 Ambil state auth global untuk mendapatkan profil user yang login
    final authState = ref.watch(securityAuthProvider);

    return Container(
      width: 260,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
            child: Image.asset('assets/Logo.jpg', height: 44),
          ),

          // Menu label
          const Padding(
            padding: EdgeInsets.fromLTRB(24, 0, 24, 16),
            child: Text(
              'Menu',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),

          // Menu items
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                _SidebarItem(
                  icon: Icons.remove_red_eye_outlined,
                  label: 'Live Cam',
                  isActive: activePage == 'livecam',
                  onTap: () => ref
                      .read(activeSecurityPageProvider.notifier)
                      .state = 'livecam',
                ),
                const SizedBox(height: 8),
                _SidebarItem(
                  icon: Icons.notifications_outlined,
                  label: 'Notifikasi',
                  isActive: activePage == 'notifikasi',
                  onTap: () => ref
                      .read(activeSecurityPageProvider.notifier)
                      .state = 'notifikasi',
                ),
              ],
            ),
          ),

          const Spacer(),

          // User card + Keluar
          Container(
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _navy,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                // User info
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.grey.shade600,
                        child: const Icon(Icons.person,
                            color: Colors.white70, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              authState.fullName ?? 'No Name', // 🟢 Dinamis sesuai database
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              authState.nip ?? '000000000000', // 🟢 Dinamis sesuai database
                              style: const TextStyle(
                                color: Colors.white38,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Keluar button
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SecurityLoginPage(),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const BoxDecoration(
                      color: Color(0xFF8B1A1A),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout, color: Colors.white, size: 16),
                        SizedBox(width: 8),
                        Text(
                          'Keluar',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SIDEBAR ITEM
// ─────────────────────────────────────────────────────────────────────────────

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  static const _navy = Color(0xFF0F1F35);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isActive ? _navy : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isActive ? Colors.white : Colors.black54,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}