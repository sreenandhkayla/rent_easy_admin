import 'package:flutter/material.dart';

import '../../../../core/resources/strings/dashboard_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/widgets/app_responsive_grid.dart';
import '../../../../core/widgets/app_stat_card.dart';
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
            AppStatCard(
              label: DashboardStrings.activeSubscriptions,
              value: AppFormatters.number(summary.activeSubscriptions),
              caption: DashboardStrings.activeSubscriptionsCaption,
              dotColor: AppColors.statusGreen,
            ),
            AppStatCard(
              label: DashboardStrings.unsubscribedShops,
              value: AppFormatters.number(summary.unsubscribedShops),
              caption: DashboardStrings.unsubscribedShopsCaption,
              dotColor: AppColors.statusGrey,
            ),
            AppStatCard(
              label: DashboardStrings.expiringSoon,
              value: AppFormatters.number(summary.expiringSoon),
              caption: DashboardStrings.expiringSoonCaption,
              dotColor: AppColors.statusAmber,
            ),
            AppStatCard(
              label: DashboardStrings.expiredSubscriptions,
              value: AppFormatters.number(summary.expiredSubscriptions),
              caption: DashboardStrings.expiredSubscriptionsCaption,
              dotColor: AppColors.statusRed,
            ),
          ],
        ),
      ],
    );
  }
}
