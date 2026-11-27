import 'shop.dart';

class ShopActivity {
  const ShopActivity({
    required this.title,
    required this.actor,
    required this.at,
    this.hasTime = true,
    this.reason,
    this.isHighlighted = false,
  });

  final String title;
  final String actor;
  final DateTime at;
  final bool hasTime;
  final String? reason;
  final bool isHighlighted;
}

class ShopDetails {
  const ShopDetails({
    required this.shop,
    required this.relatedBranches,
    required this.activities,
  });

  final Shop shop;
  final List<Shop> relatedBranches;
  final List<ShopActivity> activities;

  static List<Shop> relatedTo(Shop shop, List<Shop> ownerShops) {
    final String rootId = shop.parentShopId ?? shop.shopId;
    return [
      for (final Shop other in ownerShops)
        if (other.shopId != shop.shopId &&
            (other.shopId == rootId || other.parentShopId == rootId))
          other,
    ];
  }

  ShopDetails copyWith({Shop? shop}) => ShopDetails(
    shop: shop ?? this.shop,
    relatedBranches: relatedBranches,
    activities: activities,
  );
}
