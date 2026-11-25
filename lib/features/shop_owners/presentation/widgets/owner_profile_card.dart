import 'package:flutter/material.dart';

import '../../../../core/resources/strings/shop_owners_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/widgets/app_access_status_pill.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_detail_field.dart';
import '../../../../core/widgets/app_initials_avatar.dart';
import '../../../../core/widgets/app_responsive_grid.dart';
import '../../data/models/owner_details.dart';
import '../../data/models/shop_owner.dart';

class OwnerProfileCard extends StatelessWidget {
  const OwnerProfileCard({super.key, required this.details});

  final OwnerDetails details;

  @override
  Widget build(BuildContext context) {
    final ShopOwner owner = details.owner;
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              AppInitialsAvatar(name: owner.name, size: 56),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(owner.name, style: AppTextStyles.profileName),
                    const SizedBox(height: 4),
                    Text(
                      ShopOwnersStrings.ownerSummary(
                        owner.ownerId,
                        owner.registeredAt,
                      ),
                      style: AppTextStyles.bodyCaption,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              AppAccessStatusPill(
                isRestricted: owner.status == OwnerStatus.restricted,
              ),
            ],
          ),
          const Divider(height: 36, color: AppColors.divider),
          AppResponsiveGrid(
            minItemWidth: 160,
            maxColumns: 3,
            spacing: 18,
            children: [
              AppDetailField(
                label: ShopOwnersStrings.mobileNumber,
                value: owner.mobile,
              ),
              AppDetailField(
                label: ShopOwnersStrings.ownerId,
                value: owner.ownerId,
              ),
              AppDetailField(
                label: ShopOwnersStrings.registrationDate,
                value: AppFormatters.date(owner.registeredAt),
              ),
              AppDetailField(
                label: ShopOwnersStrings.numberOfShops,
                value: '${owner.shops}',
              ),
              AppDetailField(
                label: ShopOwnersStrings.subscribedShops,
                value: '${owner.subscribedShops}',
              ),
              AppDetailField(
                label: ShopOwnersStrings.unsubscribedOrExpired,
                value: '${details.unsubscribedOrExpired}',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
