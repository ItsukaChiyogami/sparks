import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/profile_viewmodel.dart';
import 'login_page.dart'; // sesuaikan import path jika berbeda

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileProvider);
    final user = state.user;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          /// Background parkiran
          _BackgroundImage(),

          /// Dark overlay
          Container(color: Colors.black.withOpacity(0.55)),

          /// Content
          SafeArea(
            child: state.isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.orange))
                : user == null
                    ? const Center(
                        child: Text('Gagal memuat profil.',
                            style: TextStyle(color: Colors.white70)))
                    : _buildContent(context, ref, user),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
          ),
        ),
      ),
      title: const Text(
        'Profil',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          const SizedBox(height: 20),

          /// Avatar
          _AvatarWidget(photoUrl: user.photoUrl),

          const SizedBox(height: 28),

          /// Info Card
          _ProfileCard(user: user),

          const Spacer(),

          /// Logout Button
          _LogoutButton(
            onTap: () async {
              await ref.read(profileProvider.notifier).logout();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => LoginPage()),
                  (route) => false,
                );
              }
            },
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

/// ─── Background ─────────────────────────────────────────────────────────────

class _BackgroundImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/parking_bg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

/// ─── Avatar ─────────────────────────────────────────────────────────────────

class _AvatarWidget extends StatelessWidget {
  final String? photoUrl;

  const _AvatarWidget({this.photoUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.orange, width: 3),
        color: Colors.grey.shade800,
      ),
      child: ClipOval(
        child: photoUrl != null
            ? Image.network(photoUrl!, fit: BoxFit.cover)
            : const Icon(Icons.person, color: Colors.white54, size: 60),
      ),
    );
  }
}

/// ─── Profile Card ────────────────────────────────────────────────────────────

class _ProfileCard extends StatelessWidget {
  final user;

  const _ProfileCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Full Name
          const Text(
            'Nama Panjang',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user.fullName,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 16),

          /// NIM + Vehicle Plate Row
          Row(
            children: [
              /// NIM
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'NIM',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.nim,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),

              Container(width: 1, height: 36, color: const Color(0xFFEEEEEE)),

              const SizedBox(width: 16),

              /// Vehicle Plate
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Nomor Plat Kendaraan',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.motorcycle,
                            size: 16, color: Colors.black54),
                        const SizedBox(width: 4),
                        Text(
                          user.vehiclePlate,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// ─── Logout Button ──────────────────────────────────────────────────────────

class _LogoutButton extends StatelessWidget {
  final VoidCallback onTap;

  const _LogoutButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.logout, color: Colors.white),
        label: const Text(
          'Logout',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade600,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}