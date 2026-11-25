import 'package:flutter/material.dart';

import '../../../../core/enums/subscription_status.dart';
import '../../../../core/resources/strings/subscriptions_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/widgets/app_activity_timeline.dart';
import '../../../../core/widgets/app_card.dart';
import '../../data/models/payment_attempt.dart';
import '../../data/models/shop_subscription.dart';

class RenewalHistoryCard extends StatelessWidget {
  const RenewalHistoryCard({super.key, required this.details});

  final SubscriptionDetails details;

  List<AppTimelineEntry> _entries() {
    final ShopSubscription subscription = details.subscription;
    final DateTime? expiresAt = subscription.expiresAt;
    final String plan = subscription.plan?.label ?? SubscriptionsStrings.noPlan;
    return [
      if (subscription.status == SubscriptionStatus.expired &&
          expiresAt != null)
        AppTimelineEntry(
          title: SubscriptionsStrings.historyExpired,
          subtitle: SubscriptionsStrings.historyLine(
            AppFormatters.date(expiresAt),
            SubscriptionsStrings.historyExpiredDetail,
          ),
          dotColor: AppColors.statusRed,
        ),
      for (final PaymentAttempt attempt in details.attempts)
        AppTimelineEntry(
          title: switch (attempt.status) {
            AttemptStatus.successful => SubscriptionsStrings.historyVerified(
              plan,
            ),
            AttemptStatus.failed => SubscriptionsStrings.historyFailed,
            AttemptStatus.pending => SubscriptionsStrings.historyPending,
          },
          subtitle: SubscriptionsStrings.historyLine(
            AppFormatters.timestamp(attempt.at),
            AppFormatters.rupees(attempt.amount),
          ),
          dotColor: switch (attempt.status) {
            AttemptStatus.successful => AppColors.ink,
            AttemptStatus.failed => AppColors.statusRed,
            AttemptStatus.pending => null,
          },
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final List<AppTimelineEntry> entries = _entries();
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            SubscriptionsStrings.renewalHistory,
            style: AppTextStyles.cardTitle,
          ),
          const SizedBox(height: 16),
          if (entries.isEmpty)
            const Text(
              SubscriptionsStrings.noRenewalHistory,
              style: AppTextStyles.bodyCaption,
            )
          else
            AppActivityTimeline(entries: entries),
        ],
      ),
    );
  }
}
