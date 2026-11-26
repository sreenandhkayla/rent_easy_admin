import 'package:flutter/material.dart';

import '../../../../core/resources/strings/subscriptions_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/widgets/app_activity_timeline.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_secondary_button.dart';
import '../../data/models/payment_attempt.dart';
import '../../data/models/subscription_payment.dart';

class VerificationTimelineCard extends StatelessWidget {
  const VerificationTimelineCard({
    super.key,
    required this.payment,
    required this.onViewShopSubscription,
  });

  final SubscriptionPayment payment;
  final VoidCallback onViewShopSubscription;

  List<AppTimelineEntry> _entries() {
    final AppTimelineEntry initiated = AppTimelineEntry(
      title: SubscriptionsStrings.timelineInitiated,
      subtitle: AppFormatters.timestamp(payment.paidAt),
      dotColor: AppColors.ink,
    );
    final String providerRef = SubscriptionsStrings.providerRef(
      payment.providerReference,
    );
    final String? invoice = payment.invoiceNumber;
    if (payment.status == AttemptStatus.failed) {
      return [
        initiated,
        AppTimelineEntry(
          title: SubscriptionsStrings.timelineProviderReturnedFailure,
          subtitle:
              payment.failureReason ??
              SubscriptionsStrings.defaultFailureReason,
          dotColor: AppColors.danger,
        ),
        const AppTimelineEntry(
          title: SubscriptionsStrings.timelineEntitlementUnchanged,
          subtitle: SubscriptionsStrings.timelineOwnerRetry,
        ),
      ];
    }
    if (!payment.isVerified || invoice == null) {
      return [
        initiated,
        AppTimelineEntry(
          title: SubscriptionsStrings.timelineProviderAwaited,
          subtitle: providerRef,
        ),
        const AppTimelineEntry(
          title: SubscriptionsStrings.timelineBackendVerification,
          subtitle: SubscriptionsStrings.timelineNotStarted,
        ),
        const AppTimelineEntry(
          title: SubscriptionsStrings.timelineEntitlementUpdate,
          subtitle: SubscriptionsStrings.timelineWaitingVerification,
        ),
      ];
    }
    return [
      initiated,
      AppTimelineEntry(
        title: SubscriptionsStrings.timelineProviderConfirmed,
        subtitle: providerRef,
        dotColor: AppColors.ink,
      ),
      const AppTimelineEntry(
        title: SubscriptionsStrings.timelineBackendVerified,
        subtitle: SubscriptionsStrings.timelineIdempotent,
        dotColor: AppColors.ink,
      ),
      AppTimelineEntry(
        title: SubscriptionsStrings.timelineEntitlementUpdated,
        subtitle: SubscriptionsStrings.receiptRef(invoice),
        dotColor: AppColors.statusCoral,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            SubscriptionsStrings.verificationTimeline,
            style: AppTextStyles.cardTitle,
          ),
          const SizedBox(height: 16),
          AppActivityTimeline(entries: _entries()),
          const SizedBox(height: 16),
          AppSecondaryButton(
            label: SubscriptionsStrings.viewShopSubscription,
            isExpanded: true,
            labelStyle: AppTextStyles.actionLabel,
            onPressed: onViewShopSubscription,
          ),
        ],
      ),
    );
  }
}
