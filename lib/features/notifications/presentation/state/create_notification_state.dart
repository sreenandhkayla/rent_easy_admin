import '../../data/models/admin_notification.dart';

enum CreateNotificationStatus { loading, ready, notFound, notEditable, failure }

class CreateNotificationState {
  const CreateNotificationState({
    this.status = CreateNotificationStatus.loading,
    this.existingId,
    this.type = NotificationType.featureAnnouncement,
    this.title = '',
    this.message = '',
    this.audience = NotificationAudience.allOwners,
    this.reach = const {},
    this.isSaving = false,
    this.showErrors = false,
    this.showDraftErrors = false,
    this.errorMessage,
    this.updatedAt,
  });

  final CreateNotificationStatus status;
  final String? existingId;
  final NotificationType type;
  final String title;
  final String message;
  final NotificationAudience audience;
  final Map<NotificationAudience, AudienceReach> reach;
  final bool isSaving;
  final bool showErrors;
  final bool showDraftErrors;
  final String? errorMessage;
  final DateTime? updatedAt;

  bool get isEditing => existingId != null;

  bool get isTitleValid => title.trim().isNotEmpty;

  bool get isMessageValid => message.trim().isNotEmpty;

  bool get canSend => isTitleValid && isMessageValid;

  bool get showTitleError => (showErrors || showDraftErrors) && !isTitleValid;

  bool get showMessageError => showErrors && !isMessageValid;

  AudienceReach? reachOf(NotificationAudience value) => reach[value];

  NotificationDraft get draft => NotificationDraft(
    title: title,
    message: message,
    type: type,
    audience: audience,
  );

  CreateNotificationState copyWith({
    CreateNotificationStatus? status,
    String? existingId,
    NotificationType? type,
    String? title,
    String? message,
    NotificationAudience? audience,
    Map<NotificationAudience, AudienceReach>? reach,
    bool? isSaving,
    bool? showErrors,
    bool? showDraftErrors,
    String? Function()? errorMessage,
    DateTime? updatedAt,
  }) {
    return CreateNotificationState(
      status: status ?? this.status,
      existingId: existingId ?? this.existingId,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      audience: audience ?? this.audience,
      reach: reach ?? this.reach,
      isSaving: isSaving ?? this.isSaving,
      showErrors: showErrors ?? this.showErrors,
      showDraftErrors: showDraftErrors ?? this.showDraftErrors,
      errorMessage: errorMessage == null ? this.errorMessage : errorMessage(),
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
