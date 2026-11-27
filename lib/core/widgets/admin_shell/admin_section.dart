import '../../enums/admin_permission.dart';
import '../../navigation/app_routes.dart';
import '../../resources/images/app_images.dart';
import '../../resources/strings/app_strings.dart';

enum AdminSection {
  dashboard(
    AppStrings.navDashboard,
    svgIcon: AppImages.dashboardIcon,
    route: AppRoutes.dashboard,
    permission: AdminPermission.viewDashboard,
    accessSummary: AppStrings.accessDashboard,
  ),
  shopOwners(
    AppStrings.navShopOwners,
    svgIcon: AppImages.usersIcon,
    route: AppRoutes.shopOwners,
    permission: AdminPermission.viewOwnersAndShops,
    accessSummary: AppStrings.accessOwnersAndShops,
  ),
  shopsAndBranches(
    AppStrings.navShopsAndBranches,
    svgIcon: AppImages.storeIcon,
    route: AppRoutes.shops,
    permission: AdminPermission.viewOwnersAndShops,
    accessSummary: AppStrings.accessOwnersAndShops,
  ),
  subscriptions(
    AppStrings.navSubscriptions,
    svgIcon: AppImages.subscriptionIcon,
    route: AppRoutes.subscriptions,
    permission: AdminPermission.viewSubscriptions,
    accessSummary: AppStrings.accessSubscriptions,
  ),
  reportsAndComplaints(
    AppStrings.navReportsAndComplaints,
    svgIcon: AppImages.reportIcon,
    route: AppRoutes.reports,
    permission: AdminPermission.reviewReports,
    accessSummary: AppStrings.accessReports,
  ),
  analyticsAndReports(
    AppStrings.navAnalyticsAndReports,
    svgIcon: AppImages.analyticsIcon,
    route: AppRoutes.analytics,
    permission: AdminPermission.analyticsExport,
    accessSummary: AppStrings.accessAnalytics,
  ),
  notifications(
    AppStrings.navNotifications,
    svgIcon: AppImages.notificationIcon,
    route: AppRoutes.notifications,
    permission: AdminPermission.sendNotifications,
    accessSummary: AppStrings.accessNotifications,
  ),
  settings(
    AppStrings.navSettings,
    svgIcon: AppImages.settingsIcon,
    route: AppRoutes.settings,
    permission: AdminPermission.manageStaff,
    accessSummary: AppStrings.accessSettings,
  );

  const AdminSection(
    this.label, {
    required this.svgIcon,
    required this.accessSummary,
    this.route,
    this.permission,
  });

  final String label;
  final String svgIcon;
  final String? route;
  final AdminPermission? permission;
  final String accessSummary;
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
