import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/admin_notification.dart';
import '../../data/notifications_mock_data.dart';
import 'notification_details_state.dart';

class NotificationDetailsCubit extends Cubit<NotificationDetailsState> {
  NotificationDetailsCubit(this.notificationId)
    : super(const NotificationDetailsState());

  final String? notificationId;

  void load() {
    final String? id = notificationId;
    final AdminNotification? notification = id == null
        ? null
        : NotificationsMockData.notification(id);
    emit(
      NotificationDetailsState(
        status: notification == null
            ? NotificationDetailsStatus.notFound
            : NotificationDetailsStatus.loaded,
        notification: notification,
        updatedAt: DateTime.now(),
      ),
    );
  }

  void cancelScheduledSend() {
    final String? id = state.notification?.notificationId;
    if (id == null) return;
    NotificationsMockData.cancelScheduled(id);
    load();
  }
}
