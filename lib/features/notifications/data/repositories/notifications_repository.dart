import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../datasources/notifications_remote_data_source.dart';
import '../models/admin_notification.dart';

typedef NotificationCounts = Map<NotificationStatus?, int>;

class NotificationsRepository {
  NotificationsRepository(this._dataSource);

  static const Duration reachCacheDuration = Duration(minutes: 5);
  static const List<NotificationStatus?> countedStatuses = [
    null,
    NotificationStatus.sent,
    NotificationStatus.draft,
    NotificationStatus.failed,
  ];

  final NotificationsRemoteDataSource _dataSource;

  final Map<NotificationAudience, ({AudienceReach reach, DateTime at})> _reach =
      {};

  Future<Either<Failure, List<AdminNotification>>> fetchList(
    NotificationStatus? status,
  ) => _dataSource.fetchList(status);

  Future<Either<Failure, NotificationCounts>> fetchCounts() async {
    final results = await Future.wait([
      for (final NotificationStatus? status in countedStatuses)
        _dataSource.count(status),
    ]);
    for (final result in results) {
      if (result case Left(:final value)) return left(value);
    }
    return right({
      for (int i = 0; i < countedStatuses.length; i++)
        countedStatuses[i]: results[i].getOrElse((_) => 0),
    });
  }

  Future<Either<Failure, AdminNotification?>> fetch(String id) =>
      _dataSource.fetch(id);

  Future<Either<Failure, AudienceReach>> fetchReach(
    NotificationAudience audience,
  ) async {
    final cached = _reach[audience];
    if (cached != null &&
        DateTime.now().difference(cached.at) < reachCacheDuration) {
      return right(cached.reach);
    }
    final result = await _dataSource.fetchReach(audience);
    return result.map((reach) {
      _reach[audience] = (reach: reach, at: DateTime.now());
      return reach;
    });
  }

  Future<Either<Failure, String>> saveDraft(
    NotificationDraft draft, {
    required NotificationAuthor author,
    String? existingId,
  }) => _dataSource.save(
    draft,
    author: author,
    queue: false,
    existingId: existingId,
  );

  Future<Either<Failure, String>> queueSend(
    NotificationDraft draft, {
    required NotificationAuthor author,
    String? existingId,
  }) => _dataSource.save(
    draft,
    author: author,
    queue: true,
    existingId: existingId,
  );
}
