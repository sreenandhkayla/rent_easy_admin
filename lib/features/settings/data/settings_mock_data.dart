import 'models/activity_log_entry.dart';
import 'models/admin_account.dart';
import 'models/admin_staff_member.dart';
import 'models/platform_settings.dart';

class SettingsMockData {
  SettingsMockData._();

  static PlatformSettings _platform = const PlatformSettings(
    platformName: 'ToolRent',
    supportEmail: 'support@toolrent.in',
    supportPhone: '+91 484 400 1200',
    termsUrl: 'https://toolrent.in/terms',
    privacyUrl: 'https://toolrent.in/privacy',
    expiringWindowDays: 3,
    sessionTimeoutMinutes: 15,
    sendExpiryReminders: true,
    oneNotificationPerOwner: true,
    requireTwoStep: true,
  );

  static PlatformSettings platformSettings() => _platform;

  static void savePlatformSettings(PlatformSettings settings) =>
      _platform = settings;

  static AppVersionInfo appVersions() => const AppVersionInfo(
    ownerAndroid: '3.4.0',
    ownerIos: '3.4.0',
    minimumSupported: '3.2.0',
    adminWeb: '1.0.0-prototype',
  );

  static List<ActivityLogEntry> activityLogs() => [
    ActivityLogEntry(
      at: DateTime(2026, 11, 24, 11, 12),
      actor: 'Meera Suresh',
      action: 'Assigned report',
      target: 'RPT-3092',
    ),
    ActivityLogEntry(
      at: DateTime(2026, 11, 22, 10, 44),
      actor: 'System',
      action: 'Subscription renewed (verified payment)',
      target: 'Kumar Construction Rentals',
    ),
    ActivityLogEntry(
      at: DateTime(2026, 11, 22, 9, 20),
      actor: 'System',
      action: 'Subscription activated (verified payment)',
      target: 'Muhammed Machinery',
    ),
    ActivityLogEntry(
      at: DateTime(2026, 11, 21, 16, 30),
      actor: 'System',
      action: 'Branch registered',
      target: 'Muhammed Machinery – Tirur',
    ),
    ActivityLogEntry(
      at: DateTime(2026, 11, 20, 18, 6),
      actor: 'System',
      action: 'Subscription expired',
      target: 'Chandran Auto Rentals',
    ),
    ActivityLogEntry(
      at: DateTime(2026, 11, 20, 15, 30),
      actor: 'Arjun Raghavan',
      action: 'Started review',
      target: 'RPT-3101',
    ),
    ActivityLogEntry(
      at: DateTime(2026, 11, 18, 11, 30),
      actor: 'Arjun Raghavan',
      action: 'Sent notification',
      target: 'N-495',
    ),
    ActivityLogEntry(
      at: DateTime(2026, 11, 17, 12, 8),
      actor: 'Meera Suresh',
      action: 'Restricted shop',
      target: 'Salam Generators',
      reason: 'Repeated safety complaints under review',
    ),
    ActivityLogEntry(
      at: DateTime(2026, 11, 17, 12, 5),
      actor: 'Meera Suresh',
      action: 'Restricted owner account',
      target: 'Abdul Salam',
      reason: 'Linked to restricted shop pending review',
    ),
    ActivityLogEntry(
      at: DateTime(2026, 11, 15, 11, 38),
      actor: 'System',
      action: 'Subscription expired',
      target: 'Menon Car Rentals',
    ),
    ActivityLogEntry(
      at: DateTime(2026, 11, 14, 9, 40),
      actor: 'Arjun Raghavan',
      action: 'Updated plan',
      target: 'Professional',
      reason: 'Benefit list updated',
    ),
    ActivityLogEntry(
      at: DateTime(2026, 11, 2, 9, 1),
      actor: 'System',
      action: 'Subscription expired',
      target: 'Kumar Construction – Aluva',
    ),
  ];

  static List<AdminStaffMember> staff() => List.of(_staff);

  static bool emailExists(String email, {String? exceptAdminId}) {
    final String normalized = email.trim().toLowerCase();
    return _staff.any(
      (member) =>
          member.adminId != exceptAdminId &&
          member.email.toLowerCase() == normalized,
    );
  }

  static AdminStaffMember? staffMember(String adminId) {
    for (final AdminStaffMember member in _staff) {
      if (member.adminId == adminId) return member;
    }
    return null;
  }

  static bool isLastActiveSuperAdmin(String adminId, String superAdminRole) {
    final List<AdminStaffMember> active = _staff
        .where((member) => member.isActive && member.role == superAdminRole)
        .toList();
    return active.length == 1 && active.first.adminId == adminId;
  }

  static void updateStaff(AdminStaffMember member) {
    final int index = _staff.indexWhere(
      (item) => item.adminId == member.adminId,
    );
    if (index < 0) return;
    _staff[index] = member;
    if (member.adminId == _currentAdmin.adminId) {
      _currentAdmin = _currentAdmin.copyWith(
        name: member.name,
        email: member.email,
        role: member.role,
      );
    }
  }

  static void removeStaff(String adminId) =>
      _staff.removeWhere((member) => member.adminId == adminId);

  static String nextAdminId() {
    int highest = 0;
    for (final AdminStaffMember member in _staff) {
      final int number =
          int.tryParse(member.adminId.replaceFirst('ADM-', '')) ?? 0;
      if (number > highest) highest = number;
    }
    return 'ADM-${(highest + 1).toString().padLeft(2, '0')}';
  }

  static void addStaff(AdminStaffMember member) => _staff.add(member);

  static final List<AdminStaffMember> _staff = [
    AdminStaffMember(
      adminId: 'ADM-01',
      name: 'Arjun Raghavan',
      email: 'arjun.r@toolrent.in',
      role: 'Super Admin',
      isActive: true,
      lastSignInAt: DateTime(2026, 11, 24, 14, 20),
    ),
    AdminStaffMember(
      adminId: 'ADM-02',
      name: 'Meera Suresh',
      email: 'meera.s@toolrent.in',
      role: 'Operations Admin',
      isActive: true,
      lastSignInAt: DateTime(2026, 11, 24, 11, 5),
    ),
    AdminStaffMember(
      adminId: 'ADM-03',
      name: 'Kiran Joseph',
      email: 'kiran.j@toolrent.in',
      role: 'Support Admin',
      isActive: true,
      lastSignInAt: DateTime(2026, 11, 23, 18, 40),
    ),
    AdminStaffMember(
      adminId: 'ADM-04',
      name: 'Lakshmi Menon',
      email: 'lakshmi.m@toolrent.in',
      role: 'Operations Admin',
      isActive: true,
      lastSignInAt: DateTime(2026, 11, 22, 9, 55),
    ),
    AdminStaffMember(
      adminId: 'ADM-05',
      name: 'Sana Ibrahim',
      email: 'sana.i@toolrent.in',
      role: 'Support Admin',
      isActive: true,
      lastSignInAt: DateTime(2026, 11, 21, 16, 12),
    ),
    AdminStaffMember(
      adminId: 'ADM-06',
      name: 'Nikhil Das',
      email: 'nikhil.d@toolrent.in',
      role: 'Support Admin',
      isActive: false,
      lastSignInAt: DateTime(2026, 9, 2, 10, 30),
    ),
  ];

  static AdminAccount currentAdmin() => _currentAdmin;

  static void updateCurrentAdmin({
    required String name,
    required String mobileNumber,
  }) {
    _currentAdmin = _currentAdmin.copyWith(
      name: name,
      mobileNumber: mobileNumber,
    );
    final int index = _staff.indexWhere(
      (member) => member.adminId == _currentAdmin.adminId,
    );
    if (index >= 0) _staff[index] = _staff[index].copyWith(name: name);
  }

  static AdminAccount _currentAdmin = AdminAccount(
    adminId: 'ADM-01',
    name: 'Arjun Raghavan',
    role: 'Super Admin',
    email: 'arjun.r@toolrent.in',
    mobileNumber: '+91 98950 11220',
    lastSignInAt: DateTime(2026, 11, 24, 14, 20),
    lastSignInPlace: 'Kochi',
    isTwoStepEnabled: true,
  );
}
