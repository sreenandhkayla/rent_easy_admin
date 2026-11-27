import 'package:cloud_firestore/cloud_firestore.dart';

class PlatformSettings {
  const PlatformSettings({
    this.platformName = '',
    this.supportEmail = '',
    this.supportPhone = '',
    this.updatedAt,
    this.expiringWindowDays = 3,
    this.sessionTimeoutMinutes = 15,
    this.sendExpiryReminders = true,
    this.oneNotificationPerOwner = true,
    this.requireTwoStep = true,
  });

  factory PlatformSettings.fromDocument(Map<String, dynamic>? data) {
    if (data == null) return const PlatformSettings();
    final Object? updatedAt = data[updatedAtField];
    return PlatformSettings(
      platformName: _text(data[platformNameField]),
      supportEmail: _text(data[supportEmailField]),
      supportPhone: _text(data[supportPhoneField]),
      updatedAt: updatedAt is Timestamp ? updatedAt.toDate() : null,
    );
  }

  static const String collection = 'settings';
  static const String documentId = 'platform';
  static const String platformNameField = 'platformName';
  static const String supportEmailField = 'supportEmail';
  static const String supportPhoneField = 'supportPhone';
  static const String updatedAtField = 'updatedAt';
  static const String updatedByField = 'updatedBy';

  static const List<int> expiringWindowOptions = [3, 7, 14];
  static const List<int> sessionTimeoutOptions = [15, 30, 60];

  final String platformName;
  final String supportEmail;
  final String supportPhone;
  final DateTime? updatedAt;
  final int expiringWindowDays;
  final int sessionTimeoutMinutes;
  final bool sendExpiryReminders;
  final bool oneNotificationPerOwner;
  final bool requireTwoStep;

  Map<String, Object?> toFields() => {
    platformNameField: platformName.trim(),
    supportEmailField: supportEmail.trim().toLowerCase(),
    supportPhoneField: supportPhone.trim(),
  };

  static String _text(Object? value) => value is String ? value.trim() : '';

  PlatformSettings copyWith({
    String? platformName,
    String? supportEmail,
    String? supportPhone,
    DateTime? updatedAt,
    int? expiringWindowDays,
    int? sessionTimeoutMinutes,
    bool? sendExpiryReminders,
    bool? oneNotificationPerOwner,
    bool? requireTwoStep,
  }) {
    return PlatformSettings(
      platformName: platformName ?? this.platformName,
      supportEmail: supportEmail ?? this.supportEmail,
      supportPhone: supportPhone ?? this.supportPhone,
      updatedAt: updatedAt ?? this.updatedAt,
      expiringWindowDays: expiringWindowDays ?? this.expiringWindowDays,
      sessionTimeoutMinutes:
          sessionTimeoutMinutes ?? this.sessionTimeoutMinutes,
      sendExpiryReminders: sendExpiryReminders ?? this.sendExpiryReminders,
      oneNotificationPerOwner:
          oneNotificationPerOwner ?? this.oneNotificationPerOwner,
      requireTwoStep: requireTwoStep ?? this.requireTwoStep,
    );
  }
}

class AppVersionInfo {
  const AppVersionInfo({
    required this.ownerAndroid,
    required this.ownerIos,
    required this.minimumSupported,
    required this.adminWeb,
  });

  final String ownerAndroid;
  final String ownerIos;
  final String minimumSupported;
  final String adminWeb;
}
