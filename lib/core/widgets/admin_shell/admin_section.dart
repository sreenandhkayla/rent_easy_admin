import 'package:flutter/material.dart';

import '../../navigation/app_routes.dart';
import '../../resources/images/app_images.dart';
import '../../resources/strings/app_strings.dart';

enum AdminSection {
  dashboard(
    AppStrings.navDashboard,
    icon: Icons.grid_view_outlined,
    route: AppRoutes.dashboard,
  ),
  shopOwners(
    AppStrings.navShopOwners,
    svgIcon: AppImages.usersIcon,
    route: AppRoutes.shopOwners,
  ),
  shopsAndBranches(
    AppStrings.navShopsAndBranches,
    svgIcon: AppImages.storeIcon,
    route: AppRoutes.shops,
  ),
  subscriptions(
    AppStrings.navSubscriptions,
    svgIcon: AppImages.subscriptionIcon,
  ),
  reportsAndComplaints(
    AppStrings.navReportsAndComplaints,
    svgIcon: AppImages.reportIcon,
  ),
  analyticsAndReports(
    AppStrings.navAnalyticsAndReports,
    svgIcon: AppImages.analyticsIcon,
  ),
  notifications(
    AppStrings.navNotifications,
    svgIcon: AppImages.notificationIcon,
  ),
  settings(AppStrings.navSettings, svgIcon: AppImages.settingsIcon);

  const AdminSection(this.label, {this.icon, this.svgIcon, this.route});

  final String label;
  final IconData? icon;
  final String? svgIcon;
  final String? route;
}

class AdminBadgeCounts {
  AdminBadgeCounts._();

  static const Map<AdminSection, int> sample = {
    AdminSection.reportsAndComplaints: 3,
  };
}

class AdminProfile {
  const AdminProfile({required this.name, required this.role});

  final String name;
  final String role;

  static const AdminProfile current = AdminProfile(
    name: 'Arjun Raghavan',
    role: 'Super Admin',
  );
}
