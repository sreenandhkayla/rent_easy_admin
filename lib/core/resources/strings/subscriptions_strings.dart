import '../../utils/app_formatters.dart';
import 'app_strings.dart';

class SubscriptionsStrings {
  SubscriptionsStrings._();

  static const String managePlansDeniedTitle = "You can't manage plans";
  static const String managePlansDenied =
      "Your role can view plans but can't create, edit or archive them. Ask "
      'a Super Admin to change this in Settings > Roles & permissions.';

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

  static const String paymentSearchHint = 'Search transaction ID or shop';
  static const String transactionId = 'Transaction ID';
  static const String shop = 'Shop';
  static const String paymentDate = 'Payment date';
  static const String noPaymentsTitle = 'No matching payments';
  static const String noPaymentsMessage =
      'Try a different transaction ID or shop, or clear the filter.';

  static String paymentsShown(int shown) =>
      '$shown recent sample transaction${shown == 1 ? '' : 's'}';

  static const String paymentDetailsSubtitle = 'Payment details';
  static const String paymentNotFound = 'Payment not found';
  static const String paymentNotFoundMessage =
      'This payment does not exist or is no longer available.';
  static const String backToPayments = 'Back to Payments';
  static const String paymentVerifiedTitle = 'Payment verified by the backend.';
  static const String paymentVerifiedMessage =
      'The subscription entitlement was activated from this confirmation.';
  static const String paymentPendingTitle = 'Payment pending.';
  static const String paymentPendingMessage =
      'Waiting for provider confirmation. The subscription is not activated '
      'yet — a payment-success screen alone never activates access.';
  static const String paymentFailedTitle = 'Payment failed.';
  static const String defaultFailureReason =
      'The provider did not confirm the payment';

  static String paymentFailedMessage(String reason) =>
      '$reason. No entitlement was created.';
  static const String providerReference = 'Provider reference';
  static const String invoiceReference = 'Invoice / receipt reference';
  static const String reconciliation = 'Reconciliation';
  static const String refundStatus = 'Refund status';
  static const String matched = 'Matched';
  static const String unmatched = 'Unmatched';
  static const String refunds = 'Refunds';
  static const String matchedCaption = 'Provider settlement agrees';
  static const String unmatchedCaption = 'Needs admin review';
  static const String pendingSettlementCaption = 'Awaiting settlement file';
  static const String refundsCaption = 'No refund rules approved yet';
  static const String reconciliationTableTitle =
      'Reconciliation · sample transactions';
  static const String reconciliationTableNote =
      'Settlement matching shown for the prototype only';
  static const String providerRefShort = 'Provider ref.';
  static const String review = 'Review';
  static const String noReconciliationTitle = 'Nothing to reconcile';
  static const String noReconciliationMessage =
      'Verified and pending payments appear here for settlement matching.';
  static const String notApplicable = 'Not applicable';
  static const String verificationTimeline = 'Verification timeline';
  static const String timelineInitiated = 'Payment initiated in Owner App';
  static const String timelineProviderConfirmed = 'Provider confirmed';
  static const String timelineBackendVerified =
      'Backend verified signature & amount';
  static const String timelineIdempotent =
      'Idempotent — duplicate callbacks ignored';
  static const String timelineEntitlementUpdated = 'Entitlement updated';
  static const String timelineProviderAwaited = 'Provider response awaited';
  static const String timelineBackendVerification = 'Backend verification';
  static const String timelineNotStarted = 'Not started';
  static const String timelineEntitlementUpdate = 'Entitlement update';
  static const String timelineWaitingVerification = 'Waiting for verification';
  static const String timelineProviderReturnedFailure =
      'Provider returned failure';
  static const String timelineEntitlementUnchanged = 'Entitlement unchanged';
  static const String timelineOwnerRetry = 'Owner prompted to retry';
  static const String viewShopSubscription = 'View shop subscription';
  static const String receipt = 'Receipt';
  static const String receiptNote = 'Generated from the verified payment';
  static const String receiptTitle =
      '${AppStrings.appName} subscription receipt';
  static const String billedTo = 'Billed to';
  static const String paidOn = 'Paid on';
  static const String total = 'Total';

  static String providerRef(String reference) => 'Ref $reference';
  static String receiptRef(String invoice) => 'Receipt $invoice';

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

  static const String plansNotice =
      'Sample plans and prices for the prototype — not approved commercial '
      'terms. Upgrades, downgrades, proration and refunds need approved '
      'billing rules.';
  static const String createPlan = 'Create plan';
  static const String planActive = 'Active';
  static const String planArchived = 'Archived';
  static const String perMonth = '/ month';
  static const String perYear = '/ year';
  static const String subscribedShops = 'Subscribed shops';
  static const String viewDetails = 'View details';
  static const String edit = 'Edit';
  static const String planDetails = 'Plan details';
  static const String createPlanSubtitle = 'Configure a subscription plan';
  static const String planNameLabel = 'Plan name *';
  static const String planNameHint = 'e.g. Professional';
  static const String planStatusLabel = 'Plan status';
  static const String planStatusActive = 'Active — available to owners';
  static const String planStatusArchived = 'Archived — hidden from owners';
  static const String planDescriptionLabel = 'Plan description';
  static const String planDescriptionHint = 'Who this plan is for';
  static const String planPriceLabel = 'Plan price (₹) *';
  static const String planPriceHint = '[YOUR PRICE]';
  static const String billingDurationLabel = 'Billing duration *';
  static const String billingMonthly = 'Monthly';
  static const String billingYearly = 'Yearly';
  static const String planBenefitsLabel = 'Plan benefits';
  static const String planBenefitsHint = 'One benefit per line';
  static const String planBenefitsHelper =
      'One benefit per line. Shown to owners on the renewal screen.';
  static const String planLimitsLabel = 'Plan limits (where applicable)';
  static const String planLimitsHint = 'e.g. Up to 6 staff accounts';
  static const String offerTagLabel = 'Offer tag';
  static const String offerTagHint = 'e.g. Launch offer';
  static const String offerPercentageLabel = 'Offer percentage (%)';
  static const String offerPercentageHint = '0';
  static const String offerPercentageHelper =
      'Discount on the plan price. Leave empty for no offer.';
  static const String offerPercentageInvalid =
      'Enter a whole number from 0 to 99.';
  static const String offer = 'Offer';
  static const String noOffer = 'No offer';
  static const String plansLoadFailedTitle = "Couldn't load plans";

  static String offerSummary(int percentage, String offerPrice) =>
      '$percentage% off · $offerPrice';
  static const String savePlan = 'Save plan';
  static const String planNameRequired = 'Enter a plan name.';
  static const String planPriceRequired = 'Enter a price above ₹0.';
  static const String preview = 'Preview';
  static const String previewName = 'Plan name';
  static const String previewPrice = '₹ —';
  static const String previewDescription = 'Plan description shown to owners.';
  static const String previewBenefits = 'Benefits appear here';
  static const String previewBillingNote =
      'Proration, upgrade, downgrade and refund calculations are not '
      'configured — they require approved billing rules.';

  static String planCreated(String name) => '$name plan created.';
  static String planUpdated(String name) => '$name plan updated.';
  static const String editPlanSubtitle = 'Update this subscription plan';
  static const String saveChanges = 'Save changes';

  static const String planDetailsSubtitle = 'Plan details';
  static const String planNotFound = 'Plan not found';
  static const String planNotFoundMessage =
      'This plan does not exist or is no longer available.';
  static const String backToPlans = 'Back to Plans';
  static const String billingDuration = 'Billing duration';
  static const String planLimits = 'Plan limits';
  static const String lastUpdated = 'Last updated';
  static const String planBenefits = 'Plan benefits';
  static const String noBenefits = 'No benefits listed.';
  static const String planActions = 'Plan actions';
  static const String archivePlan = 'Archive plan';
  static const String archivePlanNote =
      'Archiving stops new purchases. Existing subscriptions continue until '
      'their expiry date.';
  static const String archivedPlanNote =
      'This plan is archived. Owners can no longer buy or renew onto it.';
  static const String archiveNotice =
      'No subscription is cancelled and no refund is calculated.';

  static String archivePlanTitle(String name) => 'Archive the $name plan?';

  static String archivePlanMessage(int? subscriptions) {
    const String lead = 'Owners can no longer buy or renew onto this plan.';
    return switch (subscriptions) {
      null => '$lead Existing subscriptions continue until their expiry date.',
      0 => '$lead No existing subscriptions are affected.',
      1 => '$lead 1 existing subscription continues until its expiry date.',
      _ =>
        '$lead ${AppFormatters.number(subscriptions)} existing subscriptions '
            'continue until their expiry date.',
    };
  }

  static String planArchivedSnack(String name) => '$name plan archived.';
  static const String editPlan = 'Edit plan';
  static const String noPlansTitle = 'No plans yet';
  static const String noPlansMessage =
      'Create a plan to offer it to shop owners.';

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
