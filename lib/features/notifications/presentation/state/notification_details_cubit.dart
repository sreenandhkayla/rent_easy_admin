import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/notifications_repository.dart';
import 'notification_details_state.dart';

class NotificationDetailsCubit extends Cubit<NotificationDetailsState> {
  NotificationDetailsCubit(this._repository, this.notificationId)
    : super(const NotificationDetailsState());

  final NotificationsRepository _repository;
  final String? notificationId;

  Future<void> load() async {
    final String? id = notificationId;
    if (id == null || id.isEmpty) {
      emit(
        const NotificationDetailsState(
          status: NotificationDetailsStatus.notFound,
        ),
      );
      return;
    }
    if (state.notification == null) emit(const NotificationDetailsState());
    final result = await _repository.fetch(id);
    if (isClosed) return;
    result.match(
      (failure) => emit(
        NotificationDetailsState(
          status: state.notification == null
              ? NotificationDetailsStatus.failure
              : NotificationDetailsStatus.loaded,
          notification: state.notification,
          errorMessage: failure.message,
          updatedAt: state.updatedAt,
        ),
      ),
      (notification) => emit(
        NotificationDetailsState(
          status: notification == null
              ? NotificationDetailsStatus.notFound
              : NotificationDetailsStatus.loaded,
          notification: notification,
          updatedAt: DateTime.now(),
        ),
      ),
    );
  }
}
