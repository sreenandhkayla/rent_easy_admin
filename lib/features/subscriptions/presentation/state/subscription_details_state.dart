import '../../data/models/shop_subscription.dart';

enum SubscriptionDetailsStatus { loading, loaded, notFound }

class SubscriptionDetailsState {
  const SubscriptionDetailsState({
    this.status = SubscriptionDetailsStatus.loading,
    this.details,
    this.updatedAt,
  });

  final SubscriptionDetailsStatus status;
  final SubscriptionDetails? details;
  final DateTime? updatedAt;
}
