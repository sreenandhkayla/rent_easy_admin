import '../../../../core/enums/subscription_plan.dart';
import 'payment_attempt.dart';

enum ReconciliationStatus { matched, unmatched, pending, notApplicable }

class SubscriptionPayment {
  const SubscriptionPayment({
    required this.transactionId,
    required this.shopId,
    required this.shopName,
    required this.plan,
    required this.amount,
    required this.paidAt,
    required this.status,
    required this.verification,
    required this.providerReference,
    required this.reconciliation,
    this.invoiceNumber,
    this.failureReason,
  });

  final String transactionId;
  final String shopId;
  final String shopName;
  final SubscriptionPlan plan;
  final int amount;
  final DateTime paidAt;
  final AttemptStatus status;
  final VerificationStatus verification;
  final String providerReference;
  final ReconciliationStatus reconciliation;
  final String? invoiceNumber;
  final String? failureReason;

  bool get isVerified => verification == VerificationStatus.verified;
}
