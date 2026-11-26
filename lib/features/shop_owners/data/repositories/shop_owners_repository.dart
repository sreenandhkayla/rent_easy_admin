import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';

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

  OwnerListQuery? _pagedQuery;
  final List<List<ShopOwner>> _pages = [];
  DocumentSnapshot<Map<String, dynamic>>? _lastDocument;
  bool _isExhausted = false;
  final Map<OwnerListQuery, int> _counts = {};
  final Map<OwnerIdSearch, List<ShopOwner>> _ownerIdMatches = {};

  void clear() {
    _resetPages(null);
    _counts.clear();
    _ownerIdMatches.clear();
  }

  void _resetPages(OwnerListQuery? query) {
    _pagedQuery = query;
    _pages.clear();
    _lastDocument = null;
    _isExhausted = false;
  }

  Future<Either<Failure, List<ShopOwner>>> fetchPage(
    OwnerListQuery query,
    int page,
  ) async {
    if (query != _pagedQuery) _resetPages(query);
    while (_pages.length < page && !_isExhausted) {
      final result = await _dataSource.fetchPage(
        query,
        startAfter: _lastDocument,
      );
      if (query != _pagedQuery) return right(const []);
      if (result case Left(:final value)) return left(value);
      final OwnerPageResult loaded = result.getOrElse(
        (_) => (owners: const [], last: null, hasMore: false),
      );
      if (loaded.owners.isEmpty) {
        _isExhausted = true;
        break;
      }
      _pages.add(loaded.owners);
      _lastDocument = loaded.last;
      _isExhausted = !loaded.hasMore;
    }
    return right(page <= _pages.length ? _pages[page - 1] : const []);
  }

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
