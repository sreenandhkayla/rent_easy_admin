import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/plan_definition.dart';
import '../../data/repositories/plans_repository.dart';
import 'plan_details_state.dart';

class PlanDetailsCubit extends Cubit<PlanDetailsState> {
  PlanDetailsCubit(this._repository, this.planId)
    : super(const PlanDetailsState());

  final PlansRepository _repository;
  final String? planId;

  Future<void> load() async {
    final String? id = planId;
    if (id == null || id.isEmpty) {
      emit(const PlanDetailsState(status: PlanDetailsStatus.notFound));
      return;
    }
    emit(
      state.copyWith(
        status: state.plan == null ? PlanDetailsStatus.loading : null,
        errorMessage: () => null,
      ),
    );
    final result = await _repository.fetchPlan(id);
    if (isClosed) return;
    result.match(
      (failure) => emit(
        state.copyWith(
          status: state.plan == null ? PlanDetailsStatus.failure : null,
          errorMessage: () => failure.message,
        ),
      ),
      (plan) => emit(
        PlanDetailsState(
          status: plan == null
              ? PlanDetailsStatus.notFound
              : PlanDetailsStatus.loaded,
          plan: plan,
          updatedAt: DateTime.now(),
          hasChanges: state.hasChanges,
        ),
      ),
    );
  }

  Future<void> reloadAfterEdit() {
    emit(state.copyWith(hasChanges: true));
    return load();
  }

  Future<String?> archive() async {
    final PlanDefinition? plan = state.plan;
    if (plan == null || plan.isArchived || state.isSaving) return null;
    emit(state.copyWith(isSaving: true));
    final result = await _repository.archivePlan(plan.id);
    if (isClosed) return null;
    return result.match(
      (failure) {
        emit(state.copyWith(isSaving: false));
        return failure.message;
      },
      (_) {
        emit(
          state.copyWith(
            isSaving: false,
            hasChanges: true,
            plan: plan.copyWith(
              status: PlanStatus.archived,
              updatedAt: DateTime.now(),
            ),
          ),
        );
        return null;
      },
    );
  }
}
