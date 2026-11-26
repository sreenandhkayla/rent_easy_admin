import '../../data/models/subscription_payment.dart';

enum PaymentDetailsStatus { loading, loaded, notFound }

class PaymentDetailsState {
  const PaymentDetailsState({
    this.status = PaymentDetailsStatus.loading,
    this.payment,
    this.updatedAt,
  });

  final PaymentDetailsStatus status;
  final SubscriptionPayment? payment;
  final DateTime? updatedAt;
}
