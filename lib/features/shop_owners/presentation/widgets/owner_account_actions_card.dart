import 'package:flutter/material.dart';

import '../../../../core/resources/images/app_images.dart';
import '../../../../core/resources/strings/shop_owners_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_secondary_button.dart';

class OwnerAccountActionsCard extends StatelessWidget {
  const OwnerAccountActionsCard({
    super.key,
    required this.isRestricted,
    required this.onViewLinkedShops,
    required this.onRestrict,
    required this.onRestore,
  });

  final bool isRestricted;
  final VoidCallback onViewLinkedShops;
  final VoidCallback onRestrict;
  final VoidCallback onRestore;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            ShopOwnersStrings.accountActions,
            style: AppTextStyles.cardTitle,
          ),
          const SizedBox(height: 14),
          AppSecondaryButton(
            label: ShopOwnersStrings.viewLinkedShops,
            svgIcon: AppImages.storeIcon,
            isExpanded: true,
            onPressed: onViewLinkedShops,
          ),
          const SizedBox(height: 10),
          isRestricted
              ? AppSecondaryButton(
                  label: ShopOwnersStrings.restoreAccount,
                  icon: Icons.lock_open_outlined,
                  isExpanded: true,
                  onPressed: onRestore,
                )
              : AppSecondaryButton(
                  label: ShopOwnersStrings.restrictAccount,
                  svgIcon: AppImages.restrictIcon,
                  isDestructive: true,
                  isExpanded: true,
                  onPressed: onRestrict,
                ),
          const SizedBox(height: 14),
          const Text(
            ShopOwnersStrings.accountActionsNote,
            style: AppTextStyles.meta,
          ),
        ],
      ),
    );
  }
}
