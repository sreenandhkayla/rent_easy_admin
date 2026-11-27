import 'package:fpdart/fpdart.dart';

import '../../../../core/data/cursor_pager.dart';
import '../../../../core/enums/subscription_status.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/resources/strings/shops_strings.dart';
import '../../../subscriptions/data/models/plan_definition.dart';
import '../../../subscriptions/data/repositories/plans_repository.dart';
import '../datasources/shops_remote_data_source.dart';
import '../models/shop.dart';
import '../models/shop_details.dart';
import '../models/shop_list_query.dart';
import '../models/shop_search.dart';

class ShopsRepository {
  ShopsRepository(this._dataSource, this._plansRepository);

  final ShopsRemoteDataSource _dataSource;
  final PlansRepository _plansRepository;

  final CursorPager<Shop> _pager = CursorPager<Shop>();
  final Map<ShopListQuery, int> _counts = {};
  final Map<String, List<Shop>> _searchMatches = {};
  final Map<String, String> _ownerNames = {};
  final Map<String, String> _shopNames = {};
  List<PlanDefinition>? _plans;

  void clear() {
    _pager.clear();
    _counts.clear();
    _searchMatches.clear();
    _ownerNames.clear();
    _shopNames.clear();
    _plans = null;
  }

  Future<Either<Failure, List<PlanDefinition>>> fetchPlans() async {
    final List<PlanDefinition>? cached = _plans;
    if (cached != null) return right(cached);
    final result = await _plansRepository.fetchPlans();
    return result.map((plans) => _plans = plans);
  }

  Future<Either<Failure, List<Shop>>> fetchPage(
    ShopListQuery query,
    int page,
  ) async {
    final result = await _pager.page(
      query,
      page,
      (startAfter) => _dataSource.fetchPage(query, startAfter: startAfter),
    );
    return switch (result) {
      Left(:final value) => left(value),
      Right(:final value) => _withNames(value),
    };
  }

  Future<Either<Failure, int>> count(ShopListQuery query) async {
    final ShopListQuery key = query.countKey;
    final int? cached = _counts[key];
    if (cached != null) return right(cached);
    final result = await _dataSource.count(key);
    return result.map((total) => _counts[key] = total);
  }

  Future<Either<Failure, List<Shop>>> findSearchMatches(
    String term,
    DateTime today,
  ) async {
    final String key = ShopSearch.normalize(term);
    final List<Shop>? cached = _searchMatches[key];
    if (cached != null) return right(cached);
    final ShopIdSearch? idSearch = ShopSearch.idFor(key);
    final ShopNameSearch? nameSearch = ShopSearch.nameFor(key);
    final results = await Future.wait([
      if (idSearch != null) _dataSource.findByShopId(idSearch, today),
      if (idSearch != null) _dataSource.findByOwnerId(idSearch, today),
      if (nameSearch != null) _dataSource.findByOwnerName(nameSearch, today),
    ]);
    for (final result in results) {
      if (result case Left(:final value)) return left(value);
    }
    final Map<String, Shop> shops = {
      for (final result in results)
        for (final Shop shop in result.getOrElse((_) => const []))
          shop.shopId: shop,
    };
    final named = await _withNames(shops.values.toList());
    return named.map((matches) => _searchMatches[key] = matches);
  }

  Future<Either<Failure, ShopDetails?>> fetchShopDetails(String shopId) async {
    final DateTime today = DateTime.now();
    final shopResult = await _dataSource.fetchShop(shopId, today);
    if (shopResult case Left(:final value)) return left(value);
    final Shop? shop = shopResult.getOrElse((_) => null);
    if (shop == null) return right(null);
    List<Shop> related = const [];
    if (shop.ownerId.isNotEmpty) {
      final ownerShops = await _dataSource.fetchOwnerShops(shop.ownerId, today);
      if (ownerShops case Left(:final value)) return left(value);
      related = ShopDetails.relatedTo(
        shop,
        ownerShops.getOrElse((_) => const []),
      );
    }
    final named = await _withNames([shop, ...related]);
    return named.map(
      (shops) => ShopDetails(
        shop: shops.first,
        relatedBranches: shops.skip(1).toList(),
        activities: _activitiesFor(shops.first, today),
      ),
    );
  }

  Future<Either<Failure, Unit>> setRestricted(
    ShopDetails details,
    bool isRestricted,
  ) async {
    final result = await _dataSource.setRestricted(
      details.shop.shopId,
      isRestricted,
    );
    if (result.isRight()) clear();
    return result;
  }

  List<ShopActivity> _activitiesFor(Shop shop, DateTime today) {
    final DateTime? registeredAt = shop.registeredAt;
    final DateTime? expiresAt = shop.expiresAt;
    return [
      if (shop.subscription == SubscriptionStatus.expired &&
          expiresAt != null &&
          !expiresAt.isAfter(today))
        ShopActivity(
          title: ShopsStrings.activityExpired,
          actor: ShopsStrings.activitySystem,
          at: expiresAt,
        ),
      if (registeredAt != null)
        ShopActivity(
          title: ShopsStrings.activityRegistered,
          actor: ShopsStrings.activitySystem,
          at: registeredAt,
        ),
    ];
  }

  Future<Either<Failure, List<Shop>>> _withNames(List<Shop> shops) async {
    final Set<String> ownerIds = {
      for (final Shop shop in shops)
        if (!_ownerNames.containsKey(shop.ownerId)) shop.ownerId,
    };
    final Set<String> parentIds = {
      for (final Shop shop in shops)
        if (shop.parentShopId case final String id
            when !_shopNames.containsKey(id))
          id,
    };
    final bool needsPlans = shops.any((shop) => shop.planId != null);
    final results = await Future.wait([
      ownerIds.isEmpty
          ? Future.value(right<Failure, Map<String, String>>(const {}))
          : _dataSource.fetchOwnerNames(ownerIds),
      parentIds.isEmpty
          ? Future.value(right<Failure, Map<String, String>>(const {}))
          : _dataSource.fetchShopNames(parentIds),
    ]);
    for (final result in results) {
      if (result case Left(:final value)) return left(value);
    }
    _ownerNames.addAll(results[0].getOrElse((_) => const {}));
    _shopNames.addAll(results[1].getOrElse((_) => const {}));
    for (final String id in ownerIds) {
      _ownerNames.putIfAbsent(id, () => '');
    }
    final Map<String, String> planNames = {};
    if (needsPlans) {
      final plans = await fetchPlans();
      if (plans case Left(:final value)) return left(value);
      for (final PlanDefinition plan in plans.getOrElse((_) => const [])) {
        planNames[plan.id] = plan.name;
      }
    }
    return right([
      for (final Shop shop in shops)
        shop.copyWith(
          ownerName: _ownerNames[shop.ownerId],
          planName: planNames[shop.planId],
          branchOf: switch (shop.parentShopId) {
            final String id => _shopNames[id] ?? id,
            null => null,
          },
        ),
    ]);
  }
}
