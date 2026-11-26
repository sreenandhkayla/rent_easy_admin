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

class SubscriptionPaymentsTable extends StatelessWidget {
  const SubscriptionPaymentsTable({
    super.key,
    required this.rows,
    required this.onView,
  });

  static const double _minTableWidth = 1000;

  final List<SubscriptionPayment> rows;
  final ValueChanged<SubscriptionPayment> onView;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
                        icon: Icons.search,
                        title: SubscriptionsStrings.noPaymentsTitle,
                        message: SubscriptionsStrings.noPaymentsMessage,
                      ),
                    for (final SubscriptionPayment row in rows)
                      _PaymentRow(item: row, onView: () => onView(row)),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              SubscriptionsStrings.paymentsShown(rows.length),
              style: AppTextStyles.bodyCaption,
            ),
          ),
        ],
      ),
    );
  }
}

class _Columns {
  static const int transaction = 12;
  static const int shop = 27;
  static const int plan = 13;
  static const int amount = 6;
  static const int date = 14;
  static const int status = 10;
  static const int verification = 15;
  static const double action = 72;
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
      showTopBorder: false,
      child: Row(
        children: [
          cell(SubscriptionsStrings.transactionId, _Columns.transaction),
          cell(SubscriptionsStrings.shop, _Columns.shop),
          cell(SubscriptionsStrings.plan, _Columns.plan),
          cell(SubscriptionsStrings.amount, _Columns.amount, end: true),
          cell(SubscriptionsStrings.paymentDate, _Columns.date),
          cell(SubscriptionsStrings.status, _Columns.status),
          cell(SubscriptionsStrings.verification, _Columns.verification),
          const SizedBox(width: _Columns.action),
        ],
      ),
    );
  }
}

class _PaymentRow extends StatelessWidget {
  const _PaymentRow({required this.item, required this.onView});

  final SubscriptionPayment item;
  final VoidCallback onView;

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
    Widget pill(Widget child, int flex) => Expanded(
      flex: flex,
      child: Align(alignment: Alignment.centerLeft, child: child),
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          text(
            item.transactionId,
            _Columns.transaction,
            style: AppTextStyles.titleSmall,
          ),
          text(item.shopName, _Columns.shop),
          text(item.plan.label, _Columns.plan),
          text(AppFormatters.rupees(item.amount), _Columns.amount, end: true),
          text(AppFormatters.timestamp(item.paidAt), _Columns.date),
          pill(AttemptStatusPill(status: item.status), _Columns.status),
          pill(
            VerificationPill(status: item.verification),
            _Columns.verification,
          ),
          SizedBox(
            width: _Columns.action,
            child: Align(
              alignment: Alignment.centerRight,
              child: AppSecondaryButton(
                label: AppStrings.view,
                onPressed: onView,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
