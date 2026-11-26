import '../resources/strings/settings_strings.dart';

enum AdminRole {
  superAdmin(
    SettingsStrings.roleSuperAdmin,
    SettingsStrings.roleSuperAdminNote,
  ),
  operationsAdmin(
    SettingsStrings.roleOperationsAdmin,
    SettingsStrings.roleOperationsAdminNote,
  ),
  supportAdmin(
    SettingsStrings.roleSupportAdmin,
    SettingsStrings.roleSupportAdminNote,
  );

  const AdminRole(this.label, this.description);

  final String label;
  final String description;
}
