import 'package:flutter/material.dart';

import '../../../../core/resources/images/app_images.dart';
import '../../../../core/resources/strings/dashboard_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/admin_shell/admin_section.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_icon_circle.dart';
import '../../../../core/widgets/app_status_pill.dart';
import '../../data/models/dashboard_summary.dart';

class PendingWorkCard extends StatelessWidget {
  const PendingWorkCard({
    super.key,
    required this.summary,
    required this.onOpenSection,
  });

  final DashboardSummary summary;
  final ValueChanged<AdminSection> onOpenSection;

  @override
  Widget build(BuildContext context) {
    final List<_PendingItem> items = [
      _PendingItem(
        svgIcon: AppImages.reportIcon,
        title: DashboardStrings.reportsAwaitingReview,
        detail: DashboardStrings.reportsDetail(
          summary.reportsPending,
          summary.reportsUnderReview,
        ),
        section: AdminSection.reportsAndComplaints,
      ),
      _PendingItem(
        icon: Icons.warning_amber_rounded,
        title: DashboardStrings.shopsRequiringAttention,
        detail: DashboardStrings.restrictedShopsDetail(summary.restrictedShops),
        section: AdminSection.shopsAndBranches,
      ),
      _PendingItem(
        svgIcon: AppImages.subscriptionIcon,
        title: DashboardStrings.failedPayments,
        detail: DashboardStrings.failedPaymentsDetail(
          summary.failedPaymentsThisMonth,
          summary.failedPaymentsPendingVerification,
        ),
        section: AdminSection.subscriptions,
      ),
      _PendingItem(
        icon: Icons.schedule,
        title: DashboardStrings.expiringSubscriptions,
        detail: DashboardStrings.expiringDetail(summary.expiringSoon),
        section: AdminSection.subscriptions,
      ),
    ];
    return AppCard(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  DashboardStrings.pendingWork,
                  style: AppTextStyles.cardTitle,
                ),
              ),
              const SizedBox(width: 8),
              AppStatusPill(
                label: DashboardStrings.openCount(summary.pendingWorkOpen),
                color: AppColors.pillAmberText,
                backgroundColor: AppColors.pillAmberBackground,
              ),
            ],
          ),
          const SizedBox(height: 8),
          for (int i = 0; i < items.length; i++) ...[
            if (i > 0) const Divider(height: 1, color: AppColors.divider),
            _PendingWorkTile(
              item: items[i],
              onTap: () => onOpenSection(items[i].section),
            ),
          ],
        ],
      ),
    );
  }
}

class _PendingItem {
  const _PendingItem({
    this.icon,
    this.svgIcon,
    required this.title,
    required this.detail,
    required this.section,
  });

  final IconData? icon;
  final String? svgIcon;
  final String title;
  final String detail;
  final AdminSection section;
}

class _PendingWorkTile extends StatelessWidget {
  const _PendingWorkTile({required this.item, required this.onTap});

  final _PendingItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            AppIconCircle(icon: item.icon, svgIcon: item.svgIcon, size: 40),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, style: AppTextStyles.titleSmall),
                  const SizedBox(height: 2),
                  Text(item.detail, style: AppTextStyles.meta),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right,
              size: 18,
              color: AppColors.textPrimary,
            ),
          ],
        ),
      ),
    );
  }
}
