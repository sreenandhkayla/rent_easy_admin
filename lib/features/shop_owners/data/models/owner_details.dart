import '../../../../core/enums/subscription_status.dart';
import 'shop_owner.dart';

class LinkedShop {
  const LinkedShop({
    required this.name,
    required this.shopId,
    required this.location,
    required this.subscription,
    this.isBranch = false,
    this.plan,
    this.expiresAt,
  });

  final String name;
  final String shopId;
  final String location;
  final SubscriptionStatus subscription;
  final bool isBranch;
  final String? plan;
  final DateTime? expiresAt;
}

class OwnerActivity {
  const OwnerActivity({
    required this.title,
    required this.actor,
    required this.at,
    this.hasTime = true,
  });

  final String title;
  final String actor;
  final DateTime at;
  final bool hasTime;
}

class OwnerDetails {
  const OwnerDetails({
    required this.owner,
    required this.shops,
    required this.activities,
  });

  final ShopOwner owner;
  final List<LinkedShop> shops;
  final List<OwnerActivity> activities;

  int get unsubscribedOrExpired => owner.shops - owner.subscribedShops;
}
