import '../../../../core/resources/strings/notifications_strings.dart';
import '../../data/models/admin_notification.dart';

enum NotificationFilter {
  all(NotificationsStrings.filterAll, null),
  sent(NotificationsStrings.filterSent, NotificationStatus.sent),
  scheduled(NotificationsStrings.filterScheduled, NotificationStatus.scheduled),
  drafts(NotificationsStrings.filterDrafts, NotificationStatus.draft);

  const NotificationFilter(this.label, this.status);

  final String label;
  final NotificationStatus? status;

  bool matches(NotificationStatus value) => status == null || status == value;
}

class NotificationsState {
  const NotificationsState({
    this.isLoading = false,
    this.notifications = const [],
    this.filter = NotificationFilter.all,
    this.updatedAt,
  });

  final bool isLoading;
  final List<AdminNotification> notifications;
  final NotificationFilter filter;
  final DateTime? updatedAt;

  int countFor(NotificationFilter value) =>
      notifications.where((item) => value.matches(item.status)).length;

  List<AdminNotification> get visibleNotifications =>
      notifications.where((item) => filter.matches(item.status)).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  NotificationsState copyWith({
    bool? isLoading,
    List<AdminNotification>? notifications,
    NotificationFilter? filter,
    DateTime? updatedAt,
  }) {
    return NotificationsState(
      isLoading: isLoading ?? this.isLoading,
      notifications: notifications ?? this.notifications,
      filter: filter ?? this.filter,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
