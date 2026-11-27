import 'models/activity_log_entry.dart';
import 'models/platform_settings.dart';

class SettingsMockData {
  SettingsMockData._();

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
}
