import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rent_easy_admin/core/enums/registration_date_filter.dart';
import 'package:rent_easy_admin/features/shop_owners/data/models/owner_details.dart';
import 'package:rent_easy_admin/features/shop_owners/data/models/owner_list_query.dart';
import 'package:rent_easy_admin/features/shop_owners/data/models/owner_search.dart';
import 'package:rent_easy_admin/features/shop_owners/data/models/shop_owner.dart';
import 'package:rent_easy_admin/features/shop_owners/presentation/state/shop_owners_state.dart';

ShopOwner owner({
  required String id,
  String name = '',
  DateTime? registeredAt,
  int shops = 1,
  OwnerStatus status = OwnerStatus.active,
}) => ShopOwner(
  name: name,
  mobile: '+919000000000',
  ownerId: id,
  registeredAt: registeredAt,
  shops: shops,
  subscribedShops: null,
  status: status,
);

void main() {
  group('ShopOwner.fromDocument', () {
    test('maps users fields and leaves subscription unavailable', () {
      final ShopOwner mapped = ShopOwner.fromDocument('doc1', {
        'userId': 'KzR1',
        'name': null,
        'phone': '+919526197552',
        'createdAt': Timestamp.fromDate(DateTime(2026, 11, 26)),
        'shops': [
          {'id': 's1'},
          {'id': 's2'},
        ],
        'isAccountBlocked': false,
        'isDeleted': false,
      });
      expect(mapped.ownerId, 'KzR1');
      expect(mapped.name, '');
      expect(mapped.mobile, '+919526197552');
      expect(mapped.registeredAt, DateTime(2026, 11, 26));
      expect(mapped.shops, 2);
      expect(mapped.subscribedShops, isNull);
      expect(mapped.status, OwnerStatus.active);
    });

    test('falls back to the document ID and a missing date', () {
      final ShopOwner mapped = ShopOwner.fromDocument('doc1', const {});
      expect(mapped.ownerId, 'doc1');
      expect(mapped.registeredAt, isNull);
      expect(mapped.shops, 0);
    });

    test('reads subscribed when it becomes available', () {
      expect(
        ShopOwner.fromDocument('d', const {'subscribed': 3}).subscribedShops,
        3,
      );
    });
  });

  group('status priority', () {
    test('Deleted wins over Restricted', () {
      expect(
        ShopOwner.statusOf(const {'isDeleted': true, 'isAccountBlocked': true}),
        OwnerStatus.deleted,
      );
      expect(
        ShopOwner.statusOf(const {
          'isDeleted': false,
          'isAccountBlocked': true,
        }),
        OwnerStatus.restricted,
      );
      expect(ShopOwner.statusOf(const {}), OwnerStatus.active);
    });
  });

  group('OwnerListQuery.matches (search filtering)', () {
    final DateTime since = DateTime(2026, 10, 1);
    final List<ShopOwner> owners = [
      owner(id: 'a', registeredAt: DateTime(2026, 11, 1)),
      owner(
        id: 'r',
        registeredAt: DateTime(2026, 11, 2),
        status: OwnerStatus.restricted,
      ),
      owner(
        id: 'd',
        registeredAt: DateTime(2025, 1, 1),
        status: OwnerStatus.deleted,
      ),
      owner(id: 'n'),
    ];

    List<String> ids(OwnerListQuery query) =>
        owners.where(query.matches).map((o) => o.ownerId).toList();

    test('every status with and without a date', () {
      expect(ids(const OwnerListQuery()), ['a', 'r', 'd', 'n']);
      expect(ids(const OwnerListQuery(status: OwnerStatusFilter.active)), [
        'a',
        'n',
      ]);
      expect(ids(const OwnerListQuery(status: OwnerStatusFilter.restricted)), [
        'r',
      ]);
      expect(ids(const OwnerListQuery(status: OwnerStatusFilter.deleted)), [
        'd',
      ]);
      expect(ids(OwnerListQuery(registeredSince: since)), ['a', 'r']);
      expect(
        ids(
          OwnerListQuery(
            status: OwnerStatusFilter.active,
            registeredSince: since,
          ),
        ),
        ['a'],
      );
      expect(
        ids(
          OwnerListQuery(
            status: OwnerStatusFilter.deleted,
            registeredSince: since,
          ),
        ),
        isEmpty,
      );
    });
  });

  group('OwnerSearch.queryFor (one Firestore query)', () {
    test('needs at least 2 characters', () {
      expect(OwnerSearch.queryFor('a'), isNull);
      expect(OwnerSearch.isActive('a'), isFalse);
    });

    test('digits search phone with +91 added', () {
      final OwnerSearchQuery query = OwnerSearch.queryFor('9526')!;
      expect(query.field, ShopOwner.phoneField);
      expect(query.prefixes, ['+919526']);
    });

    test('typed country code is kept as is', () {
      expect(OwnerSearch.queryFor('+919526')!.prefixes, ['+919526']);
      expect(OwnerSearch.queryFor('919526197552')!.prefixes, ['+919526197552']);
    });

    test('text searches name as typed, lowercase and capitalized', () {
      final OwnerSearchQuery query = OwnerSearch.queryFor('arjun r')!;
      expect(query.field, ShopOwner.nameField);
      expect(query.prefixes.toSet(), {'arjun r', 'Arjun R'});
    });

    test('same text gives an equal query for caching', () {
      expect(OwnerSearch.queryFor('arjun'), OwnerSearch.queryFor('arjun'));
    });
  });

  group('OwnerSearch.ownerIdFor (case-insensitive)', () {
    final ShopOwner stored = owner(id: 'KzR1AEU3ncAKEAav7Ot0');

    test('starts from 2 characters and skips phones and spaces', () {
      expect(OwnerSearch.ownerIdFor('k'), isNull);
      expect(OwnerSearch.ownerIdFor('9526'), isNull);
      expect(OwnerSearch.ownerIdFor('arjun r'), isNull);
    });

    test('2 and 3 characters find the owner ignoring case', () {
      final ShopOwner stored = owner(id: 'KzR1AEU3ncAKEAav7Ot0');
      final OwnerIdSearch two = OwnerSearch.ownerIdFor('kz')!;
      expect(two.prefixes, containsAll(['kz', 'Kz', 'kZ', 'KZ']));
      expect(two.matches(stored), isTrue);
      final OwnerIdSearch three = OwnerSearch.ownerIdFor('KZR')!;
      expect(three.prefixes, contains('KzR'));
      expect(three.matches(stored), isTrue);
    });

    test('short IDs send every capitalisation to Firestore', () {
      final OwnerIdSearch search = OwnerSearch.ownerIdFor('kzr1')!;
      expect(search.prefixes, hasLength(8));
      expect(search.prefixes, contains('KzR1'));
      expect(search.matches(stored), isTrue);
    });

    test('long IDs query the first 4 letters and match the rest', () {
      final OwnerIdSearch search = OwnerSearch.ownerIdFor('kzr1aeu3NC')!;
      expect(search.prefixes, hasLength(16));
      expect(search.prefixes, contains('KzR1A'));
      expect(search.matches(stored), isTrue);
      expect(search.matches(owner(id: 'KzR1AEX9')), isFalse);
    });
  });

  group('ShopOwnersState', () {
    final List<ShopOwner> page = [
      for (int i = 1; i <= 10; i++)
        owner(id: 'o$i', name: 'Owner $i', registeredAt: DateTime(2026, 1, i)),
    ];

    test('search goes into the Firestore query', () {
      const ShopOwnersState state = ShopOwnersState(activeSearch: '9526');
      expect(state.isSearching, isTrue);
      expect(state.listQuery.search?.field, ShopOwner.phoneField);
      expect(const ShopOwnersState().listQuery.search, isNull);
    });

    test('server total drives page count', () {
      final ShopOwnersState state = ShopOwnersState(
        rows: page,
        serverTotal: 23,
        page: 3,
      );
      expect(state.pageCount, 3);
      expect(state.firstRowNumber, 21);
    });

    test('owner ID matches show first on page 1 without duplicates', () {
      final ShopOwnersState state = ShopOwnersState(
        activeSearch: 'kzr1',
        rows: page,
        ownerIdMatches: [
          owner(id: 'KzR1x'),
          page.first,
        ],
        serverTotal: 10,
      );
      expect(state.visibleRows.first.ownerId, 'KzR1x');
      expect(state.visibleRows, hasLength(11));
      expect(state.totalCount, 11);
    });

    test('search keeps Firestore order until a column is sorted', () {
      final List<ShopOwner> reversed = page.reversed.toList();
      final ShopOwnersState state = ShopOwnersState(
        activeSearch: 'Owner',
        rows: reversed,
        serverTotal: 10,
      );
      expect(state.visibleRows.first.ownerId, 'o10');
      expect(
        state
            .copyWith(
              hasCustomSearchSort: true,
              sortField: OwnerSortField.registeredAt,
              isAscending: true,
            )
            .visibleRows
            .first
            .ownerId,
        'o1',
      );
    });

    test('browse uses newest first unless Registered ascending', () {
      expect(const ShopOwnersState().listQuery.newestFirst, isTrue);
      expect(
        const ShopOwnersState(isAscending: true).listQuery.newestFirst,
        isFalse,
      );
    });

    test('date filter gives a stable query for caching', () {
      const ShopOwnersState state = ShopOwnersState(
        dateFilter: RegistrationDateFilter.last30Days,
      );
      expect(state.listQuery, state.listQuery);
    });
  });

  group('Owner details', () {
    test('linked shops come from the users shops array', () {
      final List<LinkedShop> shops = LinkedShop.listFrom([
        {
          'id': 'QQDN4aNvwMTIM1m0Qbay',
          'name': 'Kumar Rentals',
          'location': 'Edappally, Kochi',
          'role': 'owner',
        },
        'not a map',
        {'id': 'x2'},
      ]);
      expect(shops, hasLength(2));
      expect(shops.first.shopId, 'QQDN4aNvwMTIM1m0Qbay');
      expect(shops.first.name, 'Kumar Rentals');
      expect(shops.first.location, 'Edappally, Kochi');
      expect(shops.first.subscription, isNull);
      expect(shops.last.name, '');
      expect(LinkedShop.listFrom(null), isEmpty);
    });

    test('restricting keeps the document ID and shops', () {
      final OwnerDetails details = OwnerDetails(
        documentId: 'doc1',
        owner: owner(id: 'doc1'),
        shops: const [],
        activities: const [],
      );
      final OwnerDetails restricted = details.copyWith(
        owner: details.owner.copyWith(status: OwnerStatus.restricted),
      );
      expect(restricted.documentId, 'doc1');
      expect(restricted.owner.status, OwnerStatus.restricted);
    });
  });
}
