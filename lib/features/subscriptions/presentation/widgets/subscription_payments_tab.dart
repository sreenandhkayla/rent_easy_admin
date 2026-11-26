import 'package:flutter/material.dart';

import '../../data/models/subscription_payment.dart';
import '../state/subscriptions_state.dart';
import 'subscription_payments_table.dart';
import 'subscription_payments_toolbar.dart';

class SubscriptionPaymentsTab extends StatelessWidget {
  const SubscriptionPaymentsTab({
    super.key,
    required this.state,
    required this.onFilterChanged,
    required this.onSearch,
    required this.onView,
  });

  final SubscriptionsState state;
  final ValueChanged<PaymentFilter> onFilterChanged;
  final ValueChanged<String> onSearch;
  final ValueChanged<SubscriptionPayment> onView;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SubscriptionPaymentsToolbar(
          state: state,
          onFilterChanged: onFilterChanged,
          onSearch: onSearch,
        ),
        const SizedBox(height: 16),
        SubscriptionPaymentsTable(rows: state.visiblePayments, onView: onView),
      ],
    );
  }
}
