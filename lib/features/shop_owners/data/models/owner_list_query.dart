import 'owner_search.dart';
import 'shop_owner.dart';

enum OwnerStatusFilter {
  all,
  active,
  restricted,
  deleted;

  bool matches(OwnerStatus status) => switch (this) {
    OwnerStatusFilter.all => true,
    OwnerStatusFilter.active => status == OwnerStatus.active,
    OwnerStatusFilter.restricted => status == OwnerStatus.restricted,
    OwnerStatusFilter.deleted => status == OwnerStatus.deleted,
  };
}

class OwnerListQuery {
  const OwnerListQuery({
    this.status = OwnerStatusFilter.all,
    this.registeredSince,
    this.search,
    this.newestFirst = true,
    this.pageSize = 10,
  });

  final OwnerStatusFilter status;
  final DateTime? registeredSince;
  final OwnerSearchQuery? search;
  final bool newestFirst;
  final int pageSize;

  bool matches(ShopOwner owner) {
    final DateTime? since = registeredSince;
    final DateTime? registeredAt = owner.registeredAt;
    return status.matches(owner.status) &&
        (since == null ||
            (registeredAt != null && !registeredAt.isBefore(since)));
  }

  OwnerListQuery get countKey => OwnerListQuery(
    status: status,
    registeredSince: registeredSince,
    search: search,
  );

  @override
  bool operator ==(Object other) =>
      other is OwnerListQuery &&
      other.status == status &&
      other.registeredSince == registeredSince &&
      other.search == search &&
      other.newestFirst == newestFirst &&
      other.pageSize == pageSize;

  @override
  int get hashCode =>
      Object.hash(status, registeredSince, search, newestFirst, pageSize);
}
