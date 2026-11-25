import 'package:flutter/material.dart';

import '../../../../core/enums/subscription_status.dart';
import '../../../../core/resources/images/app_images.dart';
import '../../../../core/resources/strings/shops_strings.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/widgets/app_notice_banner.dart';
import '../../data/models/shop.dart';

class ShopNotices extends StatelessWidget {
  const ShopNotices({super.key, required this.shop});

  final Shop shop;

  List<Widget> _banners() {
    final DateTime? expiresAt = shop.expiresAt;
    final String expiry = expiresAt == null
        ? ''
        : AppFormatters.date(expiresAt);
    return [
      if (shop.subscription == SubscriptionStatus.expired)
        AppNoticeBanner(
          tone: AppNoticeTone.danger,
          icon: Icons.warning_amber_rounded,
          title: ShopsStrings.expiredTitle(expiry),
          message: ShopsStrings.expiredMessage,
        ),
      if (shop.subscription == SubscriptionStatus.expiringSoon)
        AppNoticeBanner(
          tone: AppNoticeTone.warning,
          icon: Icons.schedule,
          title: ShopsStrings.expiringTitle(expiry),
          message: ShopsStrings.expiringMessage,
        ),
      if (shop.subscription == SubscriptionStatus.unsubscribed)
        const AppNoticeBanner(
          tone: AppNoticeTone.info,
          svgIcon: AppImages.subscriptionIcon,
          title: ShopsStrings.noSubscriptionTitle,
          message: ShopsStrings.noSubscriptionMessage,
        ),
      if (shop.status == ShopStatus.restricted)
        const AppNoticeBanner(
          tone: AppNoticeTone.danger,
          svgIcon: AppImages.restrictIcon,
          title: ShopsStrings.restrictedTitle,
          message: ShopsStrings.restrictedMessage,
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> banners = _banners();
    if (banners.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int i = 0; i < banners.length; i++) ...[
            if (i > 0) const SizedBox(height: 16),
            banners[i],
          ],
        ],
      ),
    );
  }
}
