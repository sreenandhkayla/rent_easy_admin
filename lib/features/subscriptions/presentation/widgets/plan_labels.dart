import '../../../../core/resources/strings/subscriptions_strings.dart';
import '../../data/models/plan_definition.dart';

class PlanLabels {
  PlanLabels._();

  static String perPeriod(PlanBillingPeriod period) => switch (period) {
    PlanBillingPeriod.month => SubscriptionsStrings.perMonth,
    PlanBillingPeriod.year => SubscriptionsStrings.perYear,
  };

  static String billingOption(PlanBillingPeriod period) => switch (period) {
    PlanBillingPeriod.month => SubscriptionsStrings.billingMonthly,
    PlanBillingPeriod.year => SubscriptionsStrings.billingYearly,
  };

  static String statusOption(PlanStatus status) => switch (status) {
    PlanStatus.active => SubscriptionsStrings.planStatusActive,
    PlanStatus.archived => SubscriptionsStrings.planStatusArchived,
  };
}
