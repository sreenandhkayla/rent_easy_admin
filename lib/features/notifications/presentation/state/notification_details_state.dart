import '../../data/models/admin_notification.dart';

enum NotificationDetailsStatus { loading, loaded, notFound, failure }

class NotificationDetailsState {
  const NotificationDetailsState({
    this.status = NotificationDetailsStatus.loading,
    this.notification,
    this.errorMessage,
    this.updatedAt,
  });

  final NotificationDetailsStatus status;
  final AdminNotification? notification;
  final String? errorMessage;
  final DateTime? updatedAt;
}
