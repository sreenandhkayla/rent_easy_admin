import 'package:flutter/material.dart';

import '../../../../core/resources/images/app_images.dart';
import '../../../../core/resources/strings/shops_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/widgets/app_access_status_pill.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_detail_field.dart';
import '../../../../core/widgets/app_icon_circle.dart';
import '../../../../core/widgets/app_responsive_grid.dart';
import '../../data/models/shop.dart';
import 'shop_labels.dart';

class ShopProfileCard extends StatelessWidget {
  const ShopProfileCard({super.key, required this.shop});

  final Shop shop;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const AppIconCircle(svgIcon: AppImages.storeIcon, size: 40),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(shop.name, style: AppTextStyles.profileName),
                    const SizedBox(height: 4),
                    Text(
                      ShopsStrings.shopSummary(
                        shop.shopId,
                        ShopLabels.kind(shop),
                      ),
                      style: AppTextStyles.bodyCaption,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              AppAccessStatusPill(
                isRestricted: shop.status == ShopStatus.restricted,
              ),
            ],
          ),
          const Divider(height: 36, color: AppColors.divider),
          AppResponsiveGrid(
            minItemWidth: 200,
            maxColumns: 2,
            spacing: 18,
            children: [
              AppDetailField(label: ShopsStrings.owner, value: shop.ownerName),
              AppDetailField(label: ShopsStrings.contact, value: shop.contact),
              AppDetailField(
                label: ShopsStrings.shopAddress,
                value: shop.address,
              ),
              AppDetailField(
                label: ShopsStrings.registrationDate,
                value: switch (shop.registeredAt) {
                  final DateTime date => AppFormatters.date(date),
                  null => ShopsStrings.emptyValue,
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
