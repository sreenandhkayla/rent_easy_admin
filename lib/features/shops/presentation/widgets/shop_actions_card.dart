import 'package:flutter/material.dart';

import '../../../../core/resources/images/app_images.dart';
import '../../../../core/resources/strings/shops_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_secondary_button.dart';

class ShopActionsCard extends StatelessWidget {
  const ShopActionsCard({
    super.key,
    required this.isRestricted,
    required this.onViewOwner,
    required this.onViewSubscription,
    required this.onRestrict,
    required this.onRestore,
  });

  final bool isRestricted;
  final VoidCallback onViewOwner;
  final VoidCallback onViewSubscription;
  final VoidCallback onRestrict;
  final VoidCallback onRestore;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(ShopsStrings.shopActions, style: AppTextStyles.cardTitle),
          const SizedBox(height: 14),
          AppSecondaryButton(
            label: ShopsStrings.viewOwner,
            svgIcon: AppImages.viewOwnerIcon,
            isExpanded: true,
            labelStyle: AppTextStyles.actionLabel,
            onPressed: onViewOwner,
          ),
          const SizedBox(height: 10),
          AppSecondaryButton(
            label: ShopsStrings.viewSubscription,
            svgIcon: AppImages.subscriptionIcon,
            isExpanded: true,
            labelStyle: AppTextStyles.actionLabel,
            onPressed: onViewSubscription,
          ),
          const SizedBox(height: 10),
          if (isRestricted)
            AppPrimaryButton(
              label: ShopsStrings.restoreShop,
              svgIcon: AppImages.refreshIcon,
              isCompact: true,
              labelStyle: AppTextStyles.actionLabel,
              onPressed: onRestore,
            )
          else
            AppSecondaryButton(
              label: ShopsStrings.restrictShop,
              svgIcon: AppImages.restrictIcon,
              isDestructive: true,
              isExpanded: true,
              labelStyle: AppTextStyles.actionLabel,
              onPressed: onRestrict,
            ),
          const SizedBox(height: 14),
          const Text(ShopsStrings.shopActionsNote, style: AppTextStyles.meta),
        ],
      ),
    );
  }
}
