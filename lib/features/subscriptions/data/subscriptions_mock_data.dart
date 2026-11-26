import '../../../core/enums/payment_status.dart';
import '../../../core/enums/subscription_plan.dart';
import '../../shops/data/models/shop.dart';
import '../../shops/data/shops_mock_data.dart';
import 'models/payment_attempt.dart';
import 'models/reconciliation_summary.dart';
import 'models/subscription_payment.dart';
import 'models/shop_subscription.dart';
import 'models/subscription_overview.dart';

class SubscriptionsMockData {
  SubscriptionsMockData._();

  static SubscriptionOverview overview(DateTime updatedAt) {
    return SubscriptionOverview(
      activeSubscriptions: 941,
      unsubscribedShops: 331,
      expiringSoon: 46,
      expiredSubscriptions: 214,
      pendingPayments: 12,
      failedPaymentsThisMonth: 18,
      currentMonth: DateTime(2026, 11),
      monthlyRevenue: [
        MonthlyRevenue(month: DateTime(2026, 6), amount: 660000),
        MonthlyRevenue(month: DateTime(2026, 7), amount: 680000),
        MonthlyRevenue(month: DateTime(2026, 8), amount: 700000),
        MonthlyRevenue(month: DateTime(2026, 9), amount: 710000),
        MonthlyRevenue(month: DateTime(2026, 10), amount: 730000),
        MonthlyRevenue(month: DateTime(2026, 11), amount: 749184),
      ],
      yearToDateRevenue: 7299184,
      lifetimeRevenue: 11769184,
      revenueByPlan: const [
        PlanFigure(plan: 'Basic', value: 205588),
        PlanFigure(plan: 'Professional', value: 388611),
        PlanFigure(plan: 'Premium', value: 154985),
      ],
      shopsByPlan: const [
        PlanFigure(plan: 'Basic', value: 412),
        PlanFigure(plan: 'Professional', value: 389),
        PlanFigure(plan: 'Premium', value: 186),
      ],
      updatedAt: updatedAt,
    );
  }

  static List<SubscriptionPayment> payments() => [
    SubscriptionPayment(
      transactionId: 'TXN-88410219',
      shopId: 'SHP-2012',
      shopName: 'Thomas Event Equipment',
      plan: SubscriptionPlan.professional,
      amount: 999,
      paidAt: DateTime(2026, 11, 24, 9, 12),
      status: AttemptStatus.pending,
      verification: VerificationStatus.awaiting,
      providerReference: 'pay_Pq9Hd3Vx22',
      reconciliation: ReconciliationStatus.pending,
    ),
    SubscriptionPayment(
      transactionId: 'TXN-88410231',
      shopId: 'SHP-2001',
      shopName: 'Kumar Construction Rentals',
      plan: SubscriptionPlan.professional,
      amount: 999,
      paidAt: DateTime(2026, 11, 22, 10, 42),
      status: AttemptStatus.successful,
      verification: VerificationStatus.verified,
      providerReference: 'pay_Pq8lLm2Xa9',
      reconciliation: ReconciliationStatus.matched,
      invoiceNumber: 'INV-26-04812',
    ),
    SubscriptionPayment(
      transactionId: 'TXN-88410227',
      shopId: 'SHP-2013',
      shopName: 'Muhammed Machinery',
      plan: SubscriptionPlan.premium,
      amount: 9999,
      paidAt: DateTime(2026, 11, 22, 9, 18),
      status: AttemptStatus.successful,
      verification: VerificationStatus.verified,
      providerReference: 'pay_Pq80Kc7Wd1',
      reconciliation: ReconciliationStatus.matched,
      invoiceNumber: 'INV-26-04811',
    ),
    SubscriptionPayment(
      transactionId: 'TXN-88410198',
      shopId: 'SHP-2016',
      shopName: 'Chandran Auto Rentals',
      plan: SubscriptionPlan.basic,
      amount: 499,
      paidAt: DateTime(2026, 11, 20, 18, 5),
      status: AttemptStatus.failed,
      verification: VerificationStatus.notVerified,
      providerReference: 'pay_Pq7ZkT0bR4',
      reconciliation: ReconciliationStatus.notApplicable,
      failureReason: 'Bank declined the transaction',
    ),
    SubscriptionPayment(
      transactionId: 'TXN-88410166',
      shopId: 'SHP-2008',
      shopName: 'Menon Car Rentals',
      plan: SubscriptionPlan.professional,
      amount: 999,
      paidAt: DateTime(2026, 11, 15, 11, 37),
      status: AttemptStatus.failed,
      verification: VerificationStatus.notVerified,
      providerReference: 'pay_Pq6Ty4Fn31',
      reconciliation: ReconciliationStatus.notApplicable,
      failureReason: 'Payment cancelled by the owner',
    ),
    SubscriptionPayment(
      transactionId: 'TXN-88410141',
      shopId: 'SHP-2007',
      shopName: 'Nair Sound & Lights – Guruvayur',
      plan: SubscriptionPlan.basic,
      amount: 499,
      paidAt: DateTime(2026, 11, 9, 16, 20),
      status: AttemptStatus.successful,
      verification: VerificationStatus.verified,
      providerReference: 'pay_Pq5Rb2Ms66',
      reconciliation: ReconciliationStatus.matched,
      invoiceNumber: 'INV-26-04698',
    ),
    SubscriptionPayment(
      transactionId: 'TXN-88410119',
      shopId: 'SHP-2002',
      shopName: 'Kumar Construction – Aluva',
      plan: SubscriptionPlan.basic,
      amount: 499,
      paidAt: DateTime(2026, 11, 2, 8, 55),
      status: AttemptStatus.failed,
      verification: VerificationStatus.notVerified,
      providerReference: 'pay_Pq5Lh9Bv08',
      reconciliation: ReconciliationStatus.notApplicable,
      failureReason: 'Card authentication failed',
    ),
    SubscriptionPayment(
      transactionId: 'TXN-88410102',
      shopId: 'SHP-2011',
      shopName: 'Pillai Tools Hub',
      plan: SubscriptionPlan.basic,
      amount: 499,
      paidAt: DateTime(2026, 11, 1, 12, 3),
      status: AttemptStatus.successful,
      verification: VerificationStatus.verified,
      providerReference: 'pay_Pq4Aa0Jh57',
      reconciliation: ReconciliationStatus.matched,
      invoiceNumber: 'INV-26-04652',
    ),
    SubscriptionPayment(
      transactionId: 'TXN-88410087',
      shopId: 'SHP-2005',
      shopName: 'Mathew Machinery Hire',
      plan: SubscriptionPlan.professional,
      amount: 999,
      paidAt: DateTime(2026, 10, 29, 19, 46),
      status: AttemptStatus.successful,
      verification: VerificationStatus.verified,
      providerReference: 'pay_Pq3Wn8Gt90',
      reconciliation: ReconciliationStatus.unmatched,
      invoiceNumber: 'INV-26-04610',
    ),
    SubscriptionPayment(
      transactionId: 'TXN-88410052',
      shopId: 'SHP-2012',
      shopName: 'Thomas Event Equipment',
      plan: SubscriptionPlan.professional,
      amount: 999,
      paidAt: DateTime(2026, 10, 24, 10, 10),
      status: AttemptStatus.successful,
      verification: VerificationStatus.verified,
      providerReference: 'pay_Pq2Vc5Ek14',
      reconciliation: ReconciliationStatus.matched,
      invoiceNumber: 'INV-26-04577',
    ),
    SubscriptionPayment(
      transactionId: 'TXN-88410018',
      shopId: 'SHP-2016',
      shopName: 'Chandran Auto Rentals',
      plan: SubscriptionPlan.basic,
      amount: 499,
      paidAt: DateTime(2026, 10, 20, 17, 48),
      status: AttemptStatus.successful,
      verification: VerificationStatus.verified,
      providerReference: 'pay_Pq1Mx6Cy05',
      reconciliation: ReconciliationStatus.matched,
      invoiceNumber: 'INV-26-04548',
    ),
    SubscriptionPayment(
      transactionId: 'TXN-88410031',
      shopId: 'SHP-2008',
      shopName: 'Menon Car Rentals',
      plan: SubscriptionPlan.professional,
      amount: 999,
      paidAt: DateTime(2026, 10, 15, 11, 2),
      status: AttemptStatus.successful,
      verification: VerificationStatus.verified,
      providerReference: 'pay_Pq1Zr3Dq72',
      reconciliation: ReconciliationStatus.matched,
      invoiceNumber: 'INV-26-04529',
    ),
  ];

  static ReconciliationSummary reconciliationSummary() =>
      const ReconciliationSummary(
        matched: 1189,
        unmatched: 1,
        pending: 1,
        refunds: 0,
      );

  static SubscriptionPayment? payment(String transactionId) {
    for (final SubscriptionPayment item in payments()) {
      if (item.transactionId == transactionId) return item;
    }
    return null;
  }

  static const Map<SubscriptionPlan, int> planPrices = {
    SubscriptionPlan.basic: 499,
    SubscriptionPlan.professional: 999,
    SubscriptionPlan.premium: 4999,
  };

  static final Map<String, List<PaymentAttempt>> _attempts = {};
  static int _nextTransaction = 88410300;

  static List<ShopSubscription> shopSubscriptions() => [
    for (final Shop shop in ShopsMockData.shops()) _toSubscription(shop),
  ];

  static SubscriptionDetails? details(String shopId) {
    final Shop? shop = ShopsMockData.shop(shopId);
    if (shop == null) return null;
    return SubscriptionDetails(
      subscription: _toSubscription(shop),
      attempts: List.of(_attemptsFor(shop)),
    );
  }

  static void simulateVerifiedRenewal(String shopId, DateTime now) {
    final Shop? shop = ShopsMockData.shop(shopId);
    if (shop == null) return;
    final SubscriptionPlan plan = shop.plan ?? SubscriptionPlan.basic;
    final List<PaymentAttempt> attempts = _attemptsFor(shop);
    final int pendingIndex = attempts.indexWhere(
      (attempt) => attempt.status == AttemptStatus.pending,
    );
    if (pendingIndex >= 0) {
      attempts[pendingIndex] = attempts[pendingIndex].verified();
    } else {
      attempts.insert(
        0,
        PaymentAttempt(
          transactionId: 'TXN-${_nextTransaction++}',
          at: now,
          amount: planPrices[plan]!,
          status: AttemptStatus.successful,
          verification: VerificationStatus.verified,
        ),
      );
    }
    final DateTime start = DateTime(now.year, now.month, now.day);
    final int months = plan == SubscriptionPlan.premium ? 12 : 1;
    ShopsMockData.renewSubscription(
      shopId,
      plan: plan,
      startedAt: start,
      expiresAt: DateTime(start.year, start.month + months, start.day),
    );
  }

  static ShopSubscription _toSubscription(Shop shop) => ShopSubscription(
    shopName: shop.name,
    shopId: shop.shopId,
    ownerName: shop.ownerName,
    ownerId: shop.ownerId,
    status: shop.subscription,
    payment: shop.lastPayment,
    plan: shop.plan,
    startedAt: shop.startedAt,
    expiresAt: shop.expiresAt,
    isShopRestricted: shop.status == ShopStatus.restricted,
  );

  static List<PaymentAttempt> _attemptsFor(Shop shop) =>
      _attempts.putIfAbsent(shop.shopId, () => _seedAttempts(shop));

  static List<PaymentAttempt> _seedAttempts(Shop shop) {
    final SubscriptionPlan? plan = shop.plan;
    final DateTime? startedAt = shop.startedAt;
    final DateTime? expiresAt = shop.expiresAt;
    if (plan == null || startedAt == null || expiresAt == null) return [];
    final int amount = planPrices[plan]!;
    final int number = int.parse(shop.shopId.split('-').last) - 2000;
    final ({String success, String latest, int successHour, int successMinute})
    ids = switch (shop.shopId) {
      'SHP-2016' => (
        success: 'TXN-88410018',
        latest: 'TXN-88410198',
        successHour: 17,
        successMinute: 48,
      ),
      'SHP-2012' => (
        success: 'TXN-88410052',
        latest: 'TXN-88410219',
        successHour: 10,
        successMinute: 10,
      ),
      _ => (
        success: 'TXN-884100${(number * 2).toString().padLeft(2, '0')}',
        latest: 'TXN-884101${(number * 2).toString().padLeft(2, '0')}',
        successHour: 10,
        successMinute: 10,
      ),
    };
    final PaymentAttempt success = PaymentAttempt(
      transactionId: ids.success,
      at: DateTime(
        startedAt.year,
        startedAt.month,
        startedAt.day,
        ids.successHour,
        ids.successMinute,
      ),
      amount: amount,
      status: AttemptStatus.successful,
      verification: VerificationStatus.verified,
    );
    return switch (shop.lastPayment) {
      PaymentStatus.failed => [
        PaymentAttempt(
          transactionId: ids.latest,
          at: DateTime(expiresAt.year, expiresAt.month, expiresAt.day, 18, 5),
          amount: amount,
          status: AttemptStatus.failed,
          verification: VerificationStatus.notVerified,
        ),
        success,
      ],
      PaymentStatus.pending => [
        PaymentAttempt(
          transactionId: ids.latest,
          at: DateTime(expiresAt.year, expiresAt.month, expiresAt.day, 9, 12),
          amount: amount,
          status: AttemptStatus.pending,
          verification: VerificationStatus.awaiting,
        ),
        success,
      ],
      PaymentStatus.paid || PaymentStatus.none => [success],
    };
  }
}
