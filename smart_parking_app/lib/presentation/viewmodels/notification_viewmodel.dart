import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/notification_model.dart';

class NotificationState {
  final List<NotificationModel> notifications;
  final bool isLoading;

  NotificationState({
    this.notifications = const [],
    this.isLoading = false,
  });

  NotificationState copyWith({
    List<NotificationModel>? notifications,
    bool? isLoading,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  /// Kelompokkan notifikasi berdasarkan tanggal
  Map<String, List<NotificationModel>> get grouped {
    final Map<String, List<NotificationModel>> result = {};
    for (final notif in notifications) {
      final now = DateTime.now();
      final diff = now.difference(notif.createdAt).inDays;
      String label;
      if (diff == 0) {
        label = 'Hari ini';
      } else if (diff == 1) {
        label = 'Kemarin';
      } else {
        label = '$diff hari lalu';
      }
      result.putIfAbsent(label, () => []).add(notif);
    }
    return result;
  }
}

class NotificationViewModel extends StateNotifier<NotificationState> {
  NotificationViewModel() : super(NotificationState()) {
    _loadNotifications();
  }

  void _loadNotifications() {
    // Dummy data — ganti dengan API call nanti
    final now = DateTime.now();
    state = state.copyWith(
      notifications: [
        NotificationModel(
          id: '1',
          sender: 'PESAN DARI SEKURITI',
          title: 'Motor anda dirapihkan di sekitar Area A',
          body: 'Dipindahkan oleh Security Joko karena penataan area parkir darurat.',
          createdAt: now.subtract(const Duration(minutes: 2)),
        ),
        NotificationModel(
          id: '2',
          sender: 'PESAN DARI SISTEM',
          title: 'Slot parkir A-012 akan segera habis',
          body: 'Hanya tersisa 3 slot di Zone A. Segera pindahkan kendaraan Anda.',
          createdAt: now.subtract(const Duration(hours: 1)),
        ),
      ],
    );
  }
}

final notificationProvider =
    StateNotifierProvider<NotificationViewModel, NotificationState>((ref) {
  return NotificationViewModel();
});