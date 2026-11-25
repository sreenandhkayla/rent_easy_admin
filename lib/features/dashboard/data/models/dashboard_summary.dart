enum ActivityType {
  verifiedRenewal,
  subscriptionActivated,
  branchRegistered,
  subscriptionExpired,
  shopRestricted,
  ownerRegistered,
}

class ActivityEntry {
  const ActivityEntry({
    required this.type,
    required this.subject,
    required this.detail,
    required this.date,
  });

  final ActivityType type;
  final String subject;
  final String detail;
  final DateTime date;
}

class DashboardSummary {
  const DashboardSummary({
    required this.totalShops,
    required this.subscribedShops,
    required this.totalShopOwners,
    required this.totalItems,
    required this.totalRentals,
    required this.totalCustomers,
    required this.activeSubscriptions,
    required this.unsubscribedShops,
    required this.expiringSoon,
    required this.expiredSubscriptions,
    required this.reportsPending,
    required this.reportsUnderReview,
    required this.restrictedShops,
    required this.failedPaymentsThisMonth,
    required this.failedPaymentsPendingVerification,
    required this.activities,
    required this.updatedAt,
  });

  final int totalShops;
  final int subscribedShops;
  final int totalShopOwners;
  final int totalItems;
  final int totalRentals;
  final int totalCustomers;
  final int activeSubscriptions;
  final int unsubscribedShops;
  final int expiringSoon;
  final int expiredSubscriptions;
  final int reportsPending;
  final int reportsUnderReview;
  final int restrictedShops;
  final int failedPaymentsThisMonth;
  final int failedPaymentsPendingVerification;
  final List<ActivityEntry> activities;
  final DateTime updatedAt;

  int get pendingWorkOpen =>
      reportsPending +
      reportsUnderReview +
      restrictedShops +
      failedPaymentsThisMonth +
      expiringSoon;
}
