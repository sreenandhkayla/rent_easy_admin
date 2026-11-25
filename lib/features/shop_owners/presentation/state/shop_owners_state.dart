import 'dart:math' as math;

import '../../../../core/enums/registration_date_filter.dart';
import '../../data/models/shop_owner.dart';

enum OwnerStatusFilter { all, active, restricted }

enum OwnerSortField { name, registeredAt, shops }

class ShopOwnersState {
  const ShopOwnersState({
    this.isLoading = true,
    this.owners = const [],
    this.totalOnPlatform = 0,
    this.updatedAt,
    this.query = '',
    this.statusFilter = OwnerStatusFilter.all,
    this.dateFilter = RegistrationDateFilter.any,
    this.sortField = OwnerSortField.name,
    this.isAscending = true,
    this.page = 1,
  });

  static const int pageSize = 6;

  final bool isLoading;
  final List<ShopOwner> owners;
  final int totalOnPlatform;
  final DateTime? updatedAt;
  final String query;
  final OwnerStatusFilter statusFilter;
  final RegistrationDateFilter dateFilter;
  final OwnerSortField sortField;
  final bool isAscending;
  final int page;

  List<ShopOwner> get filteredOwners {
    final String search = query.trim().toLowerCase();
    final String searchDigits = search.replaceAll(RegExp(r'\D'), '');
    final DateTime? since = _registeredSince;
    final List<ShopOwner> result = owners.where((owner) {
      final bool matchesSearch =
          search.isEmpty ||
          owner.name.toLowerCase().contains(search) ||
          owner.ownerId.toLowerCase().contains(search) ||
          (searchDigits.isNotEmpty &&
              owner.mobile
                  .replaceAll(RegExp(r'\D'), '')
                  .contains(searchDigits));
      final bool matchesStatus = switch (statusFilter) {
        OwnerStatusFilter.all => true,
        OwnerStatusFilter.active => owner.status == OwnerStatus.active,
        OwnerStatusFilter.restricted => owner.status == OwnerStatus.restricted,
      };
      final bool matchesDate =
          since == null || !owner.registeredAt.isBefore(since);
      return matchesSearch && matchesStatus && matchesDate;
    }).toList();
    result.sort((a, b) {
      final int order = switch (sortField) {
        OwnerSortField.name => a.name.toLowerCase().compareTo(
          b.name.toLowerCase(),
        ),
        OwnerSortField.registeredAt => a.registeredAt.compareTo(b.registeredAt),
        OwnerSortField.shops => a.shops.compareTo(b.shops),
      };
      return isAscending ? order : -order;
    });
    return result;
  }

  int get pageCount => math.max(1, (filteredOwners.length / pageSize).ceil());

  List<ShopOwner> get pageOwners {
    final List<ShopOwner> all = filteredOwners;
    final int start = (page - 1) * pageSize;
    if (start >= all.length) return const [];
    return all.sublist(start, math.min(start + pageSize, all.length));
  }

  DateTime? get _registeredSince =>
      dateFilter.since(updatedAt ?? DateTime.now());

  ShopOwnersState copyWith({
    bool? isLoading,
    List<ShopOwner>? owners,
    int? totalOnPlatform,
    DateTime? updatedAt,
    String? query,
    OwnerStatusFilter? statusFilter,
    RegistrationDateFilter? dateFilter,
    OwnerSortField? sortField,
    bool? isAscending,
    int? page,
  }) {
    return ShopOwnersState(
      isLoading: isLoading ?? this.isLoading,
      owners: owners ?? this.owners,
      totalOnPlatform: totalOnPlatform ?? this.totalOnPlatform,
      updatedAt: updatedAt ?? this.updatedAt,
      query: query ?? this.query,
      statusFilter: statusFilter ?? this.statusFilter,
      dateFilter: dateFilter ?? this.dateFilter,
      sortField: sortField ?? this.sortField,
      isAscending: isAscending ?? this.isAscending,
      page: page ?? this.page,
    );
  }
}
