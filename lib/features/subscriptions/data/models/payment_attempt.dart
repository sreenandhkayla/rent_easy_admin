enum AttemptStatus { successful, pending, failed }

enum VerificationStatus { verified, awaiting, notVerified }

class PaymentAttempt {
  const PaymentAttempt({
    required this.transactionId,
    required this.at,
    required this.amount,
    required this.status,
    required this.verification,
  });

  final String transactionId;
  final DateTime at;
  final int amount;
  final AttemptStatus status;
  final VerificationStatus verification;

  PaymentAttempt verified() => PaymentAttempt(
    transactionId: transactionId,
    at: at,
    amount: amount,
    status: AttemptStatus.successful,
    verification: VerificationStatus.verified,
  );
}
