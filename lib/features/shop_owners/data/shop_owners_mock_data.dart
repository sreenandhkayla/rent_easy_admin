import '../../../core/enums/subscription_status.dart';
import 'models/owner_details.dart';
import 'models/shop_owner.dart';

class ShopOwnersMockData {
  ShopOwnersMockData._();

  static const int totalOnPlatform = 1248;

  static final List<ShopOwner> _owners = _seedOwners();
  static final Map<String, List<OwnerActivity>> _activities = {};

  static List<ShopOwner> owners() => List.of(_owners);

  static OwnerDetails? details(String ownerId) {
    final int index = _owners.indexWhere((owner) => owner.ownerId == ownerId);
    if (index < 0) return null;
    final ShopOwner owner = _owners[index];
    return OwnerDetails(
      owner: owner,
      shops: _shopsFor(owner),
      activities: List.of(
        _activities.putIfAbsent(ownerId, () => _seedActivities(owner)),
      ),
    );
  }

  static void updateStatus(
    String ownerId,
    OwnerStatus status,
    OwnerActivity activity,
  ) {
    final int index = _owners.indexWhere((owner) => owner.ownerId == ownerId);
    if (index < 0) return;
    _owners[index] = _owners[index].copyWith(status: status);
    _activities
        .putIfAbsent(ownerId, () => _seedActivities(_owners[index]))
        .insert(0, activity);
  }

  static List<LinkedShop> _shopsFor(ShopOwner owner) {
    if (owner.ownerId == 'OWN-10421') {
      return [
        LinkedShop(
          name: 'Kumar Construction Rentals',
          shopId: 'SHP-2001',
          location: 'Kochi',
          plan: 'Professional',
          subscription: SubscriptionStatus.active,
          expiresAt: DateTime(2026, 12, 22),
        ),
        LinkedShop(
          name: 'Kumar Construction – Aluva',
          shopId: 'SHP-2002',
          location: 'Kochi',
          isBranch: true,
          plan: 'Basic',
          subscription: SubscriptionStatus.expired,
          expiresAt: DateTime(2026, 11, 2),
        ),
        const LinkedShop(
          name: 'Kumar Event Hire',
          shopId: 'SHP-2003',
          location: 'Kochi',
          subscription: SubscriptionStatus.unsubscribed,
        ),
      ];
    }
    final int idNumber = int.parse(owner.ownerId.split('-').last);
    final String baseName = '${owner.name.split(' ').first} Rentals';
    return [
      for (int i = 0; i < owner.shops; i++)
        LinkedShop(
          name: i == 0 ? baseName : '$baseName – Branch $i',
          shopId: 'SHP-${idNumber - 7000 + i}',
          location: 'Kochi',
          isBranch: i > 0,
          plan: i < owner.subscribedShops ? 'Professional' : null,
          subscription: i < owner.subscribedShops
              ? SubscriptionStatus.active
              : SubscriptionStatus.unsubscribed,
          expiresAt: i < owner.subscribedShops ? DateTime(2027, 1, 15) : null,
        ),
    ];
  }

  static List<OwnerActivity> _seedActivities(ShopOwner owner) {
    final OwnerActivity registered = OwnerActivity(
      title: 'Owner account registered via Owner App',
      actor: 'System',
      at: owner.registeredAt,
      hasTime: false,
    );
    if (owner.ownerId == 'OWN-10421') {
      return [
        OwnerActivity(
          title:
              'Subscription renewed (verified payment) · '
              'Kumar Construction Rentals',
          actor: 'System',
          at: DateTime(2026, 11, 22, 10, 44),
        ),
        OwnerActivity(
          title: 'Subscription expired · Kumar Construction – Aluva',
          actor: 'System',
          at: DateTime(2026, 11, 2, 9, 1),
        ),
        registered,
      ];
    }
    if (owner.status == OwnerStatus.restricted) {
      return [
        OwnerActivity(
          title: 'Account restricted · Repeated payment failures',
          actor: 'Meera Suresh',
          at: owner.registeredAt.add(const Duration(days: 60, hours: 11)),
        ),
        registered,
      ];
    }
    return [registered];
  }

  static List<ShopOwner> _seedOwners() => [
    ShopOwner(
      name: 'Abdul Salam',
      mobile: '+91 98950 70325',
      ownerId: 'OWN-10519',
      registeredAt: DateTime(2025, 4, 14),
      shops: 1,
      subscribedShops: 0,
      status: OwnerStatus.restricted,
    ),
    ShopOwner(
      name: 'Anil Kumar',
      mobile: '+91 98470 21456',
      ownerId: 'OWN-10421',
      registeredAt: DateTime(2025, 1, 12),
      shops: 3,
      subscribedShops: 1,
      status: OwnerStatus.active,
    ),
    ShopOwner(
      name: 'Deepa Krishnan',
      mobile: '+91 90480 17733',
      ownerId: 'OWN-10640',
      registeredAt: DateTime(2026, 2, 18),
      shops: 1,
      subscribedShops: 0,
      status: OwnerStatus.active,
    ),
    ShopOwner(
      name: 'Fathima Rasheed',
      mobile: '+91 94460 33718',
      ownerId: 'OWN-10433',
      registeredAt: DateTime(2025, 2, 3),
      shops: 1,
      subscribedShops: 1,
      status: OwnerStatus.active,
    ),
    ShopOwner(
      name: 'Haris Muhammed',
      mobile: '+91 97780 39264',
      ownerId: 'OWN-10611',
      registeredAt: DateTime(2025, 11, 22),
      shops: 2,
      subscribedShops: 1,
      status: OwnerStatus.active,
    ),
    ShopOwner(
      name: 'Joseph Mathew',
      mobile: '+91 99610 48203',
      ownerId: 'OWN-10458',
      registeredAt: DateTime(2025, 2, 21),
      shops: 1,
      subscribedShops: 1,
      status: OwnerStatus.active,
    ),
    ShopOwner(
      name: 'Sreeja Nair',
      mobile: '+91 98460 55120',
      ownerId: 'OWN-10402',
      registeredAt: DateTime(2024, 12, 9),
      shops: 2,
      subscribedShops: 2,
      status: OwnerStatus.active,
    ),
    ShopOwner(
      name: 'Manoj Chandran',
      mobile: '+91 90370 64412',
      ownerId: 'OWN-10668',
      registeredAt: DateTime(2026, 10, 6),
      shops: 1,
      subscribedShops: 0,
      status: OwnerStatus.active,
    ),
    ShopOwner(
      name: 'Nisha Thomas',
      mobile: '+91 94950 12876',
      ownerId: 'OWN-10587',
      registeredAt: DateTime(2025, 8, 30),
      shops: 1,
      subscribedShops: 1,
      status: OwnerStatus.active,
    ),
    ShopOwner(
      name: 'Vinod Pillai',
      mobile: '+91 97450 80931',
      ownerId: 'OWN-10495',
      registeredAt: DateTime(2025, 3, 27),
      shops: 1,
      subscribedShops: 1,
      status: OwnerStatus.active,
    ),
    ShopOwner(
      name: 'Rahul Menon',
      mobile: '+91 98950 44617',
      ownerId: 'OWN-10552',
      registeredAt: DateTime(2025, 4, 2),
      shops: 1,
      subscribedShops: 0,
      status: OwnerStatus.active,
    ),
    ShopOwner(
      name: 'Priya Varghese',
      mobile: '+91 96330 27584',
      ownerId: 'OWN-10626',
      registeredAt: DateTime(2026, 5, 4),
      shops: 1,
      subscribedShops: 1,
      status: OwnerStatus.active,
    ),
  ];
}
