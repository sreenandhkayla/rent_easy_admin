enum OwnerStatus { active, restricted }

class ShopOwner {
  const ShopOwner({
    required this.name,
    required this.mobile,
    required this.ownerId,
    required this.registeredAt,
    required this.shops,
    required this.subscribedShops,
    required this.status,
  });

  final String name;
  final String mobile;
  final String ownerId;
  final DateTime registeredAt;
  final int shops;
  final int subscribedShops;
  final OwnerStatus status;

  ShopOwner copyWith({OwnerStatus? status}) => ShopOwner(
    name: name,
    mobile: mobile,
    ownerId: ownerId,
    registeredAt: registeredAt,
    shops: shops,
    subscribedShops: subscribedShops,
    status: status ?? this.status,
  );
}
