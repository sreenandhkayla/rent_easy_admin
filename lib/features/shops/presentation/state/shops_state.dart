import 'dart:math' as math;

import '../../../../core/enums/registration_date_filter.dart';
import '../../../../core/enums/subscription_status.dart';
import '../../data/models/shop.dart';

enum SubscriptionFilter { all, active, expiringSoon, expired, unsubscribed }

enum PlanFilter { all, basic, professional, premium }

enum ShopStatusFilter { all, active, restricted }

enum ShopSortField { name, expiry }

class ShopsState {
  const ShopsState({
    this.isLoading = true,
    this.shops = const [],
    this.totalOnPlatform = 0,
    this.updatedAt,
    this.query = '',
    this.subscriptionFilter = SubscriptionFilter.all,
    this.planFilter = PlanFilter.all,
    this.statusFilter = ShopStatusFilter.all,
    this.dateFilter = RegistrationDateFilter.any,
    this.sortField = ShopSortField.name,
    this.isAscending = true,
    this.page = 1,
  });

  static const int pageSize = 8;

  final bool isLoading;
  final List<Shop> shops;
  final int totalOnPlatform;
  final DateTime? updatedAt;
  final String query;
  final SubscriptionFilter subscriptionFilter;
  final PlanFilter planFilter;
  final ShopStatusFilter statusFilter;
  final RegistrationDateFilter dateFilter;
  final ShopSortField sortField;
  final bool isAscending;
  final int page;

  List<Shop> get filteredShops {
    final String search = query.trim().toLowerCase();
    final DateTime? since = dateFilter.since(updatedAt ?? DateTime.now());
    final List<Shop> result = shops.where((shop) {
      final bool matchesSearch =
          search.isEmpty ||
          shop.name.toLowerCase().contains(search) ||
          shop.shopId.toLowerCase().contains(search) ||
          shop.ownerName.toLowerCase().contains(search);
      final bool matchesSubscription = switch (subscriptionFilter) {
        SubscriptionFilter.all => true,
        SubscriptionFilter.active =>
          shop.subscription == SubscriptionStatus.active,
        SubscriptionFilter.expiringSoon =>
          shop.subscription == SubscriptionStatus.expiringSoon,
        SubscriptionFilter.expired =>
          shop.subscription == SubscriptionStatus.expired,
        SubscriptionFilter.unsubscribed =>
          shop.subscription == SubscriptionStatus.unsubscribed,
      };
      final bool matchesPlan = switch (planFilter) {
        PlanFilter.all => true,
        PlanFilter.basic => shop.plan == ShopPlan.basic,
        PlanFilter.professional => shop.plan == ShopPlan.professional,
        PlanFilter.premium => shop.plan == ShopPlan.premium,
      };
      final bool matchesStatus = switch (statusFilter) {
        ShopStatusFilter.all => true,
        ShopStatusFilter.active => shop.status == ShopStatus.active,
        ShopStatusFilter.restricted => shop.status == ShopStatus.restricted,
      };
      final bool matchesDate =
          since == null || !shop.registeredAt.isBefore(since);
      return matchesSearch &&
          matchesSubscription &&
          matchesPlan &&
          matchesStatus &&
          matchesDate;
    }).toList();
    result.sort(_compare);
    return result;
  }

  int _compare(Shop a, Shop b) {
    if (sortField == ShopSortField.expiry) {
      final DateTime? x = a.expiresAt;
      final DateTime? y = b.expiresAt;
      if (x == null && y == null) return _byName(a, b);
      if (x == null) return 1;
      if (y == null) return -1;
      final int order = x.compareTo(y);
      return isAscending ? order : -order;
    }
    final int order = _byName(a, b);
    return isAscending ? order : -order;
  }

  int _byName(Shop a, Shop b) =>
      a.name.toLowerCase().compareTo(b.name.toLowerCase());

  int get pageCount => math.max(1, (filteredShops.length / pageSize).ceil());

  List<Shop> get pageShops {
    final List<Shop> all = filteredShops;
    final int start = (page - 1) * pageSize;
    if (start >= all.length) return const [];
    return all.sublist(start, math.min(start + pageSize, all.length));
  }

  ShopsState copyWith({
    bool? isLoading,
    List<Shop>? shops,
    int? totalOnPlatform,
    DateTime? updatedAt,
    String? query,
    SubscriptionFilter? subscriptionFilter,
    PlanFilter? planFilter,
    ShopStatusFilter? statusFilter,
    RegistrationDateFilter? dateFilter,
    ShopSortField? sortField,
    bool? isAscending,
    int? page,
  }) {
    return ShopsState(
      isLoading: isLoading ?? this.isLoading,
      shops: shops ?? this.shops,
      totalOnPlatform: totalOnPlatform ?? this.totalOnPlatform,
      updatedAt: updatedAt ?? this.updatedAt,
      query: query ?? this.query,
      subscriptionFilter: subscriptionFilter ?? this.subscriptionFilter,
      planFilter: planFilter ?? this.planFilter,
      statusFilter: statusFilter ?? this.statusFilter,
      dateFilter: dateFilter ?? this.dateFilter,
      sortField: sortField ?? this.sortField,
      isAscending: isAscending ?? this.isAscending,
      page: page ?? this.page,
    );
  }
}
