import '../../../../core/enums/payment_status.dart';
import '../../../../core/enums/subscription_plan.dart';
import '../../../../core/enums/subscription_status.dart';
import 'payment_attempt.dart';

class ShopSubscription {
  const ShopSubscription({
    required this.shopName,
    required this.shopId,
    required this.ownerName,
    required this.ownerId,
    required this.status,
    required this.payment,
    this.plan,
    this.startedAt,
    this.expiresAt,
    this.isShopRestricted = false,
  });

  final String shopName;
  final String shopId;
  final String ownerName;
  final String ownerId;
  final SubscriptionStatus status;
  final PaymentStatus payment;
  final SubscriptionPlan? plan;
  final DateTime? startedAt;
  final DateTime? expiresAt;
  final bool isShopRestricted;
}

class SubscriptionDetails {
  const SubscriptionDetails({
    required this.subscription,
    required this.attempts,
  });

  final ShopSubscription subscription;
  final List<PaymentAttempt> attempts;

  bool get hasPendingAttempt =>
      attempts.any((attempt) => attempt.status == AttemptStatus.pending);
}
