import '../../../core/enums/subscription_status.dart';
import 'models/shop.dart';
import 'models/shop_details.dart';

class ShopsMockData {
  ShopsMockData._();

  static const int totalOnPlatform = 1532;

  static final List<Shop> _shops = _seedShops();
  static final Map<String, List<ShopActivity>> _activities = {};

  static List<Shop> shops() => List.of(_shops);

  static ShopDetails? details(String shopId) {
    final int index = _shops.indexWhere((shop) => shop.shopId == shopId);
    if (index < 0) return null;
    final Shop shop = _shops[index];
    final String family = shop.branchOf ?? shop.name;
    return ShopDetails(
      shop: shop,
      relatedBranches: _shops
          .where(
            (other) =>
                other.shopId != shop.shopId &&
                other.ownerId == shop.ownerId &&
                (other.name == family || other.branchOf == family),
          )
          .toList(),
      activities: List.of(
        _activities.putIfAbsent(shopId, () => _seedActivities(shop)),
      ),
    );
  }

  static void updateStatus(
    String shopId,
    ShopStatus status,
    ShopActivity activity,
  ) {
    final int index = _shops.indexWhere((shop) => shop.shopId == shopId);
    if (index < 0) return;
    _shops[index] = _shops[index].copyWith(status: status);
    _activities
        .putIfAbsent(shopId, () => _seedActivities(_shops[index]))
        .insert(0, activity);
  }

  static List<ShopActivity> _seedActivities(Shop shop) {
    final ShopActivity registered = ShopActivity(
      title: 'Shop registered via Owner App',
      actor: 'System',
      at: shop.registeredAt,
      hasTime: false,
    );
    final DateTime? expiresAt = shop.expiresAt;
    return [
      if (shop.shopId == 'SHP-2009')
        ShopActivity(
          title: 'Restricted shop',
          actor: 'Meera Suresh',
          at: DateTime(2026, 11, 17, 12, 8),
          reason: 'Repeated safety complaints under review',
          isHighlighted: true,
        )
      else if (shop.status == ShopStatus.restricted)
        ShopActivity(
          title: 'Restricted shop',
          actor: 'Meera Suresh',
          at: shop.registeredAt.add(const Duration(days: 45, hours: 10)),
          reason: 'Pending document verification',
          isHighlighted: true,
        ),
      if (shop.subscription == SubscriptionStatus.expired && expiresAt != null)
        ShopActivity(
          title: 'Subscription expired',
          actor: 'System',
          at: DateTime(expiresAt.year, expiresAt.month, expiresAt.day, 9, 1),
        ),
      registered,
    ];
  }

  static List<Shop> _seedShops() => [
    Shop(
      name: 'Chandran Auto Rentals',
      shopId: 'SHP-2016',
      ownerName: 'Manoj Chandran',
      ownerId: 'OWN-10668',
      location: 'Vyttila, Kochi',
      address: 'Building 4, Vyttila, Kochi, Kerala',
      contact: '+91 484 2301 5520',
      plan: ShopPlan.basic,
      subscription: SubscriptionStatus.expired,
      startedAt: DateTime(2026, 10, 20),
      expiresAt: DateTime(2026, 11, 20),
      lastPayment: PaymentStatus.failed,
      status: ShopStatus.active,
      registeredAt: DateTime(2026, 10, 6),
    ),
    Shop(
      name: 'Krishnan Decor Studio',
      shopId: 'SHP-2015',
      ownerName: 'Deepa Krishnan',
      ownerId: 'OWN-10640',
      location: 'Sultanpet, Palakkad',
      address: 'Building 22, Sultanpet, Palakkad, Kerala',
      contact: '+91 491 2504 1187',
      subscription: SubscriptionStatus.unsubscribed,
      status: ShopStatus.active,
      registeredAt: DateTime(2026, 2, 18),
    ),
    Shop(
      name: 'Kumar Construction – Aluva',
      shopId: 'SHP-2002',
      ownerName: 'Anil Kumar',
      ownerId: 'OWN-10421',
      location: 'Aluva, Kochi',
      address: 'Building 15, Aluva, Kochi, Kerala',
      contact: '+91 485 2317 4137',
      branchOf: 'Kumar Construction Rentals',
      plan: ShopPlan.basic,
      subscription: SubscriptionStatus.expired,
      startedAt: DateTime(2026, 10, 2),
      expiresAt: DateTime(2026, 11, 2),
      lastPayment: PaymentStatus.failed,
      status: ShopStatus.active,
      registeredAt: DateTime(2025, 8, 8),
    ),
    Shop(
      name: 'Kumar Construction Rentals',
      shopId: 'SHP-2001',
      ownerName: 'Anil Kumar',
      ownerId: 'OWN-10421',
      location: 'Edappally, Kochi',
      address: 'Building 8, Edappally, Kochi, Kerala',
      contact: '+91 484 2340 9921',
      plan: ShopPlan.professional,
      subscription: SubscriptionStatus.active,
      startedAt: DateTime(2026, 11, 22),
      expiresAt: DateTime(2026, 12, 22),
      lastPayment: PaymentStatus.verified,
      status: ShopStatus.active,
      registeredAt: DateTime(2025, 1, 12),
    ),
    Shop(
      name: 'Kumar Event Hire',
      shopId: 'SHP-2003',
      ownerName: 'Anil Kumar',
      ownerId: 'OWN-10421',
      location: 'Kakkanad, Kochi',
      address: 'Building 31, Kakkanad, Kochi, Kerala',
      contact: '+91 484 2425 6610',
      subscription: SubscriptionStatus.unsubscribed,
      status: ShopStatus.active,
      registeredAt: DateTime(2025, 9, 15),
    ),
    Shop(
      name: 'Mathew Machinery Hire',
      shopId: 'SHP-2005',
      ownerName: 'Joseph Mathew',
      ownerId: 'OWN-10458',
      location: 'Nagampadam, Kottayam',
      address: 'Building 12, Nagampadam, Kottayam, Kerala',
      contact: '+91 481 2563 0042',
      plan: ShopPlan.professional,
      subscription: SubscriptionStatus.expiringSoon,
      startedAt: DateTime(2026, 10, 29),
      expiresAt: DateTime(2026, 11, 29),
      lastPayment: PaymentStatus.verified,
      status: ShopStatus.active,
      registeredAt: DateTime(2025, 2, 21),
    ),
    Shop(
      name: 'Menon Car Rentals',
      shopId: 'SHP-2008',
      ownerName: 'Rahul Menon',
      ownerId: 'OWN-10552',
      location: 'Palarivattom, Kochi',
      address: 'Building 19, Palarivattom, Kochi, Kerala',
      contact: '+91 484 2338 7714',
      plan: ShopPlan.professional,
      subscription: SubscriptionStatus.expired,
      startedAt: DateTime(2026, 10, 15),
      expiresAt: DateTime(2026, 11, 15),
      lastPayment: PaymentStatus.pending,
      status: ShopStatus.active,
      registeredAt: DateTime(2025, 4, 2),
    ),
    Shop(
      name: 'Muhammed Machinery',
      shopId: 'SHP-2013',
      ownerName: 'Haris Muhammed',
      ownerId: 'OWN-10611',
      location: 'Kunnummal, Malappuram',
      address: 'Building 5, Kunnummal, Malappuram, Kerala',
      contact: '+91 483 2734 2205',
      plan: ShopPlan.premium,
      subscription: SubscriptionStatus.active,
      startedAt: DateTime(2026, 11, 22),
      expiresAt: DateTime(2027, 11, 22),
      lastPayment: PaymentStatus.verified,
      status: ShopStatus.active,
      registeredAt: DateTime(2025, 11, 22),
    ),
    Shop(
      name: 'Muhammed Machinery – Tirur',
      shopId: 'SHP-2014',
      ownerName: 'Haris Muhammed',
      ownerId: 'OWN-10611',
      location: 'Tirur, Malappuram',
      address: 'Building 27, Tirur, Malappuram, Kerala',
      contact: '+91 494 2422 8135',
      branchOf: 'Muhammed Machinery',
      subscription: SubscriptionStatus.unsubscribed,
      status: ShopStatus.active,
      registeredAt: DateTime(2026, 11, 21),
    ),
    Shop(
      name: 'Rasheed Party Supplies',
      shopId: 'SHP-2006',
      ownerName: 'Fathima Rasheed',
      ownerId: 'OWN-10433',
      location: 'Mavoor Road, Kozhikode',
      address: 'Building 9, Mavoor Road, Kozhikode, Kerala',
      contact: '+91 495 2721 4408',
      plan: ShopPlan.basic,
      subscription: SubscriptionStatus.active,
      startedAt: DateTime(2026, 11, 3),
      expiresAt: DateTime(2027, 2, 3),
      lastPayment: PaymentStatus.verified,
      status: ShopStatus.active,
      registeredAt: DateTime(2025, 2, 3),
    ),
    Shop(
      name: 'Raghunath Tools',
      shopId: 'SHP-2004',
      ownerName: 'Kumar Raghunath',
      ownerId: 'OWN-10402',
      location: 'Thampanoor, Thiruvananthapuram',
      address: 'Building 3, Thampanoor, Thiruvananthapuram, Kerala',
      contact: '+91 471 2330 9187',
      plan: ShopPlan.professional,
      subscription: SubscriptionStatus.active,
      startedAt: DateTime(2026, 9, 9),
      expiresAt: DateTime(2027, 3, 9),
      lastPayment: PaymentStatus.verified,
      status: ShopStatus.active,
      registeredAt: DateTime(2024, 12, 9),
    ),
    Shop(
      name: 'Raghunath Tools – Kollam',
      shopId: 'SHP-2010',
      ownerName: 'Kumar Raghunath',
      ownerId: 'OWN-10402',
      location: 'Chinnakada, Kollam',
      address: 'Building 41, Chinnakada, Kollam, Kerala',
      contact: '+91 474 2746 3352',
      branchOf: 'Raghunath Tools',
      plan: ShopPlan.basic,
      subscription: SubscriptionStatus.expiringSoon,
      startedAt: DateTime(2026, 10, 30),
      expiresAt: DateTime(2026, 11, 30),
      lastPayment: PaymentStatus.verified,
      status: ShopStatus.active,
      registeredAt: DateTime(2025, 7, 19),
    ),
    Shop(
      name: 'Salam Generators',
      shopId: 'SHP-2009',
      ownerName: 'Abdul Salam',
      ownerId: 'OWN-10519',
      location: 'Chinnakada, Kollam',
      address: 'Building 36, Chinnakada, Kollam, Kerala',
      contact: '+91 492 2366 4396',
      subscription: SubscriptionStatus.unsubscribed,
      status: ShopStatus.restricted,
      registeredAt: DateTime(2025, 4, 15),
    ),
    Shop(
      name: 'Suresh Audio Rentals',
      shopId: 'SHP-2011',
      ownerName: 'Meera Suresh',
      ownerId: 'OWN-10587',
      location: 'Round North, Thrissur',
      address: 'Building 14, Round North, Thrissur, Kerala',
      contact: '+91 487 2421 6639',
      plan: ShopPlan.premium,
      subscription: SubscriptionStatus.active,
      startedAt: DateTime(2026, 8, 30),
      expiresAt: DateTime(2027, 8, 30),
      lastPayment: PaymentStatus.verified,
      status: ShopStatus.active,
      registeredAt: DateTime(2025, 8, 30),
    ),
    Shop(
      name: 'Ashraf Equipment Hub',
      shopId: 'SHP-2007',
      ownerName: 'Muhammed Ashraf',
      ownerId: 'OWN-10495',
      location: 'Kaloor, Kochi',
      address: 'Building 2, Kaloor, Kochi, Kerala',
      contact: '+91 484 2402 7741',
      plan: ShopPlan.premium,
      subscription: SubscriptionStatus.active,
      startedAt: DateTime(2026, 3, 27),
      expiresAt: DateTime(2027, 3, 27),
      lastPayment: PaymentStatus.verified,
      status: ShopStatus.active,
      registeredAt: DateTime(2025, 3, 27),
    ),
    Shop(
      name: 'Koya Lights & Sound',
      shopId: 'SHP-2012',
      ownerName: 'Salam Koya',
      ownerId: 'OWN-10626',
      location: 'Beach Road, Kozhikode',
      address: 'Building 18, Beach Road, Kozhikode, Kerala',
      contact: '+91 495 2366 1029',
      subscription: SubscriptionStatus.unsubscribed,
      status: ShopStatus.restricted,
      registeredAt: DateTime(2026, 5, 4),
    ),
  ];
}
