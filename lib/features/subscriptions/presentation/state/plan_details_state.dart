import '../../data/models/plan_definition.dart';

enum PlanDetailsStatus { loading, loaded, notFound, failure }

class PlanDetailsState {
  const PlanDetailsState({
    this.status = PlanDetailsStatus.loading,
    this.plan,
    this.updatedAt,
    this.errorMessage,
    this.isSaving = false,
    this.hasChanges = false,
  });

  final PlanDetailsStatus status;
  final PlanDefinition? plan;
  final DateTime? updatedAt;
  final String? errorMessage;
  final bool isSaving;
  final bool hasChanges;

  PlanDetailsState copyWith({
    PlanDetailsStatus? status,
    PlanDefinition? plan,
    DateTime? updatedAt,
    String? Function()? errorMessage,
    bool? isSaving,
    bool? hasChanges,
  }) {
    return PlanDetailsState(
      status: status ?? this.status,
      plan: plan ?? this.plan,
      updatedAt: updatedAt ?? this.updatedAt,
      errorMessage: errorMessage == null ? this.errorMessage : errorMessage(),
      isSaving: isSaving ?? this.isSaving,
      hasChanges: hasChanges ?? this.hasChanges,
    );
  }
}
