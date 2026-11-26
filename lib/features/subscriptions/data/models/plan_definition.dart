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
    required this.subscribedShops,
    required this.status,
    required this.updatedAt,
    this.limit,
  });

  final String id;
  final String name;
  final int price;
  final PlanBillingPeriod billingPeriod;
  final String description;
  final List<String> features;
  final int subscribedShops;
  final PlanStatus status;
  final DateTime updatedAt;
  final String? limit;

  bool get isArchived => status == PlanStatus.archived;

  List<String> get highlights {
    final String? value = limit;
    return [...features, if (value != null && !features.contains(value)) value];
  }

  PlanDefinition copyWith({PlanStatus? status, DateTime? updatedAt}) {
    return PlanDefinition(
      id: id,
      name: name,
      price: price,
      billingPeriod: billingPeriod,
      description: description,
      features: features,
      subscribedShops: subscribedShops,
      status: status ?? this.status,
      updatedAt: updatedAt ?? this.updatedAt,
      limit: limit,
    );
  }
}
