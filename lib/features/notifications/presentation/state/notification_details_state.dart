import '../../data/models/admin_notification.dart';

enum NotificationDetailsStatus { loading, loaded, notFound }

class NotificationDetailsState {
  const NotificationDetailsState({
    this.status = NotificationDetailsStatus.loading,
    this.notification,
    this.updatedAt,
  });

  final NotificationDetailsStatus status;
  final AdminNotification? notification;
  final DateTime? updatedAt;
}
