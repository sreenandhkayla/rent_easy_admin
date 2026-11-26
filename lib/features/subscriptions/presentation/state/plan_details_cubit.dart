import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/plan_definition.dart';
import '../../data/subscriptions_mock_data.dart';
import 'plan_details_state.dart';

class PlanDetailsCubit extends Cubit<PlanDetailsState> {
  PlanDetailsCubit(this.planId) : super(const PlanDetailsState());

  final String? planId;

  void load() {
    final String? id = planId;
    final PlanDefinition? plan = id == null
        ? null
        : SubscriptionsMockData.plan(id);
    emit(
      PlanDetailsState(
        status: plan == null
            ? PlanDetailsStatus.notFound
            : PlanDetailsStatus.loaded,
        plan: plan,
        updatedAt: DateTime.now(),
      ),
    );
  }

  void archive() {
    final PlanDefinition? plan = state.plan;
    if (plan == null || plan.isArchived) return;
    SubscriptionsMockData.archivePlan(plan.id, DateTime.now());
    load();
  }
}
