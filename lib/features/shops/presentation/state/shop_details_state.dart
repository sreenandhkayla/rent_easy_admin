import '../../data/models/shop_details.dart';

enum ShopDetailsStatus { loading, loaded, notFound }

class ShopDetailsState {
  const ShopDetailsState({
    this.status = ShopDetailsStatus.loading,
    this.details,
    this.updatedAt,
  });

  final ShopDetailsStatus status;
  final ShopDetails? details;
  final DateTime? updatedAt;
}
