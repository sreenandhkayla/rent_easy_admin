import '../resources/strings/app_strings.dart';

enum SubscriptionPlan {
  basic(AppStrings.planBasic),
  professional(AppStrings.planProfessional),
  premium(AppStrings.planPremium);

  const SubscriptionPlan(this.label);

  final String label;
}

enum PlanFilter {
  all(AppStrings.allPlans, null),
  basic(AppStrings.planBasic, SubscriptionPlan.basic),
  professional(AppStrings.planProfessional, SubscriptionPlan.professional),
  premium(AppStrings.planPremium, SubscriptionPlan.premium);

  const PlanFilter(this.label, this.plan);

  final String label;
  final SubscriptionPlan? plan;

  bool matches(SubscriptionPlan? value) => plan == null || plan == value;
}
