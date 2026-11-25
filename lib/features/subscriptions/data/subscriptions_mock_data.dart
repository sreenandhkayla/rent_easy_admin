import '../../../core/enums/payment_status.dart';
import '../../../core/enums/subscription_plan.dart';
import '../../shops/data/models/shop.dart';
import '../../shops/data/shops_mock_data.dart';
import 'models/payment_attempt.dart';
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
