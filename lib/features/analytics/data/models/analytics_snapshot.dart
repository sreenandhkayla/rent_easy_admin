enum AnalyticsMetric {
  shopRegistrations,
  ownerRegistrations,
  activeSubscriptions,
  verifiedRevenue,
}

class AnalyticsPoint {
  const AnalyticsPoint({
    required this.period,
    required this.value,
    this.previousYear,
  });

  final DateTime period;
  final int value;
  final int? previousYear;
}

class AnalyticsShare {
  const AnalyticsShare({required this.label, required this.value});

  final String label;
  final int value;
}

class ShopStatusBreakdown {
  const ShopStatusBreakdown({
    required this.active,
    required this.inactive,
    required this.restricted,
  });

  final int active;
  final int inactive;
  final int restricted;

  int get total => active + inactive;
}

class SubscriptionFigures {
  const SubscriptionFigures({
    required this.renewals,
    required this.expiries,
    required this.expiringSoon,
    required this.paymentSuccessRate,
    required this.failedPayments,
    required this.multiShopOwners,
  });

  final int renewals;
  final int expiries;
  final int expiringSoon;
  final double paymentSuccessRate;
  final int failedPayments;
  final int multiShopOwners;
}

class AnalyticsSnapshot {
  const AnalyticsSnapshot({
    required this.totalItems,
    required this.totalRentals,
    required this.totalCustomers,
    required this.monthly,
    required this.yearly,
    required this.planShares,
    required this.shopStatus,
    required this.subscriptionFigures,
    required this.currentMonth,
  });

  final int totalItems;
  final int totalRentals;
  final int totalCustomers;
  final Map<AnalyticsMetric, List<AnalyticsPoint>> monthly;
  final Map<AnalyticsMetric, List<AnalyticsPoint>> yearly;
  final List<AnalyticsShare> planShares;
  final ShopStatusBreakdown shopStatus;
  final SubscriptionFigures subscriptionFigures;
  final DateTime currentMonth;

  int get planTotal => planShares.fold(0, (sum, share) => sum + share.value);
}
