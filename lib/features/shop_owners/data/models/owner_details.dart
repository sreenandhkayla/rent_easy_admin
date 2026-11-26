import '../../../../core/enums/subscription_status.dart';
import 'shop_owner.dart';

class LinkedShop {
  const LinkedShop({
    required this.name,
    required this.shopId,
    required this.location,
    this.subscription,
    this.isBranch = false,
    this.plan,
    this.expiresAt,
  });

  factory LinkedShop.fromUserShop(Map<Object?, Object?> data) => LinkedShop(
    name: _text(data[nameField]) ?? '',
    shopId: _text(data[idField]) ?? '',
    location: _text(data[locationField]) ?? '',
  );

  static const String idField = 'id';
  static const String nameField = 'name';
  static const String locationField = 'location';

  final String name;
  final String shopId;
  final String location;
  final SubscriptionStatus? subscription;
  final bool isBranch;
  final String? plan;
  final DateTime? expiresAt;

  static List<LinkedShop> listFrom(Object? shops) => [
    if (shops is List)
      for (final Object? shop in shops)
        if (shop is Map) LinkedShop.fromUserShop(shop),
  ];

  static String? _text(Object? value) {
    if (value is! String) return null;
    final String text = value.trim();
    return text.isEmpty ? null : text;
  }
}

class OwnerActivity {
  const OwnerActivity({
    required this.title,
    required this.actor,
    required this.at,
    this.hasTime = true,
  });

  final String title;
  final String actor;
  final DateTime at;
  final bool hasTime;
}

class OwnerDetails {
  const OwnerDetails({
    required this.documentId,
    required this.owner,
    required this.shops,
    required this.activities,
  });

  final String documentId;
  final ShopOwner owner;
  final List<LinkedShop> shops;
  final List<OwnerActivity> activities;

  int? get unsubscribedOrExpired => switch (owner.subscribedShops) {
    final int subscribed => owner.shops - subscribed,
    null => null,
  };

  OwnerDetails copyWith({ShopOwner? owner}) => OwnerDetails(
    documentId: documentId,
    owner: owner ?? this.owner,
    shops: shops,
    activities: activities,
  );
}
