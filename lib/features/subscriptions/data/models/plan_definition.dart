import 'package:cloud_firestore/cloud_firestore.dart';

enum PlanBillingPeriod { month, year }

enum PlanStatus { active, archived }

class PlanDefinition {
  const PlanDefinition({
    required this.id,
    required this.name,
    required this.price,
    required this.billingPeriod,
    required this.description,
    required this.features,
    required this.status,
    this.subscribedShops,
    this.updatedAt,
    this.createdAt,
    this.limit,
    this.offerTag,
    this.offerPercentage = 0,
  });

  factory PlanDefinition.fromDocument(String id, Map<String, dynamic> data) {
    final Object? benefits = data[benefitsField];
    final Object? price = data[priceField];
    final Object? offer = data[offerPercentageField];
    return PlanDefinition(
      id: id,
      name: _text(data[nameField]) ?? '',
      price: price is num ? price.round() : 0,
      billingPeriod:
          PlanBillingPeriod.values.asNameMap()[data[billingPeriodField]] ??
          PlanBillingPeriod.month,
      description: _text(data[descriptionField]) ?? '',
      features: [
        if (benefits is List)
          for (final Object? item in benefits)
            if (_text(item) case final String benefit) benefit,
      ],
      status:
          PlanStatus.values.asNameMap()[data[statusField]] ?? PlanStatus.active,
      updatedAt: _date(data[updatedAtField]),
      createdAt: _date(data[createdAtField]),
      limit: _text(data[limitField]),
      offerTag: _text(data[offerTagField]),
      offerPercentage: offer is num ? offer.round() : 0,
    );
  }

  static const String collection = 'plans';
  static const String nameField = 'name';
  static const String descriptionField = 'description';
  static const String priceField = 'price';
  static const String billingPeriodField = 'billingPeriod';
  static const String benefitsField = 'benefits';
  static const String limitField = 'limit';
  static const String offerTagField = 'offerTag';
  static const String offerPercentageField = 'offerPercentage';
  static const String statusField = 'status';
  static const String createdAtField = 'createdAt';
  static const String updatedAtField = 'updatedAt';
  static const String archivedAtField = 'archivedAt';
  static const String createdByField = 'createdBy';
  static const String updatedByField = 'updatedBy';
  static const int maxOfferPercentage = 99;

  final String id;
  final String name;
  final int price;
  final PlanBillingPeriod billingPeriod;
  final String description;
  final List<String> features;
  final int? subscribedShops;
  final PlanStatus status;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final String? limit;
  final String? offerTag;
  final int offerPercentage;

  bool get isArchived => status == PlanStatus.archived;

  bool get hasDiscount => offerPercentage > 0;

  int get offerPrice => offerPriceFor(price, offerPercentage);

  static int offerPriceFor(int price, int offerPercentage) =>
      (price * (100 - offerPercentage) / 100).round();

  List<String> get highlights {
    final String? value = limit;
    return [...features, if (value != null && !features.contains(value)) value];
  }

  Map<String, Object?> toFields() => {
    nameField: name.trim(),
    descriptionField: description.trim(),
    priceField: price,
    billingPeriodField: billingPeriod.name,
    benefitsField: features,
    limitField: limit,
    offerTagField: offerTag,
    offerPercentageField: offerPercentage,
    statusField: status.name,
  };

  static String? _text(Object? value) {
    if (value is! String) return null;
    final String text = value.trim();
    return text.isEmpty ? null : text;
  }

  static DateTime? _date(Object? value) =>
      value is Timestamp ? value.toDate() : null;

  PlanDefinition copyWith({
    String? id,
    PlanStatus? status,
    DateTime? updatedAt,
    DateTime? createdAt,
  }) {
    return PlanDefinition(
      id: id ?? this.id,
      name: name,
      price: price,
      billingPeriod: billingPeriod,
      description: description,
      features: features,
      subscribedShops: subscribedShops,
      status: status ?? this.status,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      limit: limit,
      offerTag: offerTag,
      offerPercentage: offerPercentage,
    );
  }
}
