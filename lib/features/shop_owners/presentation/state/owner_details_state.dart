import '../../data/models/owner_details.dart';

enum OwnerDetailsStatus { loading, loaded, notFound, failure }

class OwnerDetailsState {
  const OwnerDetailsState({
    this.status = OwnerDetailsStatus.loading,
    this.details,
    this.updatedAt,
    this.errorMessage,
    this.isSaving = false,
    this.hasChanges = false,
  });

  final OwnerDetailsStatus status;
  final OwnerDetails? details;
  final DateTime? updatedAt;
  final String? errorMessage;
  final bool isSaving;
  final bool hasChanges;

  OwnerDetailsState copyWith({
    OwnerDetailsStatus? status,
    OwnerDetails? details,
    DateTime? updatedAt,
    String? Function()? errorMessage,
    bool? isSaving,
    bool? hasChanges,
  }) {
    return OwnerDetailsState(
      status: status ?? this.status,
      details: details ?? this.details,
      updatedAt: updatedAt ?? this.updatedAt,
      errorMessage: errorMessage == null ? this.errorMessage : errorMessage(),
      isSaving: isSaving ?? this.isSaving,
      hasChanges: hasChanges ?? this.hasChanges,
    );
  }
}
