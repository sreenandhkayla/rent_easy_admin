import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../datasources/dashboard_remote_data_source.dart';
import '../models/dashboard_counts.dart';

class DashboardRepository {
  DashboardRepository(this._dataSource);

  static const Duration cacheDuration = Duration(minutes: 5);

  final DashboardRemoteDataSource _dataSource;

  DashboardCounts? _cached;

  Future<Either<Failure, DashboardCounts>> fetchCounts({
    bool refresh = false,
  }) async {
    final DashboardCounts? cached = _cached;
    if (!refresh &&
        cached != null &&
        DateTime.now().difference(cached.fetchedAt) < cacheDuration) {
      return right(cached);
    }
    final result = await _dataSource.fetchCounts();
    return result.map((counts) => _cached = counts);
  }
}
