import '../../../../core/resources/strings/notifications_strings.dart';
import '../../data/models/admin_notification.dart';

enum NotificationFilter {
  all(NotificationsStrings.filterAll, null),
  sent(NotificationsStrings.filterSent, NotificationStatus.sent),
  drafts(NotificationsStrings.filterDrafts, NotificationStatus.draft),
  failed(NotificationsStrings.filterFailed, NotificationStatus.failed);

  const NotificationFilter(this.label, this.status);

  final String label;
  final NotificationStatus? status;
}

class NotificationsState {
  const NotificationsState({
    this.isLoading = false,
    this.notifications = const [],
    this.counts = const {},
    this.filter = NotificationFilter.all,
    this.errorMessage,
    this.updatedAt,
  });

  final bool isLoading;
  final List<AdminNotification> notifications;
  final Map<NotificationStatus?, int> counts;
  final NotificationFilter filter;
  final String? errorMessage;
  final DateTime? updatedAt;

  bool get hasLoaded => updatedAt != null;

  int countFor(NotificationFilter value) => counts[value.status] ?? 0;

  NotificationsState copyWith({
    bool? isLoading,
    List<AdminNotification>? notifications,
    Map<NotificationStatus?, int>? counts,
    NotificationFilter? filter,
    String? Function()? errorMessage,
    DateTime? updatedAt,
  }) {
    return NotificationsState(
      isLoading: isLoading ?? this.isLoading,
      notifications: notifications ?? this.notifications,
      counts: counts ?? this.counts,
      filter: filter ?? this.filter,
      errorMessage: errorMessage == null ? this.errorMessage : errorMessage(),
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
