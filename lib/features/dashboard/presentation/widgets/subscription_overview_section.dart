import 'package:flutter/material.dart';

import '../../../../core/resources/strings/dashboard_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_responsive_grid.dart';
import '../../../../core/widgets/app_status_dot.dart';
import '../../../../core/widgets/app_text_link.dart';
import '../../data/models/dashboard_summary.dart';

class SubscriptionOverviewSection extends StatelessWidget {
  const SubscriptionOverviewSection({
    super.key,
    required this.summary,
    required this.onViewSubscriptions,
  });

  final DashboardSummary summary;
  final VoidCallback onViewSubscriptions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12,
          runSpacing: 8,
          children: [
            const Text(
              DashboardStrings.subscriptionOverview,
              style: AppTextStyles.sectionTitle,
            ),
            AppTextLink(
              label: DashboardStrings.viewSubscriptions,
              onTap: onViewSubscriptions,
            ),
          ],
        ),
        const SizedBox(height: 14),
        AppResponsiveGrid(
          minItemWidth: 200,
          children: [
            _SubscriptionStatCard(
              label: DashboardStrings.activeSubscriptions,
              value: summary.activeSubscriptions,
              caption: DashboardStrings.activeSubscriptionsCaption,
              dotColor: AppColors.statusGreen,
            ),
            _SubscriptionStatCard(
              label: DashboardStrings.unsubscribedShops,
              value: summary.unsubscribedShops,
              caption: DashboardStrings.unsubscribedShopsCaption,
              dotColor: AppColors.statusGrey,
            ),
            _SubscriptionStatCard(
              label: DashboardStrings.expiringSoon,
              value: summary.expiringSoon,
              caption: DashboardStrings.expiringSoonCaption,
              dotColor: AppColors.statusAmber,
            ),
            _SubscriptionStatCard(
              label: DashboardStrings.expiredSubscriptions,
              value: summary.expiredSubscriptions,
              caption: DashboardStrings.expiredSubscriptionsCaption,
              dotColor: AppColors.statusRed,
            ),
          ],
        ),
      ],
    );
  }
}

class _SubscriptionStatCard extends StatelessWidget {
  const _SubscriptionStatCard({
    required this.label,
    required this.value,
    required this.caption,
    required this.dotColor,
  });

  final String label;
  final int value;
  final String caption;
  final Color dotColor;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppStatusDot(color: dotColor),
              const SizedBox(width: 8),
              Expanded(child: Text(label, style: AppTextStyles.labelRegular)),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            AppFormatters.number(value),
            style: AppTextStyles.statValueMedium,
          ),
          const Spacer(),
          const SizedBox(height: 8),
          Text(caption, style: AppTextStyles.meta),
        ],
      ),
    );
  }
}
