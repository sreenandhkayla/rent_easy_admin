import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rent_easy_admin/core/data/prefix_search.dart';
import 'package:rent_easy_admin/core/enums/registration_date_filter.dart';
import 'package:rent_easy_admin/core/enums/subscription_status.dart';
import 'package:rent_easy_admin/features/shops/data/models/shop.dart';
import 'package:rent_easy_admin/features/shops/data/models/shop_list_query.dart';
import 'package:rent_easy_admin/features/shops/data/models/shop_search.dart';
import 'package:rent_easy_admin/features/shops/presentation/state/shops_state.dart';

final DateTime today = DateTime(2026, 11, 26);

Shop shop(
  String id, {
  String name = 'Shop',
  String ownerId = 'owner1',
  String? planId,
  SubscriptionStatus? subscription,
  ShopStatus status = ShopStatus.active,
  DateTime? registeredAt,
  DateTime? expiresAt,
}) => Shop(
  name: name,
  shopId: id,
  ownerName: '',
  ownerId: ownerId,
  location: '',
  address: '',
  contact: '',
  subscription: subscription,
  status: status,
  registeredAt: registeredAt,
  planId: planId,
  expiresAt: expiresAt,
);

void main() {
  group('Shop.fromDocument', () {
    test('existing shops without the new fields', () {
      final Shop mapped = Shop.fromDocument('QQDN4aNvwMTIM1m0Qbay', {
        'name': 'Kumar Rentals',
        'ownerId': 'KzR1AEU3ncAKEAav7Ot0',
        'location': 'Edappally, Kochi',
        'address': null,
        'phoneNumber': '9526197552',
        'createdAt': Timestamp.fromDate(DateTime(2026, 11, 26)),
      }, now: today);
      expect(mapped.shopId, 'QQDN4aNvwMTIM1m0Qbay');
      expect(mapped.ownerId, 'KzR1AEU3ncAKEAav7Ot0');
      expect(mapped.registeredAt, DateTime(2026, 11, 26));
      expect(mapped.subscription, isNull);
      expect(mapped.status, ShopStatus.active);
      expect(mapped.planId, isNull);
      expect(mapped.isBranch, isFalse);
    });

    test('new shops with plan, subscription, restriction and parent', () {
      final Shop mapped = Shop.fromDocument('s2', {
        'name': 'Branch',
        'planId': 'p1',
        'subscriptionStatus': 'active',
        'subscriptionExpiresAt': Timestamp.fromDate(DateTime(2027, 1, 1)),
        'isRestricted': true,
        'parentShopId': 's1',
      }, now: today);
      expect(mapped.planId, 'p1');
      expect(mapped.subscription, SubscriptionStatus.active);
      expect(mapped.status, ShopStatus.restricted);
      expect(mapped.parentShopId, 's1');
      expect(mapped.isBranch, isTrue);
    });

    test('active within 7 days shows Expiring soon', () {
      expect(
        Shop.subscriptionOf('active', DateTime(2026, 12, 2), today),
        SubscriptionStatus.expiringSoon,
      );
      expect(
        Shop.subscriptionOf('active', DateTime(2026, 12, 4), today),
        SubscriptionStatus.active,
      );
      expect(
        Shop.subscriptionOf('expired', null, today),
        SubscriptionStatus.expired,
      );
      expect(
        Shop.subscriptionOf('unsubscribed', null, today),
        SubscriptionStatus.unsubscribed,
      );
      expect(Shop.subscriptionOf(null, null, today), isNull);
    });
  });

  group('ShopListQuery.matches (search matches)', () {
    final List<Shop> shops = [
      shop(
        'a',
        planId: 'p1',
        subscription: SubscriptionStatus.active,
        registeredAt: DateTime(2026, 11, 20),
      ),
      shop(
        'b',
        planId: 'p2',
        subscription: SubscriptionStatus.expired,
        status: ShopStatus.restricted,
        registeredAt: DateTime(2025, 1, 1),
      ),
      shop('c'),
    ];

    List<String> ids(ShopListQuery query) =>
        shops.where(query.matches).map((s) => s.shopId).toList();

    test('plan, plan status, shop status and date combine', () {
      expect(ids(ShopListQuery(today: today)), ['a', 'b', 'c']);
      expect(ids(ShopListQuery(today: today, planId: 'p1')), ['a']);
      expect(
        ids(
          ShopListQuery(today: today, subscription: SubscriptionFilter.expired),
        ),
        ['b'],
      );
      expect(
        ids(ShopListQuery(today: today, status: ShopStatusFilter.restricted)),
        ['b'],
      );
      expect(
        ids(ShopListQuery(today: today, registeredSince: DateTime(2026, 11))),
        ['a'],
      );
      expect(
        ids(
          ShopListQuery(
            today: today,
            planId: 'p1',
            status: ShopStatusFilter.restricted,
          ),
        ),
        isEmpty,
      );
    });
  });

  group('ShopSearch', () {
    test('needs 2 characters', () {
      expect(ShopSearch.nameFor('k'), isNull);
      expect(ShopSearch.idFor('k'), isNull);
    });

    test('shop name as typed, lowercase and capitalized', () {
      expect(ShopSearch.nameFor('kumar')!.prefixes.toSet(), {'kumar', 'Kumar'});
    });

    test('IDs ignore upper/lowercase', () {
      final ShopIdSearch search = ShopSearch.idFor('qqdn')!;
      expect(search.prefixes, hasLength(16));
      expect(search.prefixes, contains('QQDN'));
      expect(search.matches('QQDN4aNvwMTIM1m0Qbay'), isTrue);
      expect(ShopSearch.idFor('kumar rentals'), isNull);
    });

    test('shared helpers stay consistent with Shop Owners', () {
      expect(PrefixSearch.caseInsensitivePrefix('kzr1aeu3'), 'kzr1a');
      expect(PrefixSearch.startsWithIgnoringCase('KzR1', 'kzr'), isTrue);
    });
  });

  group('ShopsState', () {
    final List<Shop> page = [for (int i = 1; i <= 10; i++) shop('s$i')];

    test('search goes into the Firestore query', () {
      const ShopsState state = ShopsState(activeSearch: 'kumar');
      expect(state.listQuery.search, isNotNull);
      expect(const ShopsState().listQuery.search, isNull);
    });

    test('filters go into the Firestore query', () {
      const ShopsState state = ShopsState(
        planId: 'p1',
        subscriptionFilter: SubscriptionFilter.expiringSoon,
        statusFilter: ShopStatusFilter.active,
        dateFilter: RegistrationDateFilter.last30Days,
      );
      final ShopListQuery query = state.listQuery;
      expect(query.planId, 'p1');
      expect(query.subscription, SubscriptionFilter.expiringSoon);
      expect(query.status, ShopStatusFilter.active);
      expect(query.registeredSince, isNotNull);
      expect(query, state.listQuery);
    });

    test('server total drives paging', () {
      final ShopsState state = ShopsState(rows: page, serverTotal: 23, page: 3);
      expect(state.pageCount, 3);
      expect(state.firstRowNumber, 21);
    });

    test('ID and owner matches show first on page 1 without duplicates', () {
      final ShopsState state = ShopsState(
        activeSearch: 'qqdn',
        rows: page,
        searchMatches: [shop('QQDN'), page.first],
        serverTotal: 10,
      );
      expect(state.visibleRows.first.shopId, 'QQDN');
      expect(state.visibleRows, hasLength(11));
      expect(state.totalCount, 11);
    });
  });
}
