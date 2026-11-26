import 'package:flutter/material.dart';

import '../../../../core/enums/subscription_status.dart';
import '../../../../core/resources/strings/shops_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_payment_pill.dart';
import '../../../../core/widgets/app_detail_field.dart';
import '../../../../core/widgets/app_responsive_grid.dart';
import '../../../../core/widgets/app_subscription_pill.dart';
import '../../../../core/widgets/app_text_link.dart';
import '../../data/models/shop.dart';
import 'shop_labels.dart';

class ShopSubscriptionCard extends StatelessWidget {
  const ShopSubscriptionCard({
    super.key,
    required this.shop,
    required this.onViewSubscription,
  });

  final Shop shop;
  final VoidCallback onViewSubscription;

  String get _newRentalCreation {
    if (shop.status == ShopStatus.restricted) {
      return ShopsStrings.blockedShopRestricted;
    }
    return switch (shop.subscription) {
      SubscriptionStatus.active ||
      SubscriptionStatus.expiringSoon => ShopsStrings.allowed,
      SubscriptionStatus.expired ||
      SubscriptionStatus.unsubscribed => ShopsStrings.restricted,
      null => ShopsStrings.emptyValue,
    };
  }

  String _date(DateTime? date) =>
      date == null ? ShopsStrings.emptyValue : AppFormatters.date(date);

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
                ShopsStrings.subscriptionSummary,
                style: AppTextStyles.cardTitle,
              ),
              AppTextLink(
                label: ShopsStrings.viewSubscription,
                onTap: onViewSubscription,
              ),
            ],
          ),
          const SizedBox(height: 16),
          AppResponsiveGrid(
            minItemWidth: 160,
            maxColumns: 3,
            spacing: 18,
            children: [
              AppDetailField(
                label: ShopsStrings.currentPlan,
                value: ShopLabels.plan(shop),
              ),
              _PillField(
                label: ShopsStrings.status,
                pill: switch (shop.subscription) {
                  final SubscriptionStatus status => AppSubscriptionPill(
                    status: status,
                  ),
                  null => const Text(
                    ShopsStrings.notAvailable,
                    style: AppTextStyles.tableCell,
                  ),
                },
              ),
              _PillField(
                label: ShopsStrings.lastPayment,
                pill: AppPaymentPill(status: shop.lastPayment),
              ),
              AppDetailField(
                label: ShopsStrings.startDate,
                value: _date(shop.startedAt),
              ),
              AppDetailField(
                label: ShopsStrings.expiryDate,
                value: _date(shop.expiresAt),
              ),
              AppDetailField(
                label: ShopsStrings.newRentalCreation,
                value: _newRentalCreation,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PillField extends StatelessWidget {
  const _PillField({required this.label, required this.pill});

  final String label;
  final Widget pill;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.bodyCaption),
        const SizedBox(height: 6),
        pill,
      ],
    );
  }
}
