import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:rent_easy_admin/core/errors/failure.dart';
import 'package:rent_easy_admin/features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:rent_easy_admin/features/dashboard/data/models/dashboard_counts.dart';
import 'package:rent_easy_admin/features/dashboard/data/repositories/dashboard_repository.dart';

class _FakeSource implements DashboardRemoteDataSource {
  _FakeSource({this.age = Duration.zero});

  final Duration age;
  int calls = 0;

  @override
  Future<Either<Failure, DashboardCounts>> fetchCounts() async {
    calls++;
    return right(
      DashboardCounts(
        totalShops: 10 + calls,
        totalShopOwners: 5 + calls,
        fetchedAt: DateTime.now().subtract(age),
      ),
    );
  }
}

void main() {
  test('a repeat visit uses the cache and makes no reads', () async {
    final _FakeSource source = _FakeSource();
    final DashboardRepository repository = DashboardRepository(source);
    await repository.fetchCounts();
    final second = await repository.fetchCounts();
    expect(source.calls, 1);
    expect(second.getOrElse((_) => throw StateError('failed')).totalShops, 11);
  });

  test('refresh always reads fresh counts', () async {
    final _FakeSource source = _FakeSource();
    final DashboardRepository repository = DashboardRepository(source);
    await repository.fetchCounts();
    final refreshed = await repository.fetchCounts(refresh: true);
    expect(source.calls, 2);
    expect(
      refreshed.getOrElse((_) => throw StateError('failed')).totalShops,
      12,
    );
  });

  test('counts older than the cache window are read again', () async {
    final _FakeSource source = _FakeSource(
      age: DashboardRepository.cacheDuration + const Duration(seconds: 1),
    );
    final DashboardRepository repository = DashboardRepository(source);
    await repository.fetchCounts();
    await repository.fetchCounts();
    expect(source.calls, 2);
  });
}
