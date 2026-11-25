import '../../../../core/enums/subscription_status.dart';

enum ShopPlan { basic, professional, premium }

enum ShopStatus { active, restricted }

enum PaymentStatus { verified, pending, failed, none }

class Shop {
  const Shop({
    required this.name,
    required this.shopId,
    required this.ownerName,
    required this.ownerId,
    required this.location,
    required this.address,
    required this.contact,
    required this.subscription,
    required this.status,
    required this.registeredAt,
    this.branchOf,
    this.plan,
    this.startedAt,
    this.expiresAt,
    this.lastPayment = PaymentStatus.none,
  });

  final String name;
  final String shopId;
  final String ownerName;
  final String ownerId;
  final String location;
  final String address;
  final String contact;
  final SubscriptionStatus subscription;
  final ShopStatus status;
  final DateTime registeredAt;
  final String? branchOf;
  final ShopPlan? plan;
  final DateTime? startedAt;
  final DateTime? expiresAt;
  final PaymentStatus lastPayment;

  bool get isBranch => branchOf != null;

  String get city => location.split(',').last.trim();

  Shop copyWith({ShopStatus? status}) => Shop(
    name: name,
    shopId: shopId,
    ownerName: ownerName,
    ownerId: ownerId,
    location: location,
    address: address,
    contact: contact,
    subscription: subscription,
    status: status ?? this.status,
    registeredAt: registeredAt,
    branchOf: branchOf,
    plan: plan,
    startedAt: startedAt,
    expiresAt: expiresAt,
    lastPayment: lastPayment,
  );
}
