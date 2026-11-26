import '../../data/models/plan_definition.dart';

enum PlanFormStatus { loading, ready, notFound, failure }

class CreatePlanState {
  const CreatePlanState({
    required this.updatedAt,
    this.planId,
    this.formStatus = PlanFormStatus.ready,
    this.originalStatus,
    this.name = '',
    this.status = PlanStatus.active,
    this.description = '',
    this.price = '',
    this.billingPeriod = PlanBillingPeriod.month,
    this.benefits = '',
    this.limit = '',
    this.offerTag = '',
    this.offerPercentage = '',
    this.showErrors = false,
    this.isSaving = false,
    this.errorMessage,
  });

  factory CreatePlanState.fromPlan(PlanDefinition plan) => CreatePlanState(
    updatedAt: DateTime.now(),
    planId: plan.id,
    originalStatus: plan.status,
    name: plan.name,
    status: plan.status,
    description: plan.description,
    price: '${plan.price}',
    billingPeriod: plan.billingPeriod,
    benefits: plan.features.join('\n'),
    limit: plan.limit ?? '',
    offerTag: plan.offerTag ?? '',
    offerPercentage: plan.hasDiscount ? '${plan.offerPercentage}' : '',
  );

  final DateTime updatedAt;
  final String? planId;
  final PlanFormStatus formStatus;
  final PlanStatus? originalStatus;
  final String name;
  final PlanStatus status;
  final String description;
  final String price;
  final PlanBillingPeriod billingPeriod;
  final String benefits;
  final String limit;
  final String offerTag;
  final String offerPercentage;
  final bool showErrors;
  final bool isSaving;
  final String? errorMessage;

  bool get isEditing => planId != null;

  bool get isArchiving =>
      status == PlanStatus.archived && originalStatus != PlanStatus.archived;

  int? get priceValue => int.tryParse(price.trim());

  int get offerPercentageValue => int.tryParse(offerPercentage.trim()) ?? 0;

  int? get offerPriceValue {
    final int? value = priceValue;
    if (value == null || offerPercentageValue <= 0) return null;
    return PlanDefinition.offerPriceFor(value, offerPercentageValue);
  }

  List<String> get benefitLines => [
    for (final String line in benefits.split('\n'))
      if (line.trim().isNotEmpty) line.trim(),
  ];

  bool get isNameValid => name.trim().isNotEmpty;

  bool get isPriceValid => (priceValue ?? 0) > 0;

  bool get isOfferValid {
    final int percentage = offerPercentageValue;
    if (percentage < 0 || percentage > PlanDefinition.maxOfferPercentage) {
      return false;
    }
    final int? offerPrice = offerPriceValue;
    return offerPrice == null || offerPrice > 0;
  }

  bool get isValid => isNameValid && isPriceValid && isOfferValid;

  bool get showNameError => showErrors && !isNameValid;

  bool get showPriceError => showErrors && !isPriceValid;

  bool get showOfferError => showErrors && !isOfferValid;

  PlanDefinition toPlan() => PlanDefinition(
    id: planId ?? '',
    name: name.trim(),
    price: priceValue ?? 0,
    billingPeriod: billingPeriod,
    description: description.trim(),
    features: benefitLines,
    status: status,
    limit: limit.trim().isEmpty ? null : limit.trim(),
    offerTag: offerTag.trim().isEmpty ? null : offerTag.trim(),
    offerPercentage: offerPercentageValue,
  );

  CreatePlanState copyWith({
    DateTime? updatedAt,
    PlanFormStatus? formStatus,
    String? name,
    PlanStatus? status,
    String? description,
    String? price,
    PlanBillingPeriod? billingPeriod,
    String? benefits,
    String? limit,
    String? offerTag,
    String? offerPercentage,
    bool? showErrors,
    bool? isSaving,
    String? Function()? errorMessage,
  }) {
    return CreatePlanState(
      updatedAt: updatedAt ?? this.updatedAt,
      planId: planId,
      formStatus: formStatus ?? this.formStatus,
      originalStatus: originalStatus,
      name: name ?? this.name,
      status: status ?? this.status,
      description: description ?? this.description,
      price: price ?? this.price,
      billingPeriod: billingPeriod ?? this.billingPeriod,
      benefits: benefits ?? this.benefits,
      limit: limit ?? this.limit,
      offerTag: offerTag ?? this.offerTag,
      offerPercentage: offerPercentage ?? this.offerPercentage,
      showErrors: showErrors ?? this.showErrors,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: errorMessage == null ? this.errorMessage : errorMessage(),
    );
  }
}
