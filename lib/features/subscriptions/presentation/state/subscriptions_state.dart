import '../../../../core/enums/subscription_plan.dart';
import '../../../../core/enums/subscription_status.dart';
import '../../data/models/shop_subscription.dart';
import '../../data/models/subscription_overview.dart';

enum SubscriptionsTab {
  overview,
  shopSubscriptions,
  plans,
  payments,
  reconciliation,
}

enum ExpiryFilter { any, next7Days, next30Days, expired }

class SubscriptionsState {
  const SubscriptionsState({
    this.overview,
    this.tab = SubscriptionsTab.overview,
    this.shopSubscriptions = const [],
    this.statusFilter = SubscriptionFilter.all,
    this.planFilter = PlanFilter.all,
    this.expiryFilter = ExpiryFilter.any,
    this.query = '',
  });

  static const List<SubscriptionStatus> _statusOrder = [
    SubscriptionStatus.expired,
    SubscriptionStatus.expiringSoon,
    SubscriptionStatus.active,
    SubscriptionStatus.unsubscribed,
  ];

  final SubscriptionOverview? overview;
  final SubscriptionsTab tab;
  final List<ShopSubscription> shopSubscriptions;
  final SubscriptionFilter statusFilter;
  final PlanFilter planFilter;
  final ExpiryFilter expiryFilter;
  final String query;

  int countFor(SubscriptionFilter filter) =>
      shopSubscriptions.where((item) => filter.matches(item.status)).length;

  List<ShopSubscription> get visibleSubscriptions {
    final String search = query.trim().toLowerCase();
    final DateTime now = overview?.updatedAt ?? DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final List<ShopSubscription> result = shopSubscriptions.where((item) {
      final DateTime? expiresAt = item.expiresAt;
      final bool matchesExpiry = switch (expiryFilter) {
        ExpiryFilter.any => true,
        ExpiryFilter.next7Days =>
          expiresAt != null &&
              !expiresAt.isBefore(today) &&
              expiresAt.isBefore(today.add(const Duration(days: 8))),
        ExpiryFilter.next30Days =>
          expiresAt != null &&
              !expiresAt.isBefore(today) &&
              expiresAt.isBefore(today.add(const Duration(days: 31))),
        ExpiryFilter.expired => expiresAt != null && expiresAt.isBefore(today),
      };
      return statusFilter.matches(item.status) &&
          planFilter.matches(item.plan) &&
          matchesExpiry &&
          (search.isEmpty ||
              item.shopName.toLowerCase().contains(search) ||
              item.shopId.toLowerCase().contains(search) ||
              item.ownerName.toLowerCase().contains(search));
    }).toList();
    result.sort((a, b) {
      final int byStatus = _statusOrder
          .indexOf(a.status)
          .compareTo(_statusOrder.indexOf(b.status));
      if (byStatus != 0) return byStatus;
      final DateTime? x = a.expiresAt;
      final DateTime? y = b.expiresAt;
      if (x != null && y != null && x != y) return x.compareTo(y);
      return a.shopId.compareTo(b.shopId);
    });
    return result;
  }

  SubscriptionsState copyWith({
    SubscriptionOverview? overview,
    SubscriptionsTab? tab,
    List<ShopSubscription>? shopSubscriptions,
    SubscriptionFilter? statusFilter,
    PlanFilter? planFilter,
    ExpiryFilter? expiryFilter,
    String? query,
  }) {
    return SubscriptionsState(
      overview: overview ?? this.overview,
      tab: tab ?? this.tab,
      shopSubscriptions: shopSubscriptions ?? this.shopSubscriptions,
      statusFilter: statusFilter ?? this.statusFilter,
      planFilter: planFilter ?? this.planFilter,
      expiryFilter: expiryFilter ?? this.expiryFilter,
      query: query ?? this.query,
    );
  }
}
