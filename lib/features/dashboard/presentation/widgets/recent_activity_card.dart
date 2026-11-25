import 'package:flutter/material.dart';

import '../../../../core/resources/strings/dashboard_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_status_dot.dart';
import '../../../../core/widgets/app_text_link.dart';
import '../../data/models/dashboard_summary.dart';

class RecentActivityCard extends StatelessWidget {
  const RecentActivityCard({
    super.key,
    required this.activities,
    required this.onOpenActivityLog,
  });

  final List<ActivityEntry> activities;
  final VoidCallback onOpenActivityLog;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  DashboardStrings.recentActivity,
                  style: AppTextStyles.cardTitle,
                ),
              ),
              const SizedBox(width: 8),
              AppTextLink(
                label: DashboardStrings.activityLog,
                onTap: onOpenActivityLog,
              ),
            ],
          ),
          const SizedBox(height: 8),
          for (int i = 0; i < activities.length; i++) ...[
            if (i > 0) const Divider(height: 1, color: AppColors.divider),
            _ActivityTile(entry: activities[i]),
          ],
        ],
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({required this.entry});

  final ActivityEntry entry;

  static String _label(ActivityType type) => switch (type) {
    ActivityType.verifiedRenewal => DashboardStrings.verifiedRenewal,
    ActivityType.subscriptionActivated =>
      DashboardStrings.subscriptionActivated,
    ActivityType.branchRegistered => DashboardStrings.branchRegistered,
    ActivityType.subscriptionExpired => DashboardStrings.subscriptionExpired,
    ActivityType.shopRestricted => DashboardStrings.shopRestricted,
    ActivityType.ownerRegistered => DashboardStrings.ownerRegistered,
  };

  static Color _color(ActivityType type) => switch (type) {
    ActivityType.verifiedRenewal ||
    ActivityType.subscriptionActivated => AppColors.statusGreen,
    ActivityType.branchRegistered => AppColors.ink,
    ActivityType.subscriptionExpired => AppColors.statusRed,
    ActivityType.shopRestricted => AppColors.statusAmber,
    ActivityType.ownerRegistered => AppColors.statusCoral,
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          AppStatusDot(color: _color(entry.type)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_label(entry.type)} · ${entry.subject}',
                  style: AppTextStyles.titleSmall,
                ),
                const SizedBox(height: 2),
                Text(entry.detail, style: AppTextStyles.meta),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(AppFormatters.dayMonth(entry.date), style: AppTextStyles.meta),
        ],
      ),
    );
  }
}
