import '../../../../core/enums/subscription_status.dart';
import 'shop.dart';
import 'shop_search.dart';

enum ShopStatusFilter {
  all,
  active,
  restricted;

  bool matches(ShopStatus status) => switch (this) {
    ShopStatusFilter.all => true,
    ShopStatusFilter.active => status == ShopStatus.active,
    ShopStatusFilter.restricted => status == ShopStatus.restricted,
  };
}

class ShopListQuery {
  const ShopListQuery({
    required this.today,
    this.planId,
    this.subscription = SubscriptionFilter.all,
    this.status = ShopStatusFilter.all,
    this.registeredSince,
    this.search,
    this.pageSize = 10,
  });

  final DateTime today;
  final String? planId;
  final SubscriptionFilter subscription;
  final ShopStatusFilter status;
  final DateTime? registeredSince;
  final ShopNameSearch? search;
  final int pageSize;

  DateTime get expiringSoonLimit => today.add(Shop.expiringSoonWindow);

  bool matches(Shop shop) {
    final DateTime? since = registeredSince;
    final DateTime? registeredAt = shop.registeredAt;
    final SubscriptionStatus? subscriptionStatus = shop.subscription;
    return (planId == null || shop.planId == planId) &&
        (subscription.status == null ||
            subscription.status == subscriptionStatus) &&
        status.matches(shop.status) &&
        (since == null ||
            (registeredAt != null && !registeredAt.isBefore(since)));
  }

  ShopListQuery get countKey => ShopListQuery(
    today: today,
    planId: planId,
    subscription: subscription,
    status: status,
    registeredSince: registeredSince,
    search: search,
  );

  @override
  bool operator ==(Object other) =>
      other is ShopListQuery &&
      other.today == today &&
      other.planId == planId &&
      other.subscription == subscription &&
      other.status == status &&
      other.registeredSince == registeredSince &&
      other.search == search &&
      other.pageSize == pageSize;

  @override
  int get hashCode => Object.hash(
    today,
    planId,
    subscription,
    status,
    registeredSince,
    search,
    pageSize,
  );
}
