import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rent_easy_admin/features/settings/data/models/platform_settings.dart';

void main() {
  test('a missing document gives empty settings', () {
    final PlatformSettings settings = PlatformSettings.fromDocument(null);
    expect(settings.platformName, isEmpty);
    expect(settings.supportEmail, isEmpty);
    expect(settings.supportPhone, isEmpty);
    expect(settings.updatedAt, isNull);
  });

  test('reads the stored fields', () {
    final DateTime at = DateTime(2026, 11, 27, 10, 30);
    final PlatformSettings settings = PlatformSettings.fromDocument({
      'platformName': ' RentEasy ',
      'supportEmail': 'help@renteasy.in',
      'supportPhone': '+91 98950 11220',
      'updatedAt': Timestamp.fromDate(at),
      'termsUrl': 'https://old.example.com/terms',
    });
    expect(settings.platformName, 'RentEasy');
    expect(settings.supportEmail, 'help@renteasy.in');
    expect(settings.supportPhone, '+91 98950 11220');
    expect(settings.updatedAt, at);
  });

  test('writes only the general fields, trimmed', () {
    const PlatformSettings settings = PlatformSettings(
      platformName: '  RentEasy ',
      supportEmail: ' Help@RentEasy.in ',
      supportPhone: ' +91 98950 11220 ',
    );
    expect(settings.toFields(), {
      'platformName': 'RentEasy',
      'supportEmail': 'help@renteasy.in',
      'supportPhone': '+91 98950 11220',
    });
  });
}
