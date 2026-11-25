import 'models/dashboard_summary.dart';

class DashboardMockData {
  DashboardMockData._();

  static DashboardSummary summary(DateTime updatedAt) {
    return DashboardSummary(
      totalShops: 1532,
      subscribedShops: 987,
      totalShopOwners: 1248,
      totalItems: 42860,
      totalRentals: 18450,
      totalCustomers: 24320,
      activeSubscriptions: 941,
      unsubscribedShops: 331,
      expiringSoon: 46,
      expiredSubscriptions: 214,
      reportsPending: 3,
      reportsUnderReview: 2,
      restrictedShops: 43,
      failedPaymentsThisMonth: 18,
      failedPaymentsPendingVerification: 12,
      updatedAt: updatedAt,
      activities: [
        ActivityEntry(
          type: ActivityType.verifiedRenewal,
          subject: 'Kumar Construction Rentals',
          detail: 'Professional plan · payment verified',
          date: DateTime(2026, 11, 22),
        ),
        ActivityEntry(
          type: ActivityType.subscriptionActivated,
          subject: 'Muhammed Machinery',
          detail: 'Premium plan · payment verified',
          date: DateTime(2026, 11, 22),
        ),
        ActivityEntry(
          type: ActivityType.branchRegistered,
          subject: 'Muhammed Machinery – Tirur',
          detail: 'Owner: Haris Muhammed · not yet subscribed',
          date: DateTime(2026, 11, 21),
        ),
        ActivityEntry(
          type: ActivityType.subscriptionExpired,
          subject: 'Chandran Auto Rentals',
          detail: 'Renewal payment failed · new rentals restricted',
          date: DateTime(2026, 11, 20),
        ),
        ActivityEntry(
          type: ActivityType.shopRestricted,
          subject: 'Salam Generators',
          detail: 'By Meera Suresh · reason recorded',
          date: DateTime(2026, 11, 17),
        ),
        ActivityEntry(
          type: ActivityType.ownerRegistered,
          subject: 'Manoj Chandran',
          detail: 'Owner ID OWN-10668',
          date: DateTime(2026, 10, 6),
        ),
      ],
    );
  }
}
