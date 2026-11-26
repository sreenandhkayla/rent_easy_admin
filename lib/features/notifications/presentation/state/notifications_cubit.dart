import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/notifications_mock_data.dart';
import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(const NotificationsState());

  static const Duration _mockLatency = Duration(milliseconds: 700);

  Future<void> load() async {
    emit(state.copyWith(isLoading: true));
    await Future<void>.delayed(_mockLatency);
    if (isClosed) return;
    emit(
      state.copyWith(
        isLoading: false,
        notifications: NotificationsMockData.notifications(),
        updatedAt: DateTime.now(),
      ),
    );
  }

  void syncNotifications() => emit(
    state.copyWith(notifications: NotificationsMockData.notifications()),
  );

  void filterBy(NotificationFilter filter) =>
      emit(state.copyWith(filter: filter));
}
