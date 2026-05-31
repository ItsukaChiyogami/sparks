import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/notification_model.dart';

class NotificationState {
  final List<NotificationModel> notifications;
  final bool isLoading;

  NotificationState({this.notifications = const [], this.isLoading = false});

  NotificationState copyWith(
      {List<NotificationModel>? notifications, bool? isLoading}) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  Map<String, List<NotificationModel>> get grouped {
    final Map<String, List<NotificationModel>> result = {};
    for (final notif in notifications) {
      final diff = DateTime.now().difference(notif.createdAt).inDays;
      String label = diff == 0 ? 'Hari ini' : diff == 1 ? 'Kemarin' : '$diff hari lalu';
      result.putIfAbsent(label, () => []).add(notif);
    }
    return result;
  }
}

class NotificationViewModel extends StateNotifier<NotificationState> {
  NotificationViewModel() : super(NotificationState()) {
    _load();
  }

  void _load() {
    final now = DateTime.now();
    state = state.copyWith(notifications: [
      NotificationModel(
        id: '1',
        sender: 'PESAN DARI SISTEM',
        title: 'Motor di Area A perlu dirapikan',
        body: 'Terdeteksi 2 motor parkir tidak rapi di Area A. Harap segera ditindak.',
        createdAt: now.subtract(const Duration(minutes: 5)),
      ),
      NotificationModel(
        id: '2',
        sender: 'PESAN DARI SISTEM',
        title: 'Kapasitas parkir hampir penuh',
        body: 'Slot parkir Zone A tersisa 1. Aktifkan protokol pengalihan.',
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
    ]);
  }
}

final notificationProvider =
    StateNotifierProvider<NotificationViewModel, NotificationState>((ref) {
  return NotificationViewModel();
});