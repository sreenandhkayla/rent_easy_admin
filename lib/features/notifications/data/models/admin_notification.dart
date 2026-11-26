import '../../../../core/resources/strings/notifications_strings.dart';

enum NotificationStatus {
  sent(NotificationsStrings.statusSent),
  scheduled(NotificationsStrings.statusScheduled),
  draft(NotificationsStrings.statusDraft);

  const NotificationStatus(this.label);

  final String label;
}

enum NotificationType {
  importantInformation(NotificationsStrings.typeImportant),
  maintenance(NotificationsStrings.typeMaintenance),
  subscriptionExpiringSoon(NotificationsStrings.typeExpiringSoon),
  featureAnnouncement(NotificationsStrings.typeFeature),
  appUpdate(NotificationsStrings.typeAppUpdate),
  subscriptionExpired(NotificationsStrings.typeExpired);

  const NotificationType(this.label);

  final String label;
}

enum NotificationAudience {
  subscribedShops(NotificationsStrings.audienceSubscribedShops),
  allOwners(NotificationsStrings.audienceAllOwners),
  expiringSoon(NotificationsStrings.audienceExpiringSoon),
  allRegisteredShops(NotificationsStrings.audienceAllShops),
  expiredSubscriptionShops(NotificationsStrings.audienceExpiredShops),
  selectedShops(NotificationsStrings.audienceSelectedShops);

  const NotificationAudience(this.label);

  final String label;
}

class DeliveryFailure {
  const DeliveryFailure({
    required this.shopName,
    required this.reason,
    required this.at,
  });

  final String shopName;
  final String reason;
  final DateTime at;
}

class AdminNotification {
  const AdminNotification({
    required this.notificationId,
    required this.title,
    required this.message,
    required this.createdBy,
    required this.type,
    required this.audience,
    required this.status,
    required this.createdAt,
    this.sendAt,
    this.delivered,
    this.recipients,
    this.failures = const [],
  });

  final String notificationId;
  final String title;
  final String message;
  final String createdBy;
  final NotificationType type;
  final NotificationAudience audience;
  final NotificationStatus status;
  final DateTime createdAt;
  final DateTime? sendAt;
  final int? delivered;
  final int? recipients;
  final List<DeliveryFailure> failures;

  AdminNotification toDraft() => AdminNotification(
    notificationId: notificationId,
    title: title,
    message: message,
    createdBy: createdBy,
    type: type,
    audience: audience,
    status: NotificationStatus.draft,
    createdAt: createdAt,
    recipients: recipients,
  );

  int? get failed {
    final int? sent = delivered;
    final int? total = recipients;
    if (sent == null || total == null) return null;
    return total - sent;
  }

  double? get deliveredShare {
    final int? sent = delivered;
    final int? total = recipients;
    if (sent == null || total == null || total == 0) return null;
    return sent / total;
  }
}

class AudienceReach {
  const AudienceReach({this.shops, this.owners});

  final int? shops;
  final int? owners;
}
