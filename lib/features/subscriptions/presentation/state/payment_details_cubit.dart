import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/subscription_payment.dart';
import '../../data/subscriptions_mock_data.dart';
import 'payment_details_state.dart';

class PaymentDetailsCubit extends Cubit<PaymentDetailsState> {
  PaymentDetailsCubit(this.transactionId) : super(const PaymentDetailsState());

  final String? transactionId;

  void load() {
    final String? id = transactionId;
    final SubscriptionPayment? payment = id == null
        ? null
        : SubscriptionsMockData.payment(id);
    emit(
      PaymentDetailsState(
        status: payment == null
            ? PaymentDetailsStatus.notFound
            : PaymentDetailsStatus.loaded,
        payment: payment,
        updatedAt: DateTime.now(),
      ),
    );
  }
}
