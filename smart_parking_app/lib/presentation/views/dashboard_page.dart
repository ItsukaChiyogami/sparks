import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/dashboard_viewmodel.dart';
import 'notification_page.dart';
import 'profile_page.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboard = ref.watch(dashboardProvider);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Background parkiran ─────────────────────────────
          Image.asset(
            'assets/parking_bg.jpg',
            fit: BoxFit.cover,
          ),

          // ── Dark overlay ────────────────────────────────────
          Container(color: Colors.black.withOpacity(0.60)),

          // ── Content ─────────────────────────────────────────
          SafeArea(
            child: dashboard.isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.orange),
                  )
                : _DashboardBody(dashboard: dashboard),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BODY
// ─────────────────────────────────────────────────────────────────────────────

class _DashboardBody extends StatelessWidget {
  final DashboardState dashboard;
  const _DashboardBody({required this.dashboard});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),

          // ── Top Bar ─────────────────────────────────────────
          _TopBar(),

          const SizedBox(height: 24),

          // ── Parking Visual Card ──────────────────────────────
          _ParkingVisualCard(dashboard: dashboard),

          const SizedBox(height: 20),

          // ── Slot Info Card ───────────────────────────────────
          _SlotInfoCard(dashboard: dashboard),

          const Spacer(),

          // ── SPARKS Branding ──────────────────────────────────
          _SparksBranding(),

          const SizedBox(height: 28),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TOP BAR
// ─────────────────────────────────────────────────────────────────────────────

class _TopBar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        // Avatar
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProfilePage()),
          ),
          child: CircleAvatar(
            radius: 26,
            backgroundColor: Colors.grey.shade600,
            child: const Icon(Icons.person, color: Colors.white70, size: 30),
          ),
        ),

        const SizedBox(width: 12),

        // Greeting text
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hai, Alfian!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              Text(
                'ateng@ciputra.ac.id',
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),

        // Notification button with red badge
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NotificationPage()),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 13,
                  height: 13,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PARKING VISUAL CARD
// ─────────────────────────────────────────────────────────────────────────────

class _ParkingVisualCard extends StatelessWidget {
  final DashboardState dashboard;
  const _ParkingVisualCard({required this.dashboard});

  @override
  Widget build(BuildContext context) {
    final occupiedCount = dashboard.occupiedSlots.length;
    final remainingCm = dashboard.remainingWidthCm.toStringAsFixed(0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange, width: 2.5),
      ),
      child: SizedBox(
        height: 160,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Garis batas kiri slot parkir
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(width: 8),

            // Motor-motor yang terisi
            ...List.generate(occupiedCount, (i) {
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: SizedBox(
                  width: 64,
                  child: CustomPaint(
                    painter: _MotorcyclePainter(),
                  ),
                ),
              );
            }),

            // Sisa ruang (grey box dengan ukuran cm)
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    '$remainingCm cm',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 8),

            // Garis batas kanan slot parkir
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MOTORCYCLE PAINTER — tampak atas, mirip desain
// ─────────────────────────────────────────────────────────────────────────────

class _MotorcyclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF1A1A1A);
    final shadowPaint = Paint()..color = Colors.black26;
    final w = size.width;
    final h = size.height;

    // -- Bayangan --
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.18, h * 0.06, w * 0.64, h * 0.88),
        const Radius.circular(12),
      ),
      shadowPaint,
    );

    // -- Body utama motor (lonjong vertikal) --
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.2, h * 0.04, w * 0.60, h * 0.86),
        const Radius.circular(10),
      ),
      paint,
    );

    // -- Stang (horizontal bar atas) --
    final stangPaint = Paint()
      ..color = const Color(0xFF333333)
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(w * 0.05, h * 0.14),
      Offset(w * 0.95, h * 0.14),
      stangPaint,
    );

    // -- Spion kiri --
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, h * 0.10, w * 0.12, h * 0.08),
        const Radius.circular(3),
      ),
      Paint()..color = const Color(0xFF222222),
    );

    // -- Spion kanan --
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.88, h * 0.10, w * 0.12, h * 0.08),
        const Radius.circular(3),
      ),
      Paint()..color = const Color(0xFF222222),
    );

    // -- Lampu depan (putih kecil) --
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.32, h * 0.04, w * 0.36, h * 0.06),
        const Radius.circular(4),
      ),
      Paint()..color = Colors.white54,
    );

    // -- Tangki / body tengah (highlight) --
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.28, h * 0.30, w * 0.44, h * 0.24),
        const Radius.circular(8),
      ),
      Paint()..color = const Color(0xFF2A2A2A),
    );

    // -- Roda depan --
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.25, h * 0.04, w * 0.50, h * 0.13),
        const Radius.circular(6),
      ),
      Paint()..color = const Color(0xFF111111),
    );

    // -- Roda belakang --
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.25, h * 0.83, w * 0.50, h * 0.13),
        const Radius.circular(6),
      ),
      Paint()..color = const Color(0xFF111111),
    );

    // -- Lampu belakang (merah kecil) --
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.30, h * 0.90, w * 0.40, h * 0.05),
        const Radius.circular(3),
      ),
      Paint()..color = Colors.red.shade700,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// SLOT INFO CARD
// ─────────────────────────────────────────────────────────────────────────────

class _SlotInfoCard extends StatelessWidget {
  final DashboardState dashboard;
  const _SlotInfoCard({required this.dashboard});

  @override
  Widget build(BuildContext context) {
    final remaining = dashboard.estimatedRemainingSlots;
    final remainingCm = dashboard.remainingWidthCm.toStringAsFixed(0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label orange
          const Text(
            'Perkiraan Slot Tersisa',
            style: TextStyle(
              color: Colors.orange,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),

          const SizedBox(height: 10),

          // Ikon + jumlah slot besar
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.drive_eta_outlined,
                size: 30,
                color: Colors.black87,
              ),
              const SizedBox(width: 10),
              Text(
                '$remaining Slot',
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  height: 1.0,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Keterangan ukuran
          Text(
            'Dengan ukuran $remainingCm cm',
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black38,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SPARKS BRANDING
// ─────────────────────────────────────────────────────────────────────────────

class _SparksBranding extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/Logo.jpg',
      height: 48,
      fit: BoxFit.contain,
      // Karena background gelap, pakai ColorFiltered agar logo tetap terlihat
      // Hapus ColorFiltered jika logo sudah punya background transparan (.png)
    );
  }
}