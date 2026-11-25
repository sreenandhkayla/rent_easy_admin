import '../../data/models/owner_details.dart';

enum OwnerDetailsStatus { loading, loaded, notFound }

class OwnerDetailsState {
  const OwnerDetailsState({
    this.status = OwnerDetailsStatus.loading,
    this.details,
    this.updatedAt,
  });

  final OwnerDetailsStatus status;
  final OwnerDetails? details;
  final DateTime? updatedAt;
}
