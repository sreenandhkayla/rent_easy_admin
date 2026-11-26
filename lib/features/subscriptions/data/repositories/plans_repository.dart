import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../datasources/plans_remote_data_source.dart';
import '../models/plan_definition.dart';

class PlansRepository {
  const PlansRepository(this._dataSource);

  final PlansRemoteDataSource _dataSource;

  Future<Either<Failure, List<PlanDefinition>>> fetchPlans() =>
      _dataSource.fetchPlans();

  Future<Either<Failure, PlanDefinition?>> fetchPlan(String id) =>
      _dataSource.fetchPlan(id);

  Future<Either<Failure, PlanDefinition>> createPlan(
    PlanDefinition plan,
  ) async {
    final result = await _dataSource.createPlan(plan);
    final DateTime now = DateTime.now();
    return result.map(
      (id) => plan.copyWith(id: id, createdAt: now, updatedAt: now),
    );
  }

  Future<Either<Failure, PlanDefinition>> updatePlan(
    PlanDefinition plan, {
    required PlanStatus previousStatus,
  }) async {
    final result = await _dataSource.updatePlan(
      plan,
      previousStatus: previousStatus,
    );
    return result.map((_) => plan.copyWith(updatedAt: DateTime.now()));
  }

  Future<Either<Failure, Unit>> archivePlan(String id) =>
      _dataSource.archivePlan(id);
}
