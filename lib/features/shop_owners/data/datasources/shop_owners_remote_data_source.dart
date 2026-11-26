import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/data/cursor_pager.dart';
import '../../../../core/data/firestore_failures.dart';
import '../../../../core/data/prefix_search.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/resources/strings/app_strings.dart';
import '../models/owner_details.dart';
import '../models/owner_list_query.dart';
import '../models/owner_search.dart';
import '../models/shop_owner.dart';

typedef OwnerDocument = ({
  String documentId,
  ShopOwner owner,
  List<LinkedShop> shops,
});

class ShopOwnersRemoteDataSource {
  const ShopOwnersRemoteDataSource(this._firestore);

  static const String _collection = 'users';
  static const int _ownerIdLimit = 10;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection(_collection);

  List<Filter> _statusFilters(OwnerStatusFilter status) => switch (status) {
    OwnerStatusFilter.all => const [],
    OwnerStatusFilter.active => [
      Filter(ShopOwner.isDeletedField, isEqualTo: false),
      Filter(ShopOwner.isAccountBlockedField, isEqualTo: false),
    ],
    OwnerStatusFilter.restricted => [
      Filter(ShopOwner.isDeletedField, isEqualTo: false),
      Filter(ShopOwner.isAccountBlockedField, isEqualTo: true),
    ],
    OwnerStatusFilter.deleted => [
      Filter(ShopOwner.isDeletedField, isEqualTo: true),
    ],
  };

  Query<Map<String, dynamic>> _ordered(OwnerListQuery query) {
    final OwnerSearchQuery? search = query.search;
    final DateTime? since = query.registeredSince;
    final List<Filter> filters = [
      if (search != null)
        PrefixSearch.startsWithAny(search.field, search.prefixes),
      ..._statusFilters(query.status),
      if (since != null)
        Filter(
          ShopOwner.createdAtField,
          isGreaterThanOrEqualTo: Timestamp.fromDate(since),
        ),
    ];
    final Query<Map<String, dynamic>> filtered = filters.isEmpty
        ? _users
        : _users.where(filters.reduce(Filter.and));
    return search != null
        ? filtered.orderBy(search.field)
        : filtered.orderBy(
            ShopOwner.createdAtField,
            descending: query.newestFirst,
          );
  }

  Future<Either<Failure, CursorPage<ShopOwner>>> fetchPage(
    OwnerListQuery query, {
    DocumentSnapshot<Map<String, dynamic>>? startAfter,
  }) => _read(() async {
    Query<Map<String, dynamic>> page = _ordered(query).limit(query.pageSize);
    if (startAfter != null) page = page.startAfterDocument(startAfter);
    final snapshot = await page.get();
    return (
      items: [
        for (final document in snapshot.docs)
          ShopOwner.fromDocument(document.id, document.data()),
      ],
      last: snapshot.docs.lastOrNull,
      hasMore: snapshot.docs.length == query.pageSize,
    );
  });

  Future<Either<Failure, int>> count(OwnerListQuery query) => _read(() async {
    final snapshot = await _ordered(query).count().get();
    return snapshot.count ?? 0;
  });

  Future<Either<Failure, List<ShopOwner>>> findByOwnerId(
    OwnerIdSearch search,
  ) => _read(() async {
    final snapshot = await _users
        .where(
          PrefixSearch.startsWithAny(ShopOwner.userIdField, search.prefixes),
        )
        .limit(_ownerIdLimit)
        .get();
    return [
      for (final document in snapshot.docs)
        ShopOwner.fromDocument(document.id, document.data()),
    ].where(search.matches).toList();
  });

  Future<Either<Failure, OwnerDocument?>> fetchOwner(String ownerId) =>
      _read(() async {
        DocumentSnapshot<Map<String, dynamic>> document = await _users
            .doc(ownerId)
            .get();
        if (!document.exists) {
          final snapshot = await _users
              .where(ShopOwner.userIdField, isEqualTo: ownerId)
              .limit(1)
              .get();
          final match = snapshot.docs.firstOrNull;
          if (match == null) return null;
          document = match;
        }
        final Map<String, dynamic> data = document.data() ?? const {};
        return (
          documentId: document.id,
          owner: ShopOwner.fromDocument(document.id, data),
          shops: LinkedShop.listFrom(data[ShopOwner.shopsField]),
        );
      });

  Future<Either<Failure, Unit>> setAccountBlocked(
    String documentId,
    bool isBlocked,
  ) async {
    try {
      await _users.doc(documentId).update({
        ShopOwner.isAccountBlockedField: isBlocked,
      });
      return right(unit);
    } on FirebaseException catch (error) {
      return left(FirestoreFailures.write(error.code));
    } catch (_) {
      return left(const DataFailure(AppStrings.recordsSaveFailed));
    }
  }

  Future<Either<Failure, T>> _read<T>(Future<T> Function() action) async {
    try {
      return right(await action());
    } on FirebaseException catch (error) {
      return left(FirestoreFailures.read(error.code));
    } catch (_) {
      return left(const DataFailure(AppStrings.recordsLoadFailed));
    }
  }
}
