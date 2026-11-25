import 'package:flutter/material.dart';

import '../../../../core/resources/images/app_images.dart';
import '../../../../core/resources/strings/subscriptions_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_secondary_button.dart';

class SubscriptionActionsCard extends StatelessWidget {
  const SubscriptionActionsCard({
    super.key,
    required this.onViewShop,
    required this.onViewOwner,
    required this.onSimulateRenewal,
  });

  final VoidCallback onViewShop;
  final VoidCallback onViewOwner;
  final VoidCallback onSimulateRenewal;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            SubscriptionsStrings.actions,
            style: AppTextStyles.cardTitle,
          ),
          const SizedBox(height: 14),
          AppSecondaryButton(
            label: SubscriptionsStrings.viewShop,
            svgIcon: AppImages.storeIcon,
            isExpanded: true,
            labelStyle: AppTextStyles.actionLabel,
            onPressed: onViewShop,
          ),
          const SizedBox(height: 10),
          AppSecondaryButton(
            label: SubscriptionsStrings.viewOwner,
            svgIcon: AppImages.viewOwnerIcon,
            isExpanded: true,
            labelStyle: AppTextStyles.actionLabel,
            onPressed: onViewOwner,
          ),
          const Divider(height: 28, color: AppColors.divider),
          const Text(
            SubscriptionsStrings.renewalFlowTitle,
            style: AppTextStyles.titleSmall,
          ),
          const SizedBox(height: 8),
          const Text(
            SubscriptionsStrings.renewalFlowNote,
            style: AppTextStyles.meta,
          ),
          const SizedBox(height: 12),
          AppPrimaryButton(
            label: SubscriptionsStrings.simulateRenewal,
            svgIcon: AppImages.rightMarkIcon,
            isCompact: true,
            labelStyle: AppTextStyles.actionLabel,
            onPressed: onSimulateRenewal,
          ),
          const SizedBox(height: 12),
          const Text(
            SubscriptionsStrings.billingNote,
            style: AppTextStyles.meta,
          ),
        ],
      ),
    );
  }
}
