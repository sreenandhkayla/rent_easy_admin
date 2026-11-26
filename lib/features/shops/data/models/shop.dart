import 'package:cloud_firestore/cloud_firestore.dart';

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
    this.parentShopId,
    this.plan,
    this.planId,
    this.planName,
    this.startedAt,
    this.expiresAt,
    this.lastPayment = PaymentStatus.none,
  });

  factory Shop.fromDocument(
    String id,
    Map<String, dynamic> data, {
    DateTime? now,
  }) {
    final DateTime? expiresAt = _date(data[subscriptionExpiresAtField]);
    return Shop(
      name: _text(data[nameField]) ?? '',
      shopId: id,
      ownerName: '',
      ownerId: _text(data[ownerIdField]) ?? '',
      location: _text(data[locationField]) ?? '',
      address: _text(data[addressField]) ?? '',
      contact: _text(data[phoneNumberField]) ?? '',
      subscription: subscriptionOf(
        data[subscriptionStatusField],
        expiresAt,
        now ?? DateTime.now(),
      ),
      status: data[isRestrictedField] == true
          ? ShopStatus.restricted
          : ShopStatus.active,
      registeredAt: _date(data[createdAtField]),
      parentShopId: _text(data[parentShopIdField]),
      planId: _text(data[planIdField]),
      expiresAt: expiresAt,
    );
  }

  static const String collection = 'shops';
  static const String nameField = 'name';
  static const String ownerIdField = 'ownerId';
  static const String locationField = 'location';
  static const String addressField = 'address';
  static const String phoneNumberField = 'phoneNumber';
  static const String createdAtField = 'createdAt';
  static const String planIdField = 'planId';
  static const String subscriptionStatusField = 'subscriptionStatus';
  static const String subscriptionExpiresAtField = 'subscriptionExpiresAt';
  static const String isRestrictedField = 'isRestricted';
  static const String parentShopIdField = 'parentShopId';
  static const String statusActive = 'active';
  static const String statusExpired = 'expired';
  static const String statusUnsubscribed = 'unsubscribed';
  static const Duration expiringSoonWindow = Duration(days: 7);

  final String name;
  final String shopId;
  final String ownerName;
  final String ownerId;
  final String location;
  final String address;
  final String contact;
  final SubscriptionStatus? subscription;
  final ShopStatus status;
  final DateTime? registeredAt;
  final String? branchOf;
  final String? parentShopId;
  final SubscriptionPlan? plan;
  final String? planId;
  final String? planName;
  final DateTime? startedAt;
  final DateTime? expiresAt;
  final PaymentStatus lastPayment;

  bool get isBranch => branchOf != null || parentShopId != null;

  String get city => location.split(',').last.trim();

  String? get planLabel => planName ?? plan?.label;

  static SubscriptionStatus? subscriptionOf(
    Object? status,
    DateTime? expiresAt,
    DateTime now,
  ) => switch (status) {
    statusActive
        when expiresAt != null &&
            !expiresAt.isAfter(now.add(expiringSoonWindow)) =>
      SubscriptionStatus.expiringSoon,
    statusActive => SubscriptionStatus.active,
    statusExpired => SubscriptionStatus.expired,
    statusUnsubscribed => SubscriptionStatus.unsubscribed,
    _ => null,
  };

  static String? _text(Object? value) {
    if (value is! String) return null;
    final String text = value.trim();
    return text.isEmpty ? null : text;
  }

  static DateTime? _date(Object? value) =>
      value is Timestamp ? value.toDate() : null;

  Shop copyWith({
    ShopStatus? status,
    SubscriptionStatus? subscription,
    SubscriptionPlan? plan,
    DateTime? startedAt,
    DateTime? expiresAt,
    PaymentStatus? lastPayment,
    String? ownerName,
    String? planName,
    String? branchOf,
  }) => Shop(
    name: name,
    shopId: shopId,
    ownerName: ownerName ?? this.ownerName,
    ownerId: ownerId,
    location: location,
    address: address,
    contact: contact,
    subscription: subscription ?? this.subscription,
    status: status ?? this.status,
    registeredAt: registeredAt,
    branchOf: branchOf ?? this.branchOf,
    parentShopId: parentShopId,
    plan: plan ?? this.plan,
    planId: planId,
    planName: planName ?? this.planName,
    startedAt: startedAt ?? this.startedAt,
    expiresAt: expiresAt ?? this.expiresAt,
    lastPayment: lastPayment ?? this.lastPayment,
  );
}
