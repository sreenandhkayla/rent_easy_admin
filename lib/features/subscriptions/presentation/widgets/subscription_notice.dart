import 'package:flutter/material.dart';

import '../../../../core/enums/subscription_status.dart';
import '../../../../core/resources/images/app_images.dart';
import '../../../../core/resources/strings/subscriptions_strings.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/widgets/app_notice_banner.dart';
import '../../data/models/shop_subscription.dart';

class SubscriptionNotice extends StatelessWidget {
  const SubscriptionNotice({super.key, required this.details});

  final SubscriptionDetails details;

  Widget? _banner() {
    final ShopSubscription subscription = details.subscription;
    final DateTime? expiresAt = subscription.expiresAt;
    return switch (subscription.status) {
      SubscriptionStatus.expired => const AppNoticeBanner(
        tone: AppNoticeTone.danger,
        icon: Icons.warning_amber_rounded,
        title: SubscriptionsStrings.expiredTitle,
        message: SubscriptionsStrings.expiredMessage,
      ),
      SubscriptionStatus.expiringSoon => AppNoticeBanner(
        tone: AppNoticeTone.warning,
        icon: Icons.schedule,
        title: SubscriptionsStrings.expiringTitle,
        message: [
          if (expiresAt != null)
            SubscriptionsStrings.expiresOn(AppFormatters.date(expiresAt)),
          SubscriptionsStrings.expiringNotice,
          if (details.hasPendingAttempt) SubscriptionsStrings.expiringPending,
        ].join(' '),
      ),
      SubscriptionStatus.unsubscribed => const AppNoticeBanner(
        tone: AppNoticeTone.info,
        svgIcon: AppImages.subscriptionIcon,
        title: SubscriptionsStrings.noSubscriptionTitle,
        message: SubscriptionsStrings.noSubscriptionMessage,
      ),
      SubscriptionStatus.active => null,
    };
  }

  @override
  Widget build(BuildContext context) {
    final Widget? banner = _banner();
    if (banner == null) return const SizedBox.shrink();
    return Padding(padding: const EdgeInsets.only(bottom: 16), child: banner);
  }
}
