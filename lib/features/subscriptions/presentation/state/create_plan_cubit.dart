import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/plan_definition.dart';
import '../../data/repositories/plans_repository.dart';
import 'create_plan_state.dart';

class CreatePlanCubit extends Cubit<CreatePlanState> {
  CreatePlanCubit(this._repository, {this.planId})
    : super(
        CreatePlanState(
          updatedAt: DateTime.now(),
          formStatus: planId == null
              ? PlanFormStatus.ready
              : PlanFormStatus.loading,
        ),
      );

  final PlansRepository _repository;
  final String? planId;

  Future<void> load() async {
    final String? id = planId;
    if (id == null) return;
    if (id.isEmpty) {
      emit(state.copyWith(formStatus: PlanFormStatus.notFound));
      return;
    }
    emit(
      state.copyWith(
        formStatus: PlanFormStatus.loading,
        errorMessage: () => null,
      ),
    );
    final result = await _repository.fetchPlan(id);
    if (isClosed) return;
    result.match(
      (failure) => emit(
        state.copyWith(
          formStatus: PlanFormStatus.failure,
          errorMessage: () => failure.message,
        ),
      ),
      (plan) => emit(
        plan == null
            ? state.copyWith(formStatus: PlanFormStatus.notFound)
            : CreatePlanState.fromPlan(plan),
      ),
    );
  }

  void refresh() {
    if (planId != null) {
      load();
      return;
    }
    emit(state.copyWith(updatedAt: DateTime.now()));
  }

  void _edit(CreatePlanState Function(CreatePlanState state) change) =>
      emit(change(state).copyWith(errorMessage: () => null));

  void setName(String value) => _edit((s) => s.copyWith(name: value));

  void setStatus(PlanStatus value) => _edit((s) => s.copyWith(status: value));

  void setDescription(String value) =>
      _edit((s) => s.copyWith(description: value));

  void setPrice(String value) => _edit((s) => s.copyWith(price: value));

  void setBillingPeriod(PlanBillingPeriod value) =>
      _edit((s) => s.copyWith(billingPeriod: value));

  void setBenefits(String value) => _edit((s) => s.copyWith(benefits: value));

  void setLimit(String value) => _edit((s) => s.copyWith(limit: value));

  void setOfferTag(String value) => _edit((s) => s.copyWith(offerTag: value));

  void setOfferPercentage(String value) =>
      _edit((s) => s.copyWith(offerPercentage: value));

  Future<PlanDefinition?> save() async {
    if (state.isSaving || state.formStatus != PlanFormStatus.ready) {
      return null;
    }
    if (!state.isValid) {
      emit(state.copyWith(showErrors: true));
      return null;
    }
    emit(state.copyWith(isSaving: true, errorMessage: () => null));
    final PlanDefinition plan = state.toPlan();
    final PlanStatus? previousStatus = state.originalStatus;
    final result = previousStatus == null
        ? await _repository.createPlan(plan)
        : await _repository.updatePlan(plan, previousStatus: previousStatus);
    if (isClosed) return null;
    return result.match(
      (failure) {
        emit(
          state.copyWith(isSaving: false, errorMessage: () => failure.message),
        );
        return null;
      },
      (saved) {
        emit(state.copyWith(isSaving: false));
        return saved;
      },
    );
  }
}
