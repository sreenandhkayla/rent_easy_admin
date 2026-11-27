import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../data/models/admin_notification.dart';
import '../../data/repositories/notifications_repository.dart';
import 'create_notification_state.dart';

typedef NotificationSaveResult = ({String? savedTitle, String? error});

class CreateNotificationCubit extends Cubit<CreateNotificationState> {
  CreateNotificationCubit(this._repository, this.draftId)
    : super(const CreateNotificationState());

  final NotificationsRepository _repository;
  final String? draftId;

  Future<void> load() async {
    final String? id = draftId;
    if (id == null || id.isEmpty) {
      emit(
        CreateNotificationState(
          status: CreateNotificationStatus.ready,
          updatedAt: DateTime.now(),
        ),
      );
    } else {
      emit(const CreateNotificationState());
      final result = await _repository.fetch(id);
      if (isClosed) return;
      final bool loaded = result.match(
        (failure) {
          emit(
            CreateNotificationState(
              status: CreateNotificationStatus.failure,
              errorMessage: failure.message,
            ),
          );
          return false;
        },
        (notification) {
          if (notification == null) {
            emit(
              const CreateNotificationState(
                status: CreateNotificationStatus.notFound,
              ),
            );
            return false;
          }
          if (!notification.isDraft) {
            emit(
              const CreateNotificationState(
                status: CreateNotificationStatus.notEditable,
              ),
            );
            return false;
          }
          emit(
            CreateNotificationState(
              status: CreateNotificationStatus.ready,
              existingId: notification.id,
              type: notification.type,
              title: notification.title,
              message: notification.message,
              audience: notification.audience,
              updatedAt: DateTime.now(),
            ),
          );
          return true;
        },
      );
      if (!loaded) return;
    }
    await _loadReach();
  }

  Future<void> _loadReach() async {
    for (final NotificationAudience audience in NotificationAudience.values) {
      final result = await _repository.fetchReach(audience);
      if (isClosed) return;
      result.match(
        (_) {},
        (reach) =>
            emit(state.copyWith(reach: {...state.reach, audience: reach})),
      );
    }
  }

  void setType(NotificationType value) => emit(state.copyWith(type: value));

  void setTitle(String value) => emit(state.copyWith(title: value));

  void setMessage(String value) => emit(state.copyWith(message: value));

  void setAudience(NotificationAudience value) =>
      emit(state.copyWith(audience: value));

  bool validateForSend() {
    if (state.canSend) return true;
    emit(state.copyWith(showErrors: true));
    return false;
  }

  Future<NotificationSaveResult> saveDraft(NotificationAuthor author) async {
    if (!state.isTitleValid) {
      emit(state.copyWith(showDraftErrors: true));
      return (savedTitle: null, error: null);
    }
    return _save(
      () => _repository.saveDraft(
        state.draft,
        author: author,
        existingId: state.existingId,
      ),
    );
  }

  Future<NotificationSaveResult> send(NotificationAuthor author) async {
    if (!validateForSend()) return (savedTitle: null, error: null);
    return _save(
      () => _repository.queueSend(
        state.draft,
        author: author,
        existingId: state.existingId,
      ),
    );
  }

  Future<NotificationSaveResult> _save(
    Future<Either<Failure, String>> Function() action,
  ) async {
    if (state.isSaving) return (savedTitle: null, error: null);
    emit(state.copyWith(isSaving: true));
    final result = await action();
    if (isClosed) return (savedTitle: null, error: null);
    emit(state.copyWith(isSaving: false));
    return result.match(
      (failure) => (savedTitle: null, error: failure.message),
      (_) => (savedTitle: state.title.trim(), error: null),
    );
  }
}
