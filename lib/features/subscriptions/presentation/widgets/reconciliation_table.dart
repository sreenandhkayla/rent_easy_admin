import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/resources/strings/app_strings.dart';
import '../../../../core/resources/strings/subscriptions_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_secondary_button.dart';
import '../../../../core/widgets/app_table_header.dart';
import '../../data/models/subscription_payment.dart';
import 'subscription_labels.dart';

class ReconciliationTable extends StatelessWidget {
  const ReconciliationTable({
    super.key,
    required this.rows,
    required this.onOpen,
  });

  static const double _minTableWidth = 920;

  final List<SubscriptionPayment> rows;
  final ValueChanged<SubscriptionPayment> onOpen;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 18, 16, 14),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              runSpacing: 4,
              children: [
                Text(
                  SubscriptionsStrings.reconciliationTableTitle,
                  style: AppTextStyles.cardTitle,
                ),
                Text(
                  SubscriptionsStrings.reconciliationTableNote,
                  style: AppTextStyles.meta,
                ),
              ],
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: math.max(constraints.maxWidth, _minTableWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _HeaderRow(),
                    if (rows.isEmpty)
                      const AppEmptyState(
                        icon: Icons.receipt_long_outlined,
                        title: SubscriptionsStrings.noReconciliationTitle,
                        message: SubscriptionsStrings.noReconciliationMessage,
                      ),
                    for (int i = 0; i < rows.length; i++)
                      _ReconciliationRow(
                        item: rows[i],
                        showDivider: i < rows.length - 1,
                        onOpen: () => onOpen(rows[i]),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Columns {
  static const int transaction = 11;
  static const int shop = 34;
  static const int amount = 5;
  static const int providerRef = 13;
  static const int invoice = 12;
  static const int reconciliation = 12;
  static const double action = 84;
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow();

  @override
  Widget build(BuildContext context) {
    Widget cell(String label, int flex, {bool end = false}) => Expanded(
      flex: flex,
      child: Padding(
        padding: EdgeInsets.only(right: end ? 12 : 8),
        child: Text(
          label,
          style: AppTextStyles.tableHeader,
          textAlign: end ? TextAlign.end : TextAlign.start,
        ),
      ),
    );
    return AppTableHeader(
      child: Row(
        children: [
          cell(SubscriptionsStrings.transactionId, _Columns.transaction),
          cell(SubscriptionsStrings.shop, _Columns.shop),
          cell(SubscriptionsStrings.amount, _Columns.amount, end: true),
          cell(SubscriptionsStrings.providerRefShort, _Columns.providerRef),
          cell(SubscriptionsStrings.invoiceReference, _Columns.invoice),
          cell(SubscriptionsStrings.reconciliation, _Columns.reconciliation),
          const SizedBox(width: _Columns.action),
        ],
      ),
    );
  }
}

class _ReconciliationRow extends StatelessWidget {
  const _ReconciliationRow({
    required this.item,
    required this.showDivider,
    required this.onOpen,
  });

  final SubscriptionPayment item;
  final bool showDivider;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    Widget text(
      String value,
      int flex, {
      TextStyle style = AppTextStyles.tableCell,
      bool end = false,
    }) => Expanded(
      flex: flex,
      child: Padding(
        padding: EdgeInsets.only(right: end ? 12 : 8),
        child: Text(
          value,
          style: style,
          textAlign: end ? TextAlign.end : TextAlign.start,
        ),
      ),
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(bottom: BorderSide(color: AppColors.divider))
            : null,
      ),
      child: Row(
        children: [
          text(
            item.transactionId,
            _Columns.transaction,
            style: AppTextStyles.titleSmall,
          ),
          text(item.shopName, _Columns.shop),
          text(AppFormatters.rupees(item.amount), _Columns.amount, end: true),
          text(item.providerReference, _Columns.providerRef),
          text(
            item.invoiceNumber ?? SubscriptionsStrings.emptyValue,
            _Columns.invoice,
          ),
          Expanded(
            flex: _Columns.reconciliation,
            child: Align(
              alignment: Alignment.centerLeft,
              child: ReconciliationPill(status: item.reconciliation),
            ),
          ),
          SizedBox(
            width: _Columns.action,
            child: Align(
              alignment: Alignment.centerRight,
              child: AppSecondaryButton(
                label: item.reconciliation == ReconciliationStatus.unmatched
                    ? SubscriptionsStrings.review
                    : AppStrings.view,
                onPressed: onOpen,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
