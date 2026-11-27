import '../../utils/app_formatters.dart';

class DashboardStrings {
  DashboardStrings._();

  static const String title = 'Dashboard';
  static const String emptyValue = '—';

  static String countsLoadFailed(String reason) =>
      "Couldn't load shop and owner totals. $reason";
  static const String subtitle = 'Platform overview';

  static const String totalShops = 'Total Shops';
  static const String totalShopsCaption = 'Registered shops, incl. branches';
  static const String subscribedShops = 'Subscribed Shops';
  static const String subscribedShopsCaption =
      'Shops with an active entitlement';
  static const String totalShopOwners = 'Total Shop Owners';
  static const String totalShopOwnersCaption =
      'Unique registered owner accounts';
  static const String totalItems = 'Total Items';
  static const String totalItemsCaption =
      'Registered physical item units · aggregate only';
  static const String totalRentals = 'Total Rentals';
  static const String totalRentalsCaption =
      'Rental transactions, all time · aggregate only';
  static const String totalCustomers = 'Total Customers';
  static const String totalCustomersCaption =
      'Customer records across shops, not unique people';

  static const String subscriptionOverview = 'Subscription overview';
  static const String viewSubscriptions = 'View subscriptions';
  static const String activeSubscriptions = 'Active subscriptions';
  static const String activeSubscriptionsCaption = 'Not expiring within 7 days';
  static const String unsubscribedShops = 'Unsubscribed shops';
  static const String unsubscribedShopsCaption = 'Never subscribed';
  static const String expiringSoon = 'Expiring soon';
  static const String expiringSoonCaption = 'Within the next 7 days';
  static const String expiredSubscriptions = 'Expired subscriptions';
  static const String expiredSubscriptionsCaption = 'New rentals restricted';

  static const String pendingWork = 'Pending administrative work';
  static const String reportsAwaitingReview = 'Reports awaiting review';
  static const String shopsRequiringAttention = 'Shops requiring attention';
  static const String failedPayments = 'Failed subscription payments';
  static const String expiringSubscriptions = 'Expiring subscriptions';

  static const String recentActivity = 'Recent platform activity';
  static const String activityLog = 'Activity log';
  static const String verifiedRenewal = 'Verified renewal';
  static const String subscriptionActivated = 'Subscription activated';
  static const String branchRegistered = 'New branch registered';
  static const String subscriptionExpired = 'Subscription expired';
  static const String shopRestricted = 'Shop restricted';
  static const String ownerRegistered = 'New owner registered';

  static const String sampleDataNote =
      'Figures are prototype sample data from a simulated backend, computed '
      'from one shared source so Dashboard and Analytics always agree.';

  static String openCount(int count) => '${AppFormatters.number(count)} open';

  static String reportsDetail(int pending, int underReview) =>
      '$pending pending · $underReview under review';

  static String restrictedShopsDetail(int count) =>
      '$count restricted shops awaiting follow-up';

  static String failedPaymentsDetail(int thisMonth, int pendingVerification) =>
      '$thisMonth this month · $pendingVerification pending verification';

  static String expiringDetail(int count) =>
      '$count shops expire within 7 days';
}
