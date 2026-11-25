import 'package:flutter/material.dart';

import '../../../../core/resources/strings/subscriptions_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_detail_field.dart';
import '../../../../core/widgets/app_payment_pill.dart';
import '../../../../core/widgets/app_responsive_grid.dart';
import '../../../../core/widgets/app_subscription_pill.dart';
import '../../data/models/shop_subscription.dart';
import 'subscription_labels.dart';

class SubscriptionPlanCard extends StatelessWidget {
  const SubscriptionPlanCard({super.key, required this.subscription});

  final ShopSubscription subscription;

  String _date(DateTime? date) =>
      date == null ? SubscriptionsStrings.emptyValue : AppFormatters.date(date);

  @override
  Widget build(BuildContext context) {
    final String? plan = subscription.plan?.label;
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
                    Text(
                      plan == null
                          ? SubscriptionsStrings.noPlan
                          : SubscriptionsStrings.planTitle(plan),
                      style: AppTextStyles.profileName,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      SubscriptionsStrings.shopLine(
                        subscription.shopName,
                        subscription.shopId,
                      ),
                      style: AppTextStyles.bodyCaption,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              AppSubscriptionPill(status: subscription.status),
            ],
          ),
          const Divider(height: 36, color: AppColors.divider),
          AppResponsiveGrid(
            minItemWidth: 160,
            maxColumns: 3,
            spacing: 18,
            children: [
              AppDetailField(
                label: SubscriptionsStrings.owner,
                value: subscription.ownerName,
              ),
              AppDetailField(
                label: SubscriptionsStrings.startDate,
                value: _date(subscription.startedAt),
              ),
              AppDetailField(
                label: SubscriptionsStrings.expiryDate,
                value: _date(subscription.expiresAt),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    SubscriptionsStrings.paymentStatus,
                    style: AppTextStyles.bodyCaption,
                  ),
                  const SizedBox(height: 6),
                  AppPaymentPill(status: subscription.payment),
                ],
              ),
              AppDetailField(
                label: SubscriptionsStrings.newRentalCreation,
                value: SubscriptionLabels.newRentalCreation(subscription),
              ),
              const AppDetailField(
                label: SubscriptionsStrings.existingRecords,
                value: SubscriptionsStrings.viewable,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
