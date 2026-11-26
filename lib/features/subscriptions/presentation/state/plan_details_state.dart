import '../../data/models/plan_definition.dart';

enum PlanDetailsStatus { loading, loaded, notFound }

class PlanDetailsState {
  const PlanDetailsState({
    this.status = PlanDetailsStatus.loading,
    this.plan,
    this.updatedAt,
  });

  final PlanDetailsStatus status;
  final PlanDefinition? plan;
  final DateTime? updatedAt;
}
