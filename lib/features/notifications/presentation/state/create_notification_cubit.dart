import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/admin_notification.dart';
import '../../data/notifications_mock_data.dart';
import 'create_notification_state.dart';

class CreateNotificationCubit extends Cubit<CreateNotificationState> {
  factory CreateNotificationCubit({String? draftId}) {
    final AdminNotification? found = draftId == null
        ? null
        : NotificationsMockData.notification(draftId);
    return CreateNotificationCubit._(
      found?.status == NotificationStatus.draft ? found : null,
    );
  }

  CreateNotificationCubit._(this.draft) : super(_initial(draft));

  final AdminNotification? draft;

  bool get isEditing => draft != null;

  static CreateNotificationState _initial(AdminNotification? draft) {
    final CreateNotificationState blank = CreateNotificationState(
      updatedAt: DateTime.now(),
    );
    if (draft == null) return blank;
    return blank.copyWith(
      type: draft.type,
      title: draft.title,
      message: draft.message,
      audience: draft.audience,
    );
  }

  void refresh() => emit(state.copyWith(updatedAt: DateTime.now()));

  void setType(NotificationType value) => emit(state.copyWith(type: value));

  void setTitle(String value) => emit(state.copyWith(title: value));

  void setMessage(String value) => emit(state.copyWith(message: value));

  void setAudience(NotificationAudience value) =>
      emit(state.copyWith(audience: value));

  void setDelivery(NotificationDelivery value) =>
      emit(state.copyWith(delivery: value));

  void setScheduledAt(DateTime value) =>
      emit(state.copyWith(scheduledAt: value));

  AudienceReach get reach => reachFor(state.audience);

  AudienceReach reachFor(NotificationAudience audience) =>
      NotificationsMockData.reachOf(audience);

  bool validateForSend() {
    if (state.canSend(DateTime.now())) return true;
    emit(state.copyWith(showErrors: true));
    return false;
  }

  AdminNotification? saveDraft({required String actor}) {
    if (!state.isTitleValid) {
      emit(state.copyWith(showDraftErrors: true));
      return null;
    }
    return _store(NotificationStatus.draft, actor: actor);
  }

  AdminNotification? send({required String actor}) {
    if (!validateForSend()) return null;
    return _store(
      state.delivery == NotificationDelivery.schedule
          ? NotificationStatus.scheduled
          : NotificationStatus.sent,
      actor: actor,
    );
  }

  AdminNotification _store(NotificationStatus status, {required String actor}) {
    final DateTime now = DateTime.now();
    final int? owners = reach.owners;
    final AdminNotification? existing = draft;
    final AdminNotification notification = AdminNotification(
      notificationId:
          existing?.notificationId ?? NotificationsMockData.nextId(),
      title: state.title.trim(),
      message: state.message.trim(),
      createdBy: existing?.createdBy ?? actor,
      type: state.type,
      audience: state.audience,
      status: status,
      createdAt: existing?.createdAt ?? now,
      sendAt: switch (status) {
        NotificationStatus.sent => now,
        NotificationStatus.scheduled => state.scheduledAt,
        NotificationStatus.draft => null,
      },
      delivered: status == NotificationStatus.sent ? owners : null,
      recipients: owners,
    );
    if (existing == null) {
      NotificationsMockData.add(notification);
    } else {
      NotificationsMockData.replace(notification);
    }
    return notification;
  }
}
