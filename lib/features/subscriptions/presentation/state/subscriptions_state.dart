import '../../../../core/enums/subscription_plan.dart';
import '../../../../core/enums/subscription_status.dart';
import '../../data/models/payment_attempt.dart';
import '../../data/models/plan_definition.dart';
import '../../data/models/reconciliation_summary.dart';
import '../../data/models/shop_subscription.dart';
import '../../data/models/subscription_overview.dart';
import '../../data/models/subscription_payment.dart';

enum SubscriptionsTab {
  overview,
  shopSubscriptions,
  plans,
  payments,
  reconciliation,
}

enum ExpiryFilter { any, next7Days, next30Days, expired }

enum PaymentFilter {
  all(null),
  successful(AttemptStatus.successful),
  pending(AttemptStatus.pending),
  failed(AttemptStatus.failed);

  const PaymentFilter(this.status);

  final AttemptStatus? status;

  bool matches(AttemptStatus value) => status == null || status == value;
}

class SubscriptionsState {
  const SubscriptionsState({
    this.overview,
    this.tab = SubscriptionsTab.overview,
    this.shopSubscriptions = const [],
    this.plans = const [],
    this.payments = const [],
    this.reconciliationSummary,
    this.paymentFilter = PaymentFilter.all,
    this.paymentQuery = '',
    this.statusFilter = SubscriptionFilter.all,
    this.planFilter = PlanFilter.all,
    this.expiryFilter = ExpiryFilter.any,
    this.query = '',
  });

  static const List<SubscriptionStatus> _statusOrder = [
    SubscriptionStatus.expired,
    SubscriptionStatus.expiringSoon,
    SubscriptionStatus.active,
    SubscriptionStatus.unsubscribed,
  ];

  final SubscriptionOverview? overview;
  final SubscriptionsTab tab;
  final List<ShopSubscription> shopSubscriptions;
  final List<PlanDefinition> plans;
  final List<SubscriptionPayment> payments;
  final ReconciliationSummary? reconciliationSummary;
  final PaymentFilter paymentFilter;
  final String paymentQuery;
  final SubscriptionFilter statusFilter;
  final PlanFilter planFilter;
  final ExpiryFilter expiryFilter;
  final String query;

  int countFor(SubscriptionFilter filter) =>
      shopSubscriptions.where((item) => filter.matches(item.status)).length;

  int paymentCountFor(PaymentFilter filter) =>
      payments.where((item) => filter.matches(item.status)).length;

  List<SubscriptionPayment> get reconciliationPayments =>
      payments
          .where(
            (item) => item.reconciliation != ReconciliationStatus.notApplicable,
          )
          .toList()
        ..sort((a, b) => b.paidAt.compareTo(a.paidAt));

  List<SubscriptionPayment> get visiblePayments {
    final String search = paymentQuery.trim().toLowerCase();
    return payments
        .where(
          (item) =>
              paymentFilter.matches(item.status) &&
              (search.isEmpty ||
                  item.transactionId.toLowerCase().contains(search) ||
                  item.shopName.toLowerCase().contains(search) ||
                  item.shopId.toLowerCase().contains(search)),
        )
        .toList()
      ..sort((a, b) => b.paidAt.compareTo(a.paidAt));
  }

  List<ShopSubscription> get visibleSubscriptions {
    final String search = query.trim().toLowerCase();
    final DateTime now = overview?.updatedAt ?? DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final List<ShopSubscription> result = shopSubscriptions.where((item) {
      final DateTime? expiresAt = item.expiresAt;
      final bool matchesExpiry = switch (expiryFilter) {
        ExpiryFilter.any => true,
        ExpiryFilter.next7Days =>
          expiresAt != null &&
              !expiresAt.isBefore(today) &&
              expiresAt.isBefore(today.add(const Duration(days: 8))),
        ExpiryFilter.next30Days =>
          expiresAt != null &&
              !expiresAt.isBefore(today) &&
              expiresAt.isBefore(today.add(const Duration(days: 31))),
        ExpiryFilter.expired => expiresAt != null && expiresAt.isBefore(today),
      };
      return statusFilter.matches(item.status) &&
          planFilter.matches(item.plan) &&
          matchesExpiry &&
          (search.isEmpty ||
              item.shopName.toLowerCase().contains(search) ||
              item.shopId.toLowerCase().contains(search) ||
              item.ownerName.toLowerCase().contains(search));
    }).toList();
    result.sort((a, b) {
      final int byStatus = _statusOrder
          .indexOf(a.status)
          .compareTo(_statusOrder.indexOf(b.status));
      if (byStatus != 0) return byStatus;
      final DateTime? x = a.expiresAt;
      final DateTime? y = b.expiresAt;
      if (x != null && y != null && x != y) return x.compareTo(y);
      return a.shopId.compareTo(b.shopId);
    });
    return result;
  }

  SubscriptionsState copyWith({
    SubscriptionOverview? overview,
    SubscriptionsTab? tab,
    List<ShopSubscription>? shopSubscriptions,
    List<PlanDefinition>? plans,
    List<SubscriptionPayment>? payments,
    ReconciliationSummary? reconciliationSummary,
    PaymentFilter? paymentFilter,
    String? paymentQuery,
    SubscriptionFilter? statusFilter,
    PlanFilter? planFilter,
    ExpiryFilter? expiryFilter,
    String? query,
  }) {
    return SubscriptionsState(
      overview: overview ?? this.overview,
      tab: tab ?? this.tab,
      shopSubscriptions: shopSubscriptions ?? this.shopSubscriptions,
      plans: plans ?? this.plans,
      payments: payments ?? this.payments,
      reconciliationSummary:
          reconciliationSummary ?? this.reconciliationSummary,
      paymentFilter: paymentFilter ?? this.paymentFilter,
      paymentQuery: paymentQuery ?? this.paymentQuery,
      statusFilter: statusFilter ?? this.statusFilter,
      planFilter: planFilter ?? this.planFilter,
      expiryFilter: expiryFilter ?? this.expiryFilter,
      query: query ?? this.query,
    );
  }
}
