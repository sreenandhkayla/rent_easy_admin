import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/enums/subscription_status.dart';
import '../../../../core/resources/strings/app_strings.dart';
import '../../../../core/resources/strings/shop_owners_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_secondary_button.dart';
import '../../../../core/widgets/app_subscription_pill.dart';
import '../../../../core/widgets/app_table_header.dart';
import '../../data/models/owner_details.dart';

class LinkedShopsCard extends StatelessWidget {
  const LinkedShopsCard({super.key, required this.shops, required this.onView});

  static const double _minTableWidth = 680;

  final List<LinkedShop> shops;
  final ValueChanged<LinkedShop> onView;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              runSpacing: 6,
              children: const [
                Text(
                  ShopOwnersStrings.linkedShops,
                  style: AppTextStyles.cardTitle,
                ),
                Text(
                  ShopOwnersStrings.linkedShopsNote,
                  style: AppTextStyles.meta,
                ),
              ],
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: math.max(constraints.maxWidth, _minTableWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const AppTableHeader(
                      child: Row(
                        children: [
                          _Cell.header(ShopOwnersStrings.shop, flex: 30),
                          _Cell.header(ShopOwnersStrings.location, flex: 14),
                          _Cell.header(ShopOwnersStrings.plan, flex: 14),
                          _Cell.header(
                            ShopOwnersStrings.subscription,
                            flex: 17,
                          ),
                          _Cell.header(ShopOwnersStrings.expiry, flex: 14),
                          SizedBox(width: _actionWidth),
                        ],
                      ),
                    ),
                    for (int i = 0; i < shops.length; i++)
                      _ShopRow(
                        shop: shops[i],
                        showDivider: i < shops.length - 1,
                        onView: () => onView(shops[i]),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

const double _actionWidth = 72;

class _Cell extends StatelessWidget {
  const _Cell.header(this.label, {required this.flex});

  final String label;
  final int flex;

  @override
  Widget build(BuildContext context) => Expanded(
    flex: flex,
    child: Text(label, style: AppTextStyles.tableHeader),
  );
}

class _ShopRow extends StatelessWidget {
  const _ShopRow({
    required this.shop,
    required this.showDivider,
    required this.onView,
  });

  final LinkedShop shop;
  final bool showDivider;
  final VoidCallback onView;

  @override
  Widget build(BuildContext context) {
    final DateTime? expiresAt = shop.expiresAt;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(bottom: BorderSide(color: AppColors.divider))
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 30,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shop.name.isEmpty ? ShopOwnersStrings.emptyValue : shop.name,
                  style: AppTextStyles.titleSmall,
                ),
                const SizedBox(height: 2),
                Text(
                  shop.isBranch
                      ? '${shop.shopId} · ${ShopOwnersStrings.branch}'
                      : shop.shopId,
                  style: AppTextStyles.meta,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 14,
            child: Text(
              shop.location.isEmpty
                  ? ShopOwnersStrings.emptyValue
                  : shop.location,
              style: AppTextStyles.tableCell,
            ),
          ),
          Expanded(
            flex: 14,
            child: Text(
              shop.plan ?? ShopOwnersStrings.emptyValue,
              style: AppTextStyles.tableCell,
            ),
          ),
          Expanded(
            flex: 17,
            child: Align(
              alignment: Alignment.centerLeft,
              child: switch (shop.subscription) {
                final SubscriptionStatus status => AppSubscriptionPill(
                  status: status,
                ),
                null => const Text(
                  ShopOwnersStrings.notAvailable,
                  style: AppTextStyles.tableCell,
                ),
              },
            ),
          ),
          Expanded(
            flex: 14,
            child: Text(
              expiresAt == null
                  ? ShopOwnersStrings.emptyValue
                  : AppFormatters.date(expiresAt),
              style: AppTextStyles.tableCell,
            ),
          ),
          SizedBox(
            width: _actionWidth,
            child: Align(
              alignment: Alignment.centerRight,
              child: AppSecondaryButton(
                label: AppStrings.view,
                onPressed: onView,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
