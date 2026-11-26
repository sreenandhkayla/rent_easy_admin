import 'dart:math' as math;

import '../../../../core/enums/registration_date_filter.dart';
import '../../../../core/enums/subscription_status.dart';
import '../../../subscriptions/data/models/plan_definition.dart';
import '../../data/models/shop.dart';
import '../../data/models/shop_list_query.dart';
import '../../data/models/shop_search.dart';

export '../../data/models/shop_list_query.dart' show ShopStatusFilter;

enum ShopSortField { name, expiry }

class ShopsState {
  const ShopsState({
    this.isLoading = true,
    this.hasLoaded = false,
    this.errorMessage,
    this.rows = const [],
    this.searchMatches = const [],
    this.serverTotal = 0,
    this.totalOnPlatform = 0,
    this.plans = const [],
    this.updatedAt,
    this.query = '',
    this.activeSearch = '',
    this.subscriptionFilter = SubscriptionFilter.all,
    this.planId,
    this.statusFilter = ShopStatusFilter.all,
    this.dateFilter = RegistrationDateFilter.any,
    this.sortField,
    this.isAscending = true,
    this.page = 1,
    this.pageSize = defaultPageSize,
  });

  static const int defaultPageSize = 10;
  static const List<int> pageSizes = [10, 25, 50];

  final bool isLoading;
  final bool hasLoaded;
  final String? errorMessage;
  final List<Shop> rows;
  final List<Shop> searchMatches;
  final int serverTotal;
  final int totalOnPlatform;
  final List<PlanDefinition> plans;
  final DateTime? updatedAt;
  final String query;
  final String activeSearch;
  final SubscriptionFilter subscriptionFilter;
  final String? planId;
  final ShopStatusFilter statusFilter;
  final RegistrationDateFilter dateFilter;
  final ShopSortField? sortField;
  final bool isAscending;
  final int page;
  final int pageSize;

  bool get isSearching => ShopSearch.isActive(activeSearch);

  bool get hasFilters =>
      isSearching ||
      planId != null ||
      subscriptionFilter != SubscriptionFilter.all ||
      statusFilter != ShopStatusFilter.all ||
      dateFilter != RegistrationDateFilter.any;

  PlanDefinition? get selectedPlan {
    for (final PlanDefinition plan in plans) {
      if (plan.id == planId) return plan;
    }
    return null;
  }

  ShopListQuery get listQuery {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    return ShopListQuery(
      today: today,
      planId: planId,
      subscription: subscriptionFilter,
      status: statusFilter,
      registeredSince: dateFilter.since(today),
      search: ShopSearch.nameFor(activeSearch),
      pageSize: pageSize,
    );
  }

  List<Shop> get _extraSearchMatches {
    final Set<String> listed = {for (final shop in rows) shop.shopId};
    return [
      for (final shop in searchMatches)
        if (!listed.contains(shop.shopId)) shop,
    ];
  }

  int get totalCount =>
      serverTotal + (isSearching ? _extraSearchMatches.length : 0);

  int get pageCount => math.max(1, (serverTotal / pageSize).ceil());

  int get firstRowNumber {
    if (totalCount == 0) return 0;
    if (page == 1) return 1;
    return (page - 1) * pageSize + _extraSearchMatches.length + 1;
  }

  List<Shop> get visibleRows {
    final List<Shop> ordered = sortField == null ? rows : _sorted(rows);
    if (!isSearching || page != 1) return ordered;
    return [..._extraSearchMatches, ...ordered];
  }

  List<Shop> _sorted(List<Shop> shops) {
    final List<Shop> result = List.of(shops);
    result.sort((a, b) {
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
    });
    return result;
  }

  static int _byName(Shop a, Shop b) =>
      a.name.toLowerCase().compareTo(b.name.toLowerCase());

  ShopsState copyWith({
    bool? isLoading,
    bool? hasLoaded,
    String? Function()? errorMessage,
    List<Shop>? rows,
    List<Shop>? searchMatches,
    int? serverTotal,
    int? totalOnPlatform,
    List<PlanDefinition>? plans,
    DateTime? updatedAt,
    String? query,
    String? activeSearch,
    SubscriptionFilter? subscriptionFilter,
    String? Function()? planId,
    ShopStatusFilter? statusFilter,
    RegistrationDateFilter? dateFilter,
    ShopSortField? Function()? sortField,
    bool? isAscending,
    int? page,
    int? pageSize,
  }) {
    return ShopsState(
      isLoading: isLoading ?? this.isLoading,
      hasLoaded: hasLoaded ?? this.hasLoaded,
      errorMessage: errorMessage == null ? this.errorMessage : errorMessage(),
      rows: rows ?? this.rows,
      searchMatches: searchMatches ?? this.searchMatches,
      serverTotal: serverTotal ?? this.serverTotal,
      totalOnPlatform: totalOnPlatform ?? this.totalOnPlatform,
      plans: plans ?? this.plans,
      updatedAt: updatedAt ?? this.updatedAt,
      query: query ?? this.query,
      activeSearch: activeSearch ?? this.activeSearch,
      subscriptionFilter: subscriptionFilter ?? this.subscriptionFilter,
      planId: planId == null ? this.planId : planId(),
      statusFilter: statusFilter ?? this.statusFilter,
      dateFilter: dateFilter ?? this.dateFilter,
      sortField: sortField == null ? this.sortField : sortField(),
      isAscending: isAscending ?? this.isAscending,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}
