import 'package:fpdart/fpdart.dart';

import '../../../../core/data/cursor_pager.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/resources/strings/shop_owners_strings.dart';
import '../datasources/shop_owners_remote_data_source.dart';
import '../models/owner_details.dart';
import '../models/owner_list_query.dart';
import '../models/owner_search.dart';
import '../models/shop_owner.dart';

class ShopOwnersRepository {
  ShopOwnersRepository(this._dataSource);

  final ShopOwnersRemoteDataSource _dataSource;

  final CursorPager<ShopOwner> _pager = CursorPager<ShopOwner>();
  final Map<OwnerListQuery, int> _counts = {};
  final Map<OwnerIdSearch, List<ShopOwner>> _ownerIdMatches = {};

  void clear() {
    _pager.clear();
    _counts.clear();
    _ownerIdMatches.clear();
  }

  Future<Either<Failure, List<ShopOwner>>> fetchPage(
    OwnerListQuery query,
    int page,
  ) => _pager.page(
    query,
    page,
    (startAfter) => _dataSource.fetchPage(query, startAfter: startAfter),
  );

  Future<Either<Failure, int>> count(OwnerListQuery query) async {
    final OwnerListQuery key = query.countKey;
    final int? cached = _counts[key];
    if (cached != null) return right(cached);
    final result = await _dataSource.count(key);
    return result.map((total) => _counts[key] = total);
  }

  Future<Either<Failure, List<ShopOwner>>> findByOwnerId(
    OwnerIdSearch search,
  ) async {
    final List<ShopOwner>? cached = _ownerIdMatches[search];
    if (cached != null) return right(cached);
    final result = await _dataSource.findByOwnerId(search);
    return result.map((owners) => _ownerIdMatches[search] = owners);
  }

  Future<Either<Failure, OwnerDetails?>> fetchOwnerDetails(
    String ownerId,
  ) async {
    final result = await _dataSource.fetchOwner(ownerId);
    return result.map((document) {
      if (document == null) return null;
      final DateTime? registeredAt = document.owner.registeredAt;
      return OwnerDetails(
        documentId: document.documentId,
        owner: document.owner,
        shops: document.shops,
        activities: [
          if (registeredAt != null)
            OwnerActivity(
              title: ShopOwnersStrings.activityRegistered,
              actor: ShopOwnersStrings.activitySystem,
              at: registeredAt,
            ),
        ],
      );
    });
  }

  Future<Either<Failure, Unit>> setRestricted(
    OwnerDetails details,
    bool isRestricted,
  ) async {
    final result = await _dataSource.setAccountBlocked(
      details.documentId,
      isRestricted,
    );
    if (result.isRight()) clear();
    return result;
  }
}
