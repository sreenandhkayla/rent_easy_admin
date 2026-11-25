import '../../../../core/enums/payment_status.dart';
import '../../../../core/enums/subscription_plan.dart';
import '../../../../core/enums/subscription_status.dart';

enum ShopStatus { active, restricted }

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
  final SubscriptionPlan? plan;
  final DateTime? startedAt;
  final DateTime? expiresAt;
  final PaymentStatus lastPayment;

  bool get isBranch => branchOf != null;

  String get city => location.split(',').last.trim();

  Shop copyWith({
    ShopStatus? status,
    SubscriptionStatus? subscription,
    SubscriptionPlan? plan,
    DateTime? startedAt,
    DateTime? expiresAt,
    PaymentStatus? lastPayment,
  }) => Shop(
    name: name,
    shopId: shopId,
    ownerName: ownerName,
    ownerId: ownerId,
    location: location,
    address: address,
    contact: contact,
    subscription: subscription ?? this.subscription,
    status: status ?? this.status,
    registeredAt: registeredAt,
    branchOf: branchOf,
    plan: plan ?? this.plan,
    startedAt: startedAt ?? this.startedAt,
    expiresAt: expiresAt ?? this.expiresAt,
    lastPayment: lastPayment ?? this.lastPayment,
  );
}
