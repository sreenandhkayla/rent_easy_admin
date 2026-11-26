import '../resources/strings/settings_strings.dart';
import 'admin_role.dart';

const Set<AdminRole> _allRoles = {
  AdminRole.superAdmin,
  AdminRole.operationsAdmin,
  AdminRole.supportAdmin,
};

const Set<AdminRole> _managers = {
  AdminRole.superAdmin,
  AdminRole.operationsAdmin,
};

const Set<AdminRole> _superOnly = {AdminRole.superAdmin};

enum AdminPermission {
  viewDashboard(SettingsStrings.permViewDashboard, _allRoles),
  viewOwnersAndShops(SettingsStrings.permViewOwnersShops, _allRoles),
  restrictOwnersAndShops(SettingsStrings.permRestrictOwnersShops, _managers),
  viewSubscriptions(SettingsStrings.permViewSubscriptions, _allRoles),
  managePlans(SettingsStrings.permManagePlans, _managers),
  reviewReports(SettingsStrings.permReviewReports, _allRoles),
  analyticsExport(SettingsStrings.permAnalyticsExport, _managers),
  sendNotifications(SettingsStrings.permSendNotifications, _managers),
  manageStaff(SettingsStrings.permManageStaff, _superOnly),
  platformSettings(SettingsStrings.permPlatformSettings, _superOnly);

  const AdminPermission(this.label, this.roles);

  final String label;
  final Set<AdminRole> roles;

  bool isGranted(AdminRole role) => roles.contains(role);
}
