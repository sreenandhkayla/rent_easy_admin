import 'package:flutter/material.dart';

import '../../../../core/resources/strings/subscriptions_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_detail_field.dart';
import '../../../../core/widgets/app_responsive_grid.dart';
import '../../data/models/subscription_payment.dart';
import 'subscription_labels.dart';

class PaymentSummaryCard extends StatelessWidget {
  const PaymentSummaryCard({super.key, required this.payment});

  final SubscriptionPayment payment;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      SubscriptionsStrings.amount,
                      style: AppTextStyles.bodyCaption,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      AppFormatters.rupees(payment.amount),
                      style: AppTextStyles.statValueMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    AttemptStatusPill(status: payment.status),
                    VerificationPill(status: payment.verification),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 36, color: AppColors.divider),
          AppResponsiveGrid(
            minItemWidth: 180,
            maxColumns: 2,
            spacing: 18,
            children: [
              AppDetailField(
                label: SubscriptionsStrings.transactionId,
                value: payment.transactionId,
              ),
              AppDetailField(
                label: SubscriptionsStrings.shop,
                value: payment.shopName,
              ),
              AppDetailField(
                label: SubscriptionsStrings.plan,
                value: payment.plan.label,
              ),
              AppDetailField(
                label: SubscriptionsStrings.paymentDate,
                value: AppFormatters.timestamp(payment.paidAt),
              ),
              AppDetailField(
                label: SubscriptionsStrings.providerReference,
                value: payment.providerReference,
              ),
              AppDetailField(
                label: SubscriptionsStrings.invoiceReference,
                value: payment.invoiceNumber ?? SubscriptionsStrings.emptyValue,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    SubscriptionsStrings.reconciliation,
                    style: AppTextStyles.bodyCaption,
                  ),
                  const SizedBox(height: 6),
                  ReconciliationPill(status: payment.reconciliation),
                ],
              ),
              const AppDetailField(
                label: SubscriptionsStrings.refundStatus,
                value: SubscriptionsStrings.notApplicable,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
