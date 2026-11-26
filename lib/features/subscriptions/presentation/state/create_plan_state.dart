import '../../data/models/plan_definition.dart';

class CreatePlanState {
  const CreatePlanState({
    required this.updatedAt,
    this.name = '',
    this.status = PlanStatus.active,
    this.description = '',
    this.price = '',
    this.billingPeriod = PlanBillingPeriod.month,
    this.benefits = '',
    this.limit = '',
    this.showErrors = false,
    this.isSaving = false,
  });

  final DateTime updatedAt;
  final String name;
  final PlanStatus status;
  final String description;
  final String price;
  final PlanBillingPeriod billingPeriod;
  final String benefits;
  final String limit;
  final bool showErrors;
  final bool isSaving;

  int? get priceValue => int.tryParse(price.trim());

  List<String> get benefitLines => [
    for (final String line in benefits.split('\n'))
      if (line.trim().isNotEmpty) line.trim(),
  ];

  bool get isNameValid => name.trim().isNotEmpty;

  bool get isPriceValid => (priceValue ?? 0) > 0;

  bool get isValid => isNameValid && isPriceValid;

  bool get showNameError => showErrors && !isNameValid;

  bool get showPriceError => showErrors && !isPriceValid;

  PlanDefinition toPlan(String id, DateTime now) => PlanDefinition(
    id: id,
    name: name.trim(),
    price: priceValue ?? 0,
    billingPeriod: billingPeriod,
    description: description.trim(),
    features: benefitLines,
    subscribedShops: 0,
    status: status,
    updatedAt: now,
    limit: limit.trim().isEmpty ? null : limit.trim(),
  );

  CreatePlanState copyWith({
    DateTime? updatedAt,
    String? name,
    PlanStatus? status,
    String? description,
    String? price,
    PlanBillingPeriod? billingPeriod,
    String? benefits,
    String? limit,
    bool? showErrors,
    bool? isSaving,
  }) {
    return CreatePlanState(
      updatedAt: updatedAt ?? this.updatedAt,
      name: name ?? this.name,
      status: status ?? this.status,
      description: description ?? this.description,
      price: price ?? this.price,
      billingPeriod: billingPeriod ?? this.billingPeriod,
      benefits: benefits ?? this.benefits,
      limit: limit ?? this.limit,
      showErrors: showErrors ?? this.showErrors,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}
