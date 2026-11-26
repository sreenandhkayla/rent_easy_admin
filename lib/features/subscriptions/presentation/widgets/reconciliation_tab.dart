import 'package:flutter/material.dart';

import '../../data/models/reconciliation_summary.dart';
import '../../data/models/subscription_payment.dart';
import 'reconciliation_stats_grid.dart';
import 'reconciliation_table.dart';

class ReconciliationTab extends StatelessWidget {
  const ReconciliationTab({
    super.key,
    required this.summary,
    required this.rows,
    required this.onOpen,
  });

  final ReconciliationSummary summary;
  final List<SubscriptionPayment> rows;
  final ValueChanged<SubscriptionPayment> onOpen;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ReconciliationStatsGrid(summary: summary),
        const SizedBox(height: 16),
        ReconciliationTable(rows: rows, onOpen: onOpen),
      ],
    );
  }
}
