import '../../utils/app_formatters.dart';

class SubscriptionsStrings {
  SubscriptionsStrings._();

  static const String title = 'Subscriptions';
  static const String subtitle =
      'Plans, shop subscriptions and online subscription payments';

  static const String tabOverview = 'Overview';
  static const String tabShopSubscriptions = 'Shop subscriptions';
  static const String tabPlans = 'Plans';
  static const String tabPayments = 'Payments';
  static const String tabReconciliation = 'Reconciliation';
  static const List<String> tabs = [
    tabOverview,
    tabShopSubscriptions,
    tabPlans,
    tabPayments,
    tabReconciliation,
  ];

  static const String totalSubscribedShops = 'Total subscribed shops';
  static const String totalSubscribedShopsCaption =
      'Unique shops with active entitlement';
  static const String activeSubscriptions = 'Active subscriptions';
  static const String unsubscribedShops = 'Unsubscribed shops';
  static const String unsubscribedShopsCaption = 'No subscription yet';
  static const String expiringSoon = 'Expiring soon';
  static const String expiringSoonCaption = 'Within 7 days';
  static const String expiredSubscriptions = 'Expired subscriptions';
  static const String expiredSubscriptionsCaption = 'New rentals restricted';
  static const String pendingPayments = 'Pending payments';
  static const String pendingPaymentsCaption = 'Awaiting backend verification';
  static const String failedPayments = 'Failed payments';
  static const String failedPaymentsCaption = 'This month';
  static const String verifiedRevenueCaption = 'Verified payments only';

  static const String subscriptionRevenue = 'Subscription revenue';
  static const String subscriptionRevenueNote =
      'Revenue earned from verified subscription payments · pending and failed '
      'payments are not counted';
  static const String viewPayments = 'View payments';
  static const String verifiedPayments = 'Verified payments';
  static const String totalRevenueEarned = 'Total revenue earned';
  static const String allTimeCaption = 'All time, since launch';
  static const String monthlyRevenue = 'Monthly revenue';
  static const String monthlyRevenueNote = 'Last 6 months · ₹ lakh';
  static const String averageRevenuePerShop =
      'Average revenue per subscribed shop';
  static const String notCounted = 'Not counted (pending · failed)';

  static const String subscriptionRules = 'Subscription rules';
  static const String ruleEntitlementTitle = 'One entitlement per shop';
  static const String ruleEntitlementBody =
      'An owner with several shops subscribes each shop separately.';
  static const String ruleVerifiedTitle = 'Activated by verified payment only';
  static const String ruleVerifiedBody =
      'Reaching a payment-success page never activates access. Duplicate '
      'callbacks are ignored.';
  static const String ruleExpiryTitle = 'Expiry restricts new rentals';
  static const String ruleExpiryBody =
      'Existing items, rentals, customers and records remain viewable.';
  static const String ruleReturnsTitle = 'Returns after expiry';
  static const String ruleReturnsBody =
      'Recommended: let owners receive items back and record dues after '
      'expiry. Not enforced until approved.';
  static const String needsApproval = 'Needs approval';

  static const String renewalFlow = 'Renewal flow';
  static const String renewalNoticeTitle = 'Expiry notice sent';
  static const String renewalNoticeBody =
      'Owner App and push notification, 7 days before expiry';
  static const String renewalPlanTitle = 'Owner selects an eligible plan';
  static const String renewalPlanBody = 'From Renewal in the Owner App';
  static const String renewalPaymentTitle = 'Online payment';
  static const String renewalPaymentBody =
      'States: pending · failed · verified';
  static const String renewalVerifyTitle = 'Backend verifies the transaction';
  static const String renewalVerifyBody =
      'Provider confirmation required; idempotent';
  static const String renewalValidityTitle =
      'Validity updated · Admin counts refresh';
  static const String renewalValidityBody =
      'New rental creation becomes available';

  static const String statusAll = 'All';
  static const String searchHint = 'Search shop or owner';
  static const String anyExpiryDate = 'Any expiry date';
  static const String expiresIn7Days = 'Expires in 7 days';
  static const String expiresIn30Days = 'Expires in 30 days';
  static const String alreadyExpired = 'Already expired';
  static const String shopName = 'Shop name';
  static const String owner = 'Owner';
  static const String plan = 'Plan';
  static const String startDate = 'Start date';
  static const String expiryDate = 'Expiry date';
  static const String status = 'Status';
  static const String payment = 'Payment';
  static const String emptyValue = '—';
  static const String noMatchesTitle = 'No matching subscriptions';
  static const String noMatchesMessage =
      'Try a different shop or owner, or clear the filters.';

  static String shopsShown(int shown) =>
      '$shown sample shops shown · platform totals on the Overview tab';

  static const String detailsSubtitle = 'Subscription details';
  static const String subscriptionNotFound = 'Subscription not found';
  static const String subscriptionNotFoundMessage =
      'This shop subscription does not exist or is no longer available.';
  static const String backToShopSubscriptions = 'Back to Shop subscriptions';
  static const String noPlan = 'No plan';
  static const String paymentStatus = 'Payment status';
  static const String newRentalCreation = 'New rental creation';
  static const String existingRecords = 'Existing records';
  static const String allowed = 'Allowed';
  static const String restricted = 'Restricted';
  static const String blockedShopRestricted = 'Blocked — shop restricted';
  static const String viewable = 'Viewable';

  static const String expiredTitle = 'Subscription expired.';
  static const String expiredMessage =
      'New rental creation is restricted. Existing records stay viewable. '
      'Renewal restores access after verification.';
  static const String expiringTitle = 'Expiring soon.';
  static const String expiringNotice =
      'An expiry notice has been sent to the owner.';
  static const String expiringPending =
      'A renewal payment is awaiting verification.';
  static const String noSubscriptionTitle = 'No subscription.';
  static const String noSubscriptionMessage =
      'This shop has never subscribed. New rental creation needs an active '
      'subscription.';

  static const String paymentsAndAttempts = 'Verified payments & attempts';
  static const String transaction = 'Transaction';
  static const String date = 'Date';
  static const String amount = 'Amount';
  static const String verification = 'Verification';
  static const String successful = 'Successful';
  static const String pending = 'Pending';
  static const String failed = 'Failed';
  static const String verified = 'Verified';
  static const String awaitingVerification = 'Awaiting verification';
  static const String notVerified = 'Not verified';
  static const String noAttempts = 'No payment attempts yet.';
  static const String transactionDetails = 'Transaction details';

  static const String actions = 'Actions';
  static const String viewShop = 'View shop';
  static const String viewOwner = 'View owner';
  static const String renewalFlowTitle = 'Flow E · Owner App renewal';
  static const String renewalFlowNote =
      'Prototype simulation of a verified payment callback from the backend. '
      'It updates this shop and the Dashboard counts locally — no real '
      'payment is processed.';
  static const String simulateRenewal = 'Simulate verified renewal';
  static const String billingNote =
      'Plan changes and cancellation are not available until billing rules '
      'are approved.';

  static const String renewalHistory = 'Renewal history';
  static const String historyExpired = 'Subscription expired';
  static const String historyExpiredDetail = 'new rentals restricted';
  static const String historyFailed = 'Renewal payment failed';
  static const String historyPending = 'Renewal payment pending';
  static const String noRenewalHistory = 'No renewals recorded yet.';

  static String planTitle(String plan) => '$plan plan';
  static String shopLine(String name, String shopId) => '$name · $shopId';
  static String expiresOn(String date) => 'Expires $date.';
  static String historyVerified(String plan) => '$plan · verified payment';
  static String historyLine(String when, String amount) => '$when · $amount';
  static String renewedSnack(String name, String date) =>
      'Renewal verified. $name is active until $date.';

  static const String planDistribution = 'Plan distribution';
  static const String managePlans = 'Manage plans';

  static String excludesExpiring(int count) => 'Excludes $count expiring soon';

  static String verifiedRevenue(DateTime month) =>
      'Verified revenue · ${AppFormatters.monthShort(month)}';

  static String thisMonth(DateTime month) =>
      'This month · ${AppFormatters.monthShort(month)}';

  static String lastMonth(DateTime month) =>
      'Last month · ${AppFormatters.monthShort(month)}';

  static String thisYear(DateTime month) => 'This year · ${month.year}';

  static String yearRange(DateTime month) =>
      'Jan – ${AppFormatters.monthShort(month)}';

  static String changeVs(double change, DateTime previous) =>
      '${change >= 0 ? '+' : ''}${(change * 100).toStringAsFixed(1)}% vs '
      '${AppFormatters.monthShort(previous)}';

  static String revenueByPlan(DateTime month) =>
      'Revenue by plan · ${AppFormatters.monthShort(month)}';

  static String amountAndShare(String amount, String share) =>
      '$amount · $share';

  static String shopsAndShare(int shops, String share) =>
      '$shops shops · $share';

  static String paymentCounts(int pending, int failed) =>
      '$pending · $failed payments';

  static String barTooltip(DateTime month, String amount) =>
      '${AppFormatters.monthShort(month)} ${month.year} · $amount';
}
