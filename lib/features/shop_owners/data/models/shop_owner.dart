import 'package:cloud_firestore/cloud_firestore.dart';

enum OwnerStatus { active, restricted, deleted }

class ShopOwner {
  const ShopOwner({
    required this.name,
    required this.mobile,
    required this.ownerId,
    required this.registeredAt,
    required this.shops,
    required this.subscribedShops,
    required this.status,
  });

  factory ShopOwner.fromDocument(String id, Map<String, dynamic> data) {
    final Object? createdAt = data[createdAtField];
    final Object? shops = data[shopsField];
    return ShopOwner(
      name: _text(data[nameField]) ?? '',
      mobile: _text(data[phoneField]) ?? '',
      ownerId: _text(data[userIdField]) ?? id,
      registeredAt: createdAt is Timestamp ? createdAt.toDate() : null,
      shops: shops is List ? shops.length : 0,
      subscribedShops: _subscribedCount(data[subscribedField]),
      status: statusOf(data),
    );
  }

  static const String userIdField = 'userId';
  static const String nameField = 'name';
  static const String phoneField = 'phone';
  static const String createdAtField = 'createdAt';
  static const String shopsField = 'shops';
  static const String subscribedField = 'subscribed';
  static const String isDeletedField = 'isDeleted';
  static const String isAccountBlockedField = 'isAccountBlocked';

  final String name;
  final String mobile;
  final String ownerId;
  final DateTime? registeredAt;
  final int shops;
  final int? subscribedShops;
  final OwnerStatus status;

  static OwnerStatus statusOf(Map<String, dynamic> data) {
    if (data[isDeletedField] == true) return OwnerStatus.deleted;
    if (data[isAccountBlockedField] == true) return OwnerStatus.restricted;
    return OwnerStatus.active;
  }

  static int? _subscribedCount(Object? value) => switch (value) {
    final num count => count.toInt(),
    final List<Object?> items => items.length,
    _ => null,
  };

  static String? _text(Object? value) {
    if (value is! String) return null;
    final String text = value.trim();
    return text.isEmpty ? null : text;
  }

  ShopOwner copyWith({OwnerStatus? status}) => ShopOwner(
    name: name,
    mobile: mobile,
    ownerId: ownerId,
    registeredAt: registeredAt,
    shops: shops,
    subscribedShops: subscribedShops,
    status: status ?? this.status,
  );
}
