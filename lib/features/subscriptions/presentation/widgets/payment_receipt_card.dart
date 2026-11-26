import 'package:flutter/material.dart';

import '../../../../core/resources/strings/subscriptions_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../data/models/subscription_payment.dart';

class PaymentReceiptCard extends StatelessWidget {
  const PaymentReceiptCard({
    super.key,
    required this.payment,
    required this.invoiceNumber,
  });

  final SubscriptionPayment payment;
  final String invoiceNumber;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 4,
            children: [
              Text(
                SubscriptionsStrings.receipt,
                style: AppTextStyles.cardTitle,
              ),
              Text(
                SubscriptionsStrings.receiptNote,
                style: AppTextStyles.bodyCaption,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.contentBackground,
              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ReceiptLine(
                  label: SubscriptionsStrings.receiptTitle,
                  value: invoiceNumber,
                  labelStyle: AppTextStyles.titleSmall,
                ),
                _ReceiptLine(
                  label: SubscriptionsStrings.billedTo,
                  value: payment.shopName,
                ),
                _ReceiptLine(
                  label: SubscriptionsStrings.plan,
                  value: payment.plan.label,
                ),
                _ReceiptLine(
                  label: SubscriptionsStrings.paidOn,
                  value: AppFormatters.timestamp(payment.paidAt),
                ),
                const Divider(height: 20, color: AppColors.border),
                _ReceiptLine(
                  label: SubscriptionsStrings.total,
                  value: AppFormatters.rupees(payment.amount),
                  labelStyle: AppTextStyles.titleSmall,
                  valueStyle: AppTextStyles.titleSmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReceiptLine extends StatelessWidget {
  const _ReceiptLine({
    required this.label,
    required this.value,
    this.labelStyle = AppTextStyles.bodyMedium,
    this.valueStyle = AppTextStyles.bodySmallPrimary,
  });

  final String label;
  final String value;
  final TextStyle labelStyle;
  final TextStyle valueStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Flexible(child: Text(label, style: labelStyle)),
          const SizedBox(width: 16),
          Flexible(
            child: Text(value, style: valueStyle, textAlign: TextAlign.end),
          ),
        ],
      ),
    );
  }
}
