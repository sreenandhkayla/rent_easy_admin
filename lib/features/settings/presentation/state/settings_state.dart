import '../../data/models/activity_log_entry.dart';
import '../../data/models/admin_account.dart';
import '../../../../core/enums/admin_role.dart';
import '../../data/models/admin_staff_member.dart';
import '../../data/models/platform_settings.dart';

enum SettingsTab { adminProfile, adminStaff, roles, platform, activity }

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
    this.termsUrl,
    this.privacyUrl,
  });

  final String? platformName;
  final String? supportEmail;
  final String? supportPhone;
  final String? termsUrl;
  final String? privacyUrl;

  bool get isEmpty =>
      platformName == null &&
      supportEmail == null &&
      supportPhone == null &&
      termsUrl == null &&
      privacyUrl == null;
}

class SettingsState {
  const SettingsState({
    this.account,
    this.staff = const [],
    this.staffQuery = '',
    this.platform,
    this.appVersions,
    this.platformErrors = const PlatformErrors(),
    this.logs = const [],
    this.logQuery = '',
    this.logActor,
    this.tab = SettingsTab.adminProfile,
    this.passwordErrors = const PasswordErrors(),
    this.passwordFormVersion = 0,
    this.updatedAt,
  });

  final AdminAccount? account;
  final List<AdminStaffMember> staff;
  final String staffQuery;
  final PlatformSettings? platform;
  final AppVersionInfo? appVersions;
  final PlatformErrors platformErrors;
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

  List<AdminStaffMember> get visibleStaff {
    final String search = staffQuery.trim().toLowerCase();
    if (search.isEmpty) return staff;
    return staff
        .where(
          (member) =>
              member.name.toLowerCase().contains(search) ||
              member.email.toLowerCase().contains(search),
        )
        .toList();
  }

  SettingsState copyWith({
    AdminAccount? account,
    List<AdminStaffMember>? staff,
    String? staffQuery,
    PlatformSettings? platform,
    AppVersionInfo? appVersions,
    PlatformErrors? platformErrors,
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
      staff: staff ?? this.staff,
      staffQuery: staffQuery ?? this.staffQuery,
      platform: platform ?? this.platform,
      appVersions: appVersions ?? this.appVersions,
      platformErrors: platformErrors ?? this.platformErrors,
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
