import '../../data/models/shop_details.dart';

enum ShopDetailsStatus { loading, loaded, notFound, failure }

class ShopDetailsState {
  const ShopDetailsState({
    this.status = ShopDetailsStatus.loading,
    this.details,
    this.updatedAt,
    this.errorMessage,
    this.isSaving = false,
    this.hasChanges = false,
  });

  final ShopDetailsStatus status;
  final ShopDetails? details;
  final DateTime? updatedAt;
  final String? errorMessage;
  final bool isSaving;
  final bool hasChanges;

  ShopDetailsState copyWith({
    ShopDetailsStatus? status,
    ShopDetails? details,
    DateTime? updatedAt,
    String? Function()? errorMessage,
    bool? isSaving,
    bool? hasChanges,
  }) {
    return ShopDetailsState(
      status: status ?? this.status,
      details: details ?? this.details,
      updatedAt: updatedAt ?? this.updatedAt,
      errorMessage: errorMessage == null ? this.errorMessage : errorMessage(),
      isSaving: isSaving ?? this.isSaving,
      hasChanges: hasChanges ?? this.hasChanges,
    );
  }
}
