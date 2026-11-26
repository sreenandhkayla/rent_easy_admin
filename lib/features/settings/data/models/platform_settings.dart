class PlatformSettings {
  const PlatformSettings({
    required this.platformName,
    required this.supportEmail,
    required this.supportPhone,
    required this.termsUrl,
    required this.privacyUrl,
    required this.expiringWindowDays,
    required this.sessionTimeoutMinutes,
    required this.sendExpiryReminders,
    required this.oneNotificationPerOwner,
    required this.requireTwoStep,
  });

  static const List<int> expiringWindowOptions = [3, 7, 14];
  static const List<int> sessionTimeoutOptions = [15, 30, 60];

  final String platformName;
  final String supportEmail;
  final String supportPhone;
  final String termsUrl;
  final String privacyUrl;
  final int expiringWindowDays;
  final int sessionTimeoutMinutes;
  final bool sendExpiryReminders;
  final bool oneNotificationPerOwner;
  final bool requireTwoStep;

  PlatformSettings copyWith({
    String? platformName,
    String? supportEmail,
    String? supportPhone,
    String? termsUrl,
    String? privacyUrl,
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
      termsUrl: termsUrl ?? this.termsUrl,
      privacyUrl: privacyUrl ?? this.privacyUrl,
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
