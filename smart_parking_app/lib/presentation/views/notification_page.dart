import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/notification_viewmodel.dart';
import '../../data/models/notification_model.dart';

class NotificationPage extends ConsumerWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notificationProvider);

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
                ? const Center(child: CircularProgressIndicator(color: Colors.orange))
                : _buildContent(state),
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
        'Notifikasi',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }

  Widget _buildContent(NotificationState state) {
    final grouped = state.grouped;

    if (grouped.isEmpty) {
      return const Center(
        child: Text(
          'Tidak ada notifikasi.',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      children: grouped.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Label tanggal
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  Text(
                    entry.key,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Divider(color: Colors.white24, thickness: 1)),
                ],
              ),
            ),

            /// Notification Cards
            ...entry.value.map((notif) => _NotificationCard(notif: notif)),
          ],
        );
      }).toList(),
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

/// ─── Notification Card ──────────────────────────────────────────────────────

class _NotificationCard extends StatelessWidget {
  final NotificationModel notif;

  const _NotificationCard({required this.notif});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Sender + Time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                notif.sender,
                style: const TextStyle(
                  color: Colors.orange,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                notif.timeAgo,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 11,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          /// Title
          Text(
            notif.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 6),

          /// Body
          Text(
            notif.body,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}