import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/enums/subscription_status.dart';

import '../../../../core/resources/images/app_images.dart';
import '../../../../core/resources/strings/shops_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_icon_circle.dart';
import '../../../../core/widgets/app_subscription_pill.dart';
import '../../data/models/shop.dart';

class RelatedBranchesCard extends StatelessWidget {
  const RelatedBranchesCard({
    super.key,
    required this.branches,
    required this.onOpen,
  });

  final List<Shop> branches;
  final ValueChanged<Shop> onOpen;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 6,
            children: [
              const Text(
                ShopsStrings.relatedBranches,
                style: AppTextStyles.cardTitle,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    AppImages.branchIcon,
                    width: 14,
                    height: 14,
                    colorFilter: const ColorFilter.mode(
                      AppColors.textSecondary,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    ShopsStrings.relatedBranchesNote,
                    style: AppTextStyles.meta,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (branches.isEmpty)
            const Text(
              ShopsStrings.noRelatedBranches,
              style: AppTextStyles.bodyCaption,
            ),
          for (int i = 0; i < branches.length; i++) ...[
            if (i > 0) const Divider(height: 1, color: AppColors.divider),
            _BranchTile(shop: branches[i], onTap: () => onOpen(branches[i])),
          ],
        ],
      ),
    );
  }
}

class _BranchTile extends StatelessWidget {
  const _BranchTile({required this.shop, required this.onTap});

  final Shop shop;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            const AppIconCircle(svgIcon: AppImages.branchIcon),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(shop.name, style: AppTextStyles.titleSmall),
                  const SizedBox(height: 2),
                  Text(
                    ShopsStrings.branchSummary(
                      shop.isBranch
                          ? ShopsStrings.branchOf(shop.branchOf!)
                          : ShopsStrings.mainShop,
                      shop.city,
                    ),
                    style: AppTextStyles.meta,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            if (shop.subscription case final SubscriptionStatus status)
              AppSubscriptionPill(status: status),
            const SizedBox(width: 12),
            const Icon(
              Icons.chevron_right,
              size: 18,
              color: AppColors.textPrimary,
            ),
          ],
        ),
      ),
    );
  }
}
