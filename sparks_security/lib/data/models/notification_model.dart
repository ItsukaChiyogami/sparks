class NotificationModel {
  final String id;
  final String sender;
  final String title;
  final String body;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.sender,
    required this.title,
    required this.body,
    required this.createdAt,
  });

  String get timeAgo {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m yang lalu';
    if (diff.inHours < 24) return '${diff.inHours}j yang lalu';
    return '${diff.inDays}h yang lalu';
  }
}