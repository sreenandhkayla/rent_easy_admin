import '../../../../core/access/role_permissions.dart';
import '../../data/models/activity_log_entry.dart';
import '../../data/models/admin_account.dart';
import '../../../../core/enums/admin_role.dart';
import '../../data/models/admin_staff_member.dart';
import '../../data/models/platform_settings.dart';

enum SettingsTab { adminProfile, adminStaff, roles, platform, activity }

enum ProfileStatus { loading, loaded, failure }

enum StaffStatus { loading, loaded, failure }

enum RolesStatus { loading, loaded, failure }

enum PlatformStatus { loading, loaded, failure }

class PasswordErrors {
  const PasswordErrors({this.current, this.newPassword, this.confirm});

  final String? current;
  final String? newPassword;
  final String? confirm;

  bool get isEmpty => current == null && newPassword == null && confirm == null;
}

class PlatformErrors {
  const PlatformErrors({
    this.platformName,
    this.supportEmail,
    this.supportPhone,
  });

  final String? platformName;
  final String? supportEmail;
  final String? supportPhone;

  bool get isEmpty =>
      platformName == null && supportEmail == null && supportPhone == null;
}

class SettingsState {
  const SettingsState({
    this.account,
    this.profileStatus = ProfileStatus.loading,
    this.profileError,
    this.staff = const [],
    this.staffStatus = StaffStatus.loading,
    this.staffError,
    this.staffQuery = '',
    this.activeStaffSearch = '',
    this.staffSearchResults,
    this.isSearchingStaff = false,
    this.staffSearchError,
    this.rolePermissions,
    this.roleDraft,
    this.rolesStatus = RolesStatus.loading,
    this.rolesError,
    this.isSavingRoles = false,
    this.platform,
    this.appVersions,
    this.platformErrors = const PlatformErrors(),
    this.platformStatus = PlatformStatus.loading,
    this.platformError,
    this.isSavingPlatform = false,
    this.platformVersion = 0,
    this.logs = const [],
    this.logQuery = '',
    this.logActor,
    this.tab = SettingsTab.adminProfile,
    this.passwordErrors = const PasswordErrors(),
    this.passwordFormVersion = 0,
    this.updatedAt,
  });

  final AdminAccount? account;
  final ProfileStatus profileStatus;
  final String? profileError;
  final List<AdminStaffMember> staff;
  final StaffStatus staffStatus;
  final String? staffError;
  final String staffQuery;
  final String activeStaffSearch;
  final List<AdminStaffMember>? staffSearchResults;
  final bool isSearchingStaff;
  final String? staffSearchError;

  bool get isStaffSearchActive => activeStaffSearch.isNotEmpty;
  final RolePermissions? rolePermissions;
  final RolePermissions? roleDraft;
  final RolesStatus rolesStatus;
  final String? rolesError;
  final bool isSavingRoles;

  bool get hasRoleChanges => switch ((rolePermissions, roleDraft)) {
    (final RolePermissions saved, final RolePermissions draft) =>
      draft.changedRoles(saved).isNotEmpty,
    _ => false,
  };
  final PlatformSettings? platform;
  final AppVersionInfo? appVersions;
  final PlatformErrors platformErrors;
  final PlatformStatus platformStatus;
  final String? platformError;
  final bool isSavingPlatform;
  final int platformVersion;
  final List<ActivityLogEntry> logs;
  final String logQuery;
  final String? logActor;
  final SettingsTab tab;
  final PasswordErrors passwordErrors;
  final int passwordFormVersion;
  final DateTime? updatedAt;

  List<String> get logActors {
    final List<String> actors = [];
    for (final ActivityLogEntry entry in logs) {
      if (!actors.contains(entry.actor)) actors.add(entry.actor);
    }
    return actors..sort();
  }

  List<ActivityLogEntry> get visibleLogs {
    final String search = logQuery.trim().toLowerCase();
    return logs
        .where(
          (entry) =>
              (logActor == null || entry.actor == logActor) &&
              (search.isEmpty ||
                  entry.action.toLowerCase().contains(search) ||
                  entry.target.toLowerCase().contains(search)),
        )
        .toList()
      ..sort((a, b) => b.at.compareTo(a.at));
  }

  int activeAdminsWith(AdminRole role) => staff
      .where((member) => member.isActive && member.role == role.label)
      .length;

  List<AdminStaffMember> get visibleStaff =>
      isStaffSearchActive ? staffSearchResults ?? staff : staff;

  SettingsState copyWith({
    AdminAccount? account,
    ProfileStatus? profileStatus,
    String? Function()? profileError,
    List<AdminStaffMember>? staff,
    StaffStatus? staffStatus,
    String? Function()? staffError,
    String? staffQuery,
    String? activeStaffSearch,
    List<AdminStaffMember>? Function()? staffSearchResults,
    bool? isSearchingStaff,
    String? Function()? staffSearchError,
    RolePermissions? rolePermissions,
    RolePermissions? roleDraft,
    RolesStatus? rolesStatus,
    String? Function()? rolesError,
    bool? isSavingRoles,
    PlatformSettings? platform,
    AppVersionInfo? appVersions,
    PlatformErrors? platformErrors,
    PlatformStatus? platformStatus,
    String? Function()? platformError,
    bool? isSavingPlatform,
    int? platformVersion,
    List<ActivityLogEntry>? logs,
    String? logQuery,
    String? Function()? logActor,
    SettingsTab? tab,
    PasswordErrors? passwordErrors,
    int? passwordFormVersion,
    DateTime? updatedAt,
  }) {
    return SettingsState(
      account: account ?? this.account,
      profileStatus: profileStatus ?? this.profileStatus,
      profileError: profileError == null ? this.profileError : profileError(),
      staff: staff ?? this.staff,
      staffStatus: staffStatus ?? this.staffStatus,
      staffError: staffError == null ? this.staffError : staffError(),
      staffQuery: staffQuery ?? this.staffQuery,
      activeStaffSearch: activeStaffSearch ?? this.activeStaffSearch,
      staffSearchResults: staffSearchResults == null
          ? this.staffSearchResults
          : staffSearchResults(),
      isSearchingStaff: isSearchingStaff ?? this.isSearchingStaff,
      staffSearchError: staffSearchError == null
          ? this.staffSearchError
          : staffSearchError(),
      rolePermissions: rolePermissions ?? this.rolePermissions,
      roleDraft: roleDraft ?? this.roleDraft,
      rolesStatus: rolesStatus ?? this.rolesStatus,
      rolesError: rolesError == null ? this.rolesError : rolesError(),
      isSavingRoles: isSavingRoles ?? this.isSavingRoles,
      platform: platform ?? this.platform,
      appVersions: appVersions ?? this.appVersions,
      platformErrors: platformErrors ?? this.platformErrors,
      platformStatus: platformStatus ?? this.platformStatus,
      platformError: platformError == null
          ? this.platformError
          : platformError(),
      isSavingPlatform: isSavingPlatform ?? this.isSavingPlatform,
      platformVersion: platformVersion ?? this.platformVersion,
      logs: logs ?? this.logs,
      logQuery: logQuery ?? this.logQuery,
      logActor: logActor == null ? this.logActor : logActor(),
      tab: tab ?? this.tab,
      passwordErrors: passwordErrors ?? this.passwordErrors,
      passwordFormVersion: passwordFormVersion ?? this.passwordFormVersion,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
