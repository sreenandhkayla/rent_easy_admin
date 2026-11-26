import 'dart:math' as math;

import '../../../../core/enums/registration_date_filter.dart';
import '../../data/models/owner_list_query.dart';
import '../../data/models/owner_search.dart';
import '../../data/models/shop_owner.dart';

export '../../data/models/owner_list_query.dart' show OwnerStatusFilter;

enum OwnerSortField { name, registeredAt, shops }

class ShopOwnersState {
  const ShopOwnersState({
    this.isLoading = true,
    this.hasLoaded = false,
    this.errorMessage,
    this.rows = const [],
    this.ownerIdMatches = const [],
    this.serverTotal = 0,
    this.totalOnPlatform = 0,
    this.updatedAt,
    this.query = '',
    this.activeSearch = '',
    this.statusFilter = OwnerStatusFilter.all,
    this.dateFilter = RegistrationDateFilter.any,
    this.sortField = OwnerSortField.registeredAt,
    this.isAscending = false,
    this.hasCustomSearchSort = false,
    this.page = 1,
    this.pageSize = defaultPageSize,
  });

  static const int defaultPageSize = 10;
  static const List<int> pageSizes = [10, 25, 50];

  final bool isLoading;
  final bool hasLoaded;
  final String? errorMessage;
  final List<ShopOwner> rows;
  final List<ShopOwner> ownerIdMatches;
  final int serverTotal;
  final int totalOnPlatform;
  final DateTime? updatedAt;
  final String query;
  final String activeSearch;
  final OwnerStatusFilter statusFilter;
  final RegistrationDateFilter dateFilter;
  final OwnerSortField sortField;
  final bool isAscending;
  final bool hasCustomSearchSort;
  final int page;
  final int pageSize;

  bool get isSearching => OwnerSearch.isActive(activeSearch);

  bool get isServerSorted =>
      !isSearching && sortField == OwnerSortField.registeredAt;

  OwnerListQuery get listQuery {
    final DateTime now = DateTime.now();
    return OwnerListQuery(
      status: statusFilter,
      registeredSince: dateFilter.since(DateTime(now.year, now.month, now.day)),
      search: OwnerSearch.queryFor(activeSearch),
      newestFirst: !(isServerSorted && isAscending),
      pageSize: pageSize,
    );
  }

  List<ShopOwner> get _extraOwnerIdMatches {
    final Set<String> listed = {for (final owner in rows) owner.ownerId};
    return [
      for (final owner in ownerIdMatches)
        if (!listed.contains(owner.ownerId)) owner,
    ];
  }

  int get totalCount =>
      serverTotal + (isSearching ? _extraOwnerIdMatches.length : 0);

  int get pageCount => math.max(1, (serverTotal / pageSize).ceil());

  int get firstRowNumber {
    if (totalCount == 0) return 0;
    if (page == 1) return 1;
    return (page - 1) * pageSize + _extraOwnerIdMatches.length + 1;
  }

  List<ShopOwner> get visibleRows {
    final bool keepServerOrder =
        isServerSorted || (isSearching && !hasCustomSearchSort);
    final List<ShopOwner> ordered = keepServerOrder ? rows : _sorted(rows);
    if (!isSearching || page != 1) return ordered;
    return [..._extraOwnerIdMatches, ...ordered];
  }

  List<ShopOwner> _sorted(List<ShopOwner> owners) {
    final List<ShopOwner> result = List.of(owners);
    result.sort((a, b) {
      final int order = switch (sortField) {
        OwnerSortField.name => a.name.toLowerCase().compareTo(
          b.name.toLowerCase(),
        ),
        OwnerSortField.registeredAt => _compareDates(
          a.registeredAt,
          b.registeredAt,
        ),
        OwnerSortField.shops => a.shops.compareTo(b.shops),
      };
      return isAscending ? order : -order;
    });
    return result;
  }

  static int _compareDates(DateTime? a, DateTime? b) {
    if (a == null && b == null) return 0;
    if (a == null) return -1;
    if (b == null) return 1;
    return a.compareTo(b);
  }

  ShopOwnersState copyWith({
    bool? isLoading,
    bool? hasLoaded,
    String? Function()? errorMessage,
    List<ShopOwner>? rows,
    List<ShopOwner>? ownerIdMatches,
    int? serverTotal,
    int? totalOnPlatform,
    DateTime? updatedAt,
    String? query,
    String? activeSearch,
    OwnerStatusFilter? statusFilter,
    RegistrationDateFilter? dateFilter,
    OwnerSortField? sortField,
    bool? isAscending,
    bool? hasCustomSearchSort,
    int? page,
    int? pageSize,
  }) {
    return ShopOwnersState(
      isLoading: isLoading ?? this.isLoading,
      hasLoaded: hasLoaded ?? this.hasLoaded,
      errorMessage: errorMessage == null ? this.errorMessage : errorMessage(),
      rows: rows ?? this.rows,
      ownerIdMatches: ownerIdMatches ?? this.ownerIdMatches,
      serverTotal: serverTotal ?? this.serverTotal,
      totalOnPlatform: totalOnPlatform ?? this.totalOnPlatform,
      updatedAt: updatedAt ?? this.updatedAt,
      query: query ?? this.query,
      activeSearch: activeSearch ?? this.activeSearch,
      statusFilter: statusFilter ?? this.statusFilter,
      dateFilter: dateFilter ?? this.dateFilter,
      sortField: sortField ?? this.sortField,
      isAscending: isAscending ?? this.isAscending,
      hasCustomSearchSort: hasCustomSearchSort ?? this.hasCustomSearchSort,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}
