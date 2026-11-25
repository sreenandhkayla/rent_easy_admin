import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/resources/strings/app_strings.dart';
import '../../../../core/resources/strings/subscriptions_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_secondary_button.dart';
import '../../../../core/widgets/app_table_header.dart';
import '../../data/models/payment_attempt.dart';
import 'subscription_labels.dart';

class PaymentAttemptsCard extends StatelessWidget {
  const PaymentAttemptsCard({
    super.key,
    required this.attempts,
    required this.onView,
  });

  static const double _minTableWidth = 640;

  final List<PaymentAttempt> attempts;
  final ValueChanged<PaymentAttempt> onView;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 18, 16, 14),
            child: Text(
              SubscriptionsStrings.paymentsAndAttempts,
              style: AppTextStyles.cardTitle,
            ),
          ),
          if (attempts.isEmpty)
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: Text(
                SubscriptionsStrings.noAttempts,
                style: AppTextStyles.bodyCaption,
              ),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: math.max(constraints.maxWidth, _minTableWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const _HeaderRow(),
                      for (int i = 0; i < attempts.length; i++)
                        _AttemptRow(
                          attempt: attempts[i],
                          showDivider: i < attempts.length - 1,
                          onView: () => onView(attempts[i]),
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
  static const int transaction = 15;
  static const int date = 23;
  static const int amount = 9;
  static const int status = 13;
  static const int verification = 20;
  static const double action = 72;
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow();

  @override
  Widget build(BuildContext context) {
    Widget cell(String label, int flex, {bool end = false}) => Expanded(
      flex: flex,
      child: Padding(
        padding: EdgeInsets.only(right: end ? 12 : 0),
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
          cell(SubscriptionsStrings.transaction, _Columns.transaction),
          cell(SubscriptionsStrings.date, _Columns.date),
          cell(SubscriptionsStrings.amount, _Columns.amount, end: true),
          cell(SubscriptionsStrings.status, _Columns.status),
          cell(SubscriptionsStrings.verification, _Columns.verification),
          const SizedBox(width: _Columns.action),
        ],
      ),
    );
  }
}

class _AttemptRow extends StatelessWidget {
  const _AttemptRow({
    required this.attempt,
    required this.showDivider,
    required this.onView,
  });

  final PaymentAttempt attempt;
  final bool showDivider;
  final VoidCallback onView;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(bottom: BorderSide(color: AppColors.divider))
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            flex: _Columns.transaction,
            child: Text(attempt.transactionId, style: AppTextStyles.titleSmall),
          ),
          Expanded(
            flex: _Columns.date,
            child: Text(
              AppFormatters.timestamp(attempt.at),
              style: AppTextStyles.tableCell,
            ),
          ),
          Expanded(
            flex: _Columns.amount,
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Text(
                AppFormatters.rupees(attempt.amount),
                style: AppTextStyles.tableCell,
                textAlign: TextAlign.end,
              ),
            ),
          ),
          Expanded(
            flex: _Columns.status,
            child: Align(
              alignment: Alignment.centerLeft,
              child: AttemptStatusPill(status: attempt.status),
            ),
          ),
          Expanded(
            flex: _Columns.verification,
            child: Align(
              alignment: Alignment.centerLeft,
              child: VerificationPill(status: attempt.verification),
            ),
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
