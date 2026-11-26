import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/plan_definition.dart';
import '../../data/subscriptions_mock_data.dart';
import 'create_plan_state.dart';

class CreatePlanCubit extends Cubit<CreatePlanState> {
  CreatePlanCubit() : super(CreatePlanState(updatedAt: DateTime.now()));

  void refresh() => emit(state.copyWith(updatedAt: DateTime.now()));

  void setName(String value) => emit(state.copyWith(name: value));

  void setStatus(PlanStatus value) => emit(state.copyWith(status: value));

  void setDescription(String value) => emit(state.copyWith(description: value));

  void setPrice(String value) => emit(state.copyWith(price: value));

  void setBillingPeriod(PlanBillingPeriod value) =>
      emit(state.copyWith(billingPeriod: value));

  void setBenefits(String value) => emit(state.copyWith(benefits: value));

  void setLimit(String value) => emit(state.copyWith(limit: value));

  PlanDefinition? save() {
    if (state.isSaving) return null;
    if (!state.isValid) {
      emit(state.copyWith(showErrors: true));
      return null;
    }
    emit(state.copyWith(isSaving: true));
    final DateTime now = DateTime.now();
    final PlanDefinition plan = state.toPlan(
      'plan-${now.microsecondsSinceEpoch}',
      now,
    );
    SubscriptionsMockData.addPlan(plan);
    return plan;
  }
}
