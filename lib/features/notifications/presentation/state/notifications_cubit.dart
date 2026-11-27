import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/notifications_repository.dart';
import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit(this._repository) : super(const NotificationsState());

  final NotificationsRepository _repository;

  Future<void> load() => _fetch(state.filter, withCounts: true);

  Future<void> filterBy(NotificationFilter filter) =>
      _fetch(filter, withCounts: false);

  Future<void> _fetch(
    NotificationFilter filter, {
    required bool withCounts,
  }) async {
    emit(
      state.copyWith(filter: filter, isLoading: true, errorMessage: () => null),
    );
    final listFuture = _repository.fetchList(filter.status);
    final countsFuture = withCounts ? _repository.fetchCounts() : null;
    final listResult = await listFuture;
    final countsResult = await countsFuture;
    if (isClosed || state.filter != filter) return;
    listResult.match(
      (failure) => emit(
        state.copyWith(isLoading: false, errorMessage: () => failure.message),
      ),
      (list) => emit(
        state.copyWith(
          isLoading: false,
          notifications: list,
          counts: countsResult?.getOrElse((_) => state.counts),
          updatedAt: DateTime.now(),
        ),
      ),
    );
  }
}
