import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/data/cursor_pager.dart';
import '../../../../core/data/firestore_failures.dart';
import '../../../../core/data/prefix_search.dart';
import '../../../../core/enums/subscription_status.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/resources/strings/app_strings.dart';
import '../models/shop.dart';
import '../models/shop_list_query.dart';
import '../models/shop_search.dart';

class ShopsRemoteDataSource {
  const ShopsRemoteDataSource(this._firestore);

  static const String _usersCollection = 'users';
  static const String _userNameField = 'name';
  static const int _lookupLimit = 10;
  static const int _whereInLimit = 30;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _shops =>
      _firestore.collection(Shop.collection);

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection(_usersCollection);

  List<Filter> _subscriptionFilters(ShopListQuery query) {
    final Timestamp soon = Timestamp.fromDate(query.expiringSoonLimit);
    return switch (query.subscription) {
      SubscriptionFilter.all => const [],
      SubscriptionFilter.active => [
        Filter(Shop.subscriptionStatusField, isEqualTo: Shop.statusActive),
        Filter(Shop.subscriptionExpiresAtField, isGreaterThan: soon),
      ],
      SubscriptionFilter.expiringSoon => [
        Filter(Shop.subscriptionStatusField, isEqualTo: Shop.statusActive),
        Filter(Shop.subscriptionExpiresAtField, isLessThanOrEqualTo: soon),
      ],
      SubscriptionFilter.expired => [
        Filter(Shop.subscriptionStatusField, isEqualTo: Shop.statusExpired),
      ],
      SubscriptionFilter.unsubscribed => [
        Filter(
          Shop.subscriptionStatusField,
          isEqualTo: Shop.statusUnsubscribed,
        ),
      ],
    };
  }

  Query<Map<String, dynamic>> _ordered(ShopListQuery query) {
    final ShopNameSearch? search = query.search;
    final String? planId = query.planId;
    final DateTime? since = query.registeredSince;
    final List<Filter> filters = [
      if (search != null)
        PrefixSearch.startsWithAny(Shop.nameField, search.prefixes),
      if (planId != null) Filter(Shop.planIdField, isEqualTo: planId),
      ..._subscriptionFilters(query),
      if (query.status != ShopStatusFilter.all)
        Filter(
          Shop.isRestrictedField,
          isEqualTo: query.status == ShopStatusFilter.restricted,
        ),
      if (since != null)
        Filter(
          Shop.createdAtField,
          isGreaterThanOrEqualTo: Timestamp.fromDate(since),
        ),
    ];
    final Query<Map<String, dynamic>> filtered = filters.isEmpty
        ? _shops
        : _shops.where(filters.reduce(Filter.and));
    return search != null
        ? filtered.orderBy(Shop.nameField)
        : filtered.orderBy(Shop.createdAtField, descending: true);
  }

  List<Shop> _shopsFrom(
    QuerySnapshot<Map<String, dynamic>> snapshot,
    DateTime today,
  ) => [
    for (final document in snapshot.docs)
      Shop.fromDocument(document.id, document.data(), now: today),
  ];

  Future<Either<Failure, CursorPage<Shop>>> fetchPage(
    ShopListQuery query, {
    DocumentSnapshot<Map<String, dynamic>>? startAfter,
  }) => _read(() async {
    Query<Map<String, dynamic>> page = _ordered(query).limit(query.pageSize);
    if (startAfter != null) page = page.startAfterDocument(startAfter);
    final snapshot = await page.get();
    return (
      items: _shopsFrom(snapshot, query.today),
      last: snapshot.docs.lastOrNull,
      hasMore: snapshot.docs.length == query.pageSize,
    );
  });

  Future<Either<Failure, int>> count(ShopListQuery query) => _read(() async {
    final snapshot = await _ordered(query).count().get();
    return snapshot.count ?? 0;
  });

  Future<Either<Failure, List<Shop>>> findByShopId(
    ShopIdSearch search,
    DateTime today,
  ) => _read(() async {
    final snapshot = await _shops
        .where(
          PrefixSearch.startsWithAny(FieldPath.documentId, search.prefixes),
        )
        .limit(_lookupLimit)
        .get();
    return _shopsFrom(
      snapshot,
      today,
    ).where((shop) => search.matches(shop.shopId)).toList();
  });

  Future<Either<Failure, List<Shop>>> findByOwnerId(
    ShopIdSearch search,
    DateTime today,
  ) => _read(() async {
    final snapshot = await _shops
        .where(PrefixSearch.startsWithAny(Shop.ownerIdField, search.prefixes))
        .limit(_lookupLimit)
        .get();
    return _shopsFrom(
      snapshot,
      today,
    ).where((shop) => search.matches(shop.ownerId)).toList();
  });

  Future<Either<Failure, List<Shop>>> findByOwnerName(
    ShopNameSearch search,
    DateTime today,
  ) => _read(() async {
    final owners = await _users
        .where(PrefixSearch.startsWithAny(_userNameField, search.prefixes))
        .limit(_lookupLimit)
        .get();
    final List<String> ownerIds = [
      for (final document in owners.docs) document.id,
    ];
    if (ownerIds.isEmpty) return const <Shop>[];
    final snapshot = await _shops
        .where(Shop.ownerIdField, whereIn: ownerIds)
        .limit(_whereInLimit)
        .get();
    return _shopsFrom(snapshot, today);
  });

  Future<Either<Failure, Map<String, String>>> fetchOwnerNames(
    Set<String> ownerIds,
  ) => _namesById(_users, _userNameField, ownerIds);

  Future<Either<Failure, Map<String, String>>> fetchShopNames(
    Set<String> shopIds,
  ) => _namesById(_shops, Shop.nameField, shopIds);

  Future<Either<Failure, Map<String, String>>> _namesById(
    CollectionReference<Map<String, dynamic>> collection,
    String field,
    Set<String> ids,
  ) => _read(() async {
    final List<String> all = ids.where((id) => id.isNotEmpty).toList();
    final Map<String, String> names = {};
    for (int start = 0; start < all.length; start += _whereInLimit) {
      final List<String> chunk = all.sublist(
        start,
        start + _whereInLimit > all.length ? all.length : start + _whereInLimit,
      );
      final snapshot = await collection
          .where(FieldPath.documentId, whereIn: chunk)
          .get();
      for (final document in snapshot.docs) {
        final Object? value = document.data()[field];
        names[document.id] = value is String ? value.trim() : '';
      }
    }
    return names;
  });

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
