import 'package:flutter/material.dart';

import '../../../../core/resources/images/app_images.dart';
import '../../../../core/resources/strings/dashboard_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/admin_shell/admin_section.dart';
import '../../../../core/widgets/app_responsive_grid.dart';
import '../../data/models/dashboard_summary.dart';
import 'dashboard_metric_card.dart';

class DashboardMetricsSection extends StatelessWidget {
  const DashboardMetricsSection({
    super.key,
    required this.summary,
    required this.onOpenSection,
  });

  final DashboardSummary summary;
  final ValueChanged<AdminSection> onOpenSection;

  @override
  Widget build(BuildContext context) {
    return AppResponsiveGrid(
      minItemWidth: 260,
      maxColumns: 3,
      children: [
        DashboardMetricCard(
          label: DashboardStrings.totalShops,
          value: summary.totalShops,
          caption: DashboardStrings.totalShopsCaption,
          svgIcon: AppImages.storeIcon,
          dotColor: AppColors.ink,
          onTap: () => onOpenSection(AdminSection.shopsAndBranches),
        ),
        DashboardMetricCard(
          label: DashboardStrings.subscribedShops,
          value: summary.subscribedShops,
          caption: DashboardStrings.subscribedShopsCaption,
          icon: Icons.check_circle_outline,
          dotColor: AppColors.statusGreen,
          onTap: () => onOpenSection(AdminSection.subscriptions),
        ),
        DashboardMetricCard(
          label: DashboardStrings.totalShopOwners,
          value: summary.totalShopOwners,
          caption: DashboardStrings.totalShopOwnersCaption,
          svgIcon: AppImages.usersIcon,
          dotColor: AppColors.statusCoral,
          onTap: () => onOpenSection(AdminSection.shopOwners),
        ),
        DashboardMetricCard(
          label: DashboardStrings.totalItems,
          value: summary.totalItems,
          caption: DashboardStrings.totalItemsCaption,
          svgIcon: AppImages.totalItemsIcon,
        ),
        DashboardMetricCard(
          label: DashboardStrings.totalRentals,
          value: summary.totalRentals,
          caption: DashboardStrings.totalRentalsCaption,
          svgIcon: AppImages.totalRentalsIcon,
        ),
        DashboardMetricCard(
          label: DashboardStrings.totalCustomers,
          value: summary.totalCustomers,
          caption: DashboardStrings.totalCustomersCaption,
          svgIcon: AppImages.totalCustomersIcon,
        ),
      ],
    );
  }
}
