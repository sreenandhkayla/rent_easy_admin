import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/resources/strings/notifications_strings.dart';

enum NotificationStatus {
  draft(NotificationsStrings.statusDraft),
  queued(NotificationsStrings.statusQueued),
  sending(NotificationsStrings.statusSending),
  sent(NotificationsStrings.statusSent),
  failed(NotificationsStrings.statusFailed);

  const NotificationStatus(this.label);

  final String label;

  bool get isInProgress => this == queued || this == sending;

  static NotificationStatus fromKey(Object? key) =>
      values.asNameMap()[key] ?? draft;
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

  static NotificationType fromKey(Object? key) =>
      values.asNameMap()[key] ?? importantInformation;
}

enum NotificationAudience {
  allOwners(NotificationsStrings.audienceAllOwners),
  subscribedShops(NotificationsStrings.audienceSubscribedShops),
  expiredSubscriptionShops(NotificationsStrings.audienceExpiredShops);

  const NotificationAudience(this.label);

  final String label;

  bool get isShopBased => this != allOwners;

  static NotificationAudience fromKey(Object? key) =>
      values.asNameMap()[key] ?? allOwners;
}

class FailureReasonCount {
  const FailureReasonCount({required this.reason, required this.count});

  final String reason;
  final int count;
}

class AdminNotification {
  const AdminNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.audience,
    required this.status,
    this.createdAt,
    this.updatedAt,
    this.createdByName = '',
    this.createdByEmail = '',
    this.queuedAt,
    this.sentAt,
    this.recipients,
    this.devices,
    this.ownersWithoutDevices,
    this.delivered,
    this.failed,
    this.failureReasons = const [],
    this.errorMessage,
  });

  factory AdminNotification.fromDocument(String id, Map<String, dynamic> data) {
    final Object? reasons = data[failureReasonsField];
    return AdminNotification(
      id: id,
      title: _text(data[titleField]),
      message: _text(data[messageField]),
      type: NotificationType.fromKey(data[typeField]),
      audience: NotificationAudience.fromKey(data[audienceField]),
      status: NotificationStatus.fromKey(data[statusField]),
      createdAt: _date(data[createdAtField]),
      updatedAt: _date(data[updatedAtField]),
      createdByName: _text(data[createdByNameField]),
      createdByEmail: _text(data[createdByEmailField]),
      queuedAt: _date(data[queuedAtField]),
      sentAt: _date(data[sentAtField]),
      recipients: _int(data[recipientsField]),
      devices: _int(data[devicesField]),
      ownersWithoutDevices: _int(data[ownersWithoutDevicesField]),
      delivered: _int(data[deliveredField]),
      failed: _int(data[failedField]),
      failureReasons: [
        if (reasons is Map)
          for (final MapEntry<Object?, Object?> entry in reasons.entries)
            if (entry.key is String && _int(entry.value) != null)
              FailureReasonCount(
                reason: entry.key! as String,
                count: _int(entry.value)!,
              ),
      ]..sort((a, b) => b.count.compareTo(a.count)),
      errorMessage: switch (_text(data[errorField])) {
        '' => null,
        final String error => error,
      },
    );
  }

  static const String collection = 'notifications';
  static const String titleField = 'title';
  static const String messageField = 'message';
  static const String typeField = 'type';
  static const String audienceField = 'audience';
  static const String statusField = 'status';
  static const String createdAtField = 'createdAt';
  static const String updatedAtField = 'updatedAt';
  static const String createdByUidField = 'createdByUid';
  static const String createdByNameField = 'createdByName';
  static const String createdByEmailField = 'createdByEmail';
  static const String queuedAtField = 'queuedAt';
  static const String queuedByUidField = 'queuedByUid';
  static const String sentAtField = 'sentAt';
  static const String recipientsField = 'recipients';
  static const String devicesField = 'devices';
  static const String ownersWithoutDevicesField = 'ownersWithoutDevices';
  static const String deliveredField = 'delivered';
  static const String failedField = 'failed';
  static const String failureReasonsField = 'failureReasons';
  static const String errorField = 'error';

  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final NotificationAudience audience;
  final NotificationStatus status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String createdByName;
  final String createdByEmail;
  final DateTime? queuedAt;
  final DateTime? sentAt;
  final int? recipients;
  final int? devices;
  final int? ownersWithoutDevices;
  final int? delivered;
  final int? failed;
  final List<FailureReasonCount> failureReasons;
  final String? errorMessage;

  bool get isDraft => status == NotificationStatus.draft;

  double? get deliveredShare {
    final int? sent = delivered;
    if (sent == null) return null;
    final int total = sent + (failed ?? 0);
    if (total == 0) return null;
    return sent / total;
  }

  static String _text(Object? value) => value is String ? value.trim() : '';

  static int? _int(Object? value) => value is num ? value.toInt() : null;

  static DateTime? _date(Object? value) =>
      value is Timestamp ? value.toDate() : null;
}

class AudienceReach {
  const AudienceReach({this.shops, this.owners});

  final int? shops;
  final int? owners;
}

class NotificationDraft {
  const NotificationDraft({
    required this.title,
    required this.message,
    required this.type,
    required this.audience,
  });

  final String title;
  final String message;
  final NotificationType type;
  final NotificationAudience audience;

  Map<String, Object?> toFields() => {
    AdminNotification.titleField: title.trim(),
    AdminNotification.messageField: message.trim(),
    AdminNotification.typeField: type.name,
    AdminNotification.audienceField: audience.name,
  };
}

class NotificationAuthor {
  const NotificationAuthor({required this.name, required this.email});

  final String name;
  final String email;
}
