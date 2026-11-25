import 'package:flutter/material.dart';

import '../../../../core/resources/strings/subscriptions_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_activity_timeline.dart';
import '../../../../core/widgets/app_card.dart';

class RenewalFlowCard extends StatelessWidget {
  const RenewalFlowCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppCard(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            SubscriptionsStrings.renewalFlow,
            style: AppTextStyles.cardTitle,
          ),
          SizedBox(height: 16),
          AppActivityTimeline(
            entries: [
              AppTimelineEntry(
                title: SubscriptionsStrings.renewalNoticeTitle,
                subtitle: SubscriptionsStrings.renewalNoticeBody,
                isHighlighted: true,
              ),
              AppTimelineEntry(
                title: SubscriptionsStrings.renewalPlanTitle,
                subtitle: SubscriptionsStrings.renewalPlanBody,
                isHighlighted: true,
              ),
              AppTimelineEntry(
                title: SubscriptionsStrings.renewalPaymentTitle,
                subtitle: SubscriptionsStrings.renewalPaymentBody,
                isHighlighted: true,
              ),
              AppTimelineEntry(
                title: SubscriptionsStrings.renewalVerifyTitle,
                subtitle: SubscriptionsStrings.renewalVerifyBody,
                dotColor: AppColors.statusCoral,
              ),
              AppTimelineEntry(
                title: SubscriptionsStrings.renewalValidityTitle,
                subtitle: SubscriptionsStrings.renewalValidityBody,
                isHighlighted: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
