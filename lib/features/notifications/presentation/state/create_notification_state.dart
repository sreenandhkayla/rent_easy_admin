import '../../data/models/admin_notification.dart';

enum NotificationDelivery { sendNow, schedule }

class CreateNotificationState {
  const CreateNotificationState({
    required this.updatedAt,
    this.type = NotificationType.featureAnnouncement,
    this.title = '',
    this.message = '',
    this.audience = NotificationAudience.allOwners,
    this.delivery = NotificationDelivery.sendNow,
    this.scheduledAt,
    this.showErrors = false,
    this.showDraftErrors = false,
  });

  static const List<NotificationAudience> audiences = [
    NotificationAudience.allOwners,
    NotificationAudience.allRegisteredShops,
    NotificationAudience.subscribedShops,
    NotificationAudience.expiredSubscriptionShops,
    NotificationAudience.selectedShops,
  ];

  final DateTime updatedAt;
  final NotificationType type;
  final String title;
  final String message;
  final NotificationAudience audience;
  final NotificationDelivery delivery;
  final DateTime? scheduledAt;
  final bool showErrors;
  final bool showDraftErrors;

  bool get isTitleValid => title.trim().isNotEmpty;

  bool get isMessageValid => message.trim().isNotEmpty;

  bool get isAudienceValid => audience != NotificationAudience.selectedShops;

  bool isScheduleValid(DateTime now) =>
      delivery == NotificationDelivery.sendNow ||
      (scheduledAt?.isAfter(now) ?? false);

  bool canSend(DateTime now) =>
      isTitleValid && isMessageValid && isAudienceValid && isScheduleValid(now);

  bool get showTitleError => (showErrors || showDraftErrors) && !isTitleValid;

  bool get showMessageError => showErrors && !isMessageValid;

  bool get showAudienceError => showErrors && !isAudienceValid;

  bool showScheduleError(DateTime now) => showErrors && !isScheduleValid(now);

  CreateNotificationState copyWith({
    DateTime? updatedAt,
    NotificationType? type,
    String? title,
    String? message,
    NotificationAudience? audience,
    NotificationDelivery? delivery,
    DateTime? scheduledAt,
    bool? showErrors,
    bool? showDraftErrors,
  }) {
    return CreateNotificationState(
      updatedAt: updatedAt ?? this.updatedAt,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      audience: audience ?? this.audience,
      delivery: delivery ?? this.delivery,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      showErrors: showErrors ?? this.showErrors,
      showDraftErrors: showDraftErrors ?? this.showDraftErrors,
    );
  }
}
