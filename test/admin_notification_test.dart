import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rent_easy_admin/features/notifications/data/models/admin_notification.dart';

void main() {
  test('a draft writes only the content fields', () {
    const NotificationDraft draft = NotificationDraft(
      title: '  Maintenance tonight ',
      message: ' Back by 2 AM. ',
      type: NotificationType.maintenance,
      audience: NotificationAudience.subscribedShops,
    );
    expect(draft.toFields(), {
      'title': 'Maintenance tonight',
      'message': 'Back by 2 AM.',
      'type': 'maintenance',
      'audience': 'subscribedShops',
    });
  });

  test('reads a sent notification written by the send function', () {
    final DateTime sentAt = DateTime(2026, 11, 27, 10);
    final AdminNotification notification = AdminNotification.fromDocument(
      'n1',
      {
        'title': 'Hello',
        'message': 'World',
        'type': 'appUpdate',
        'audience': 'expiredSubscriptionShops',
        'status': 'sent',
        'createdByName': 'Asha',
        'sentAt': Timestamp.fromDate(sentAt),
        'recipients': 40,
        'delivered': 38,
        'failed': 2,
        'failureReasons': {'Token not registered': 1, 'Invalid token': 1},
      },
    );
    expect(notification.status, NotificationStatus.sent);
    expect(notification.type, NotificationType.appUpdate);
    expect(
      notification.audience,
      NotificationAudience.expiredSubscriptionShops,
    );
    expect(notification.sentAt, sentAt);
    expect(notification.deliveredShare, closeTo(0.95, 0.0001));
    expect(notification.failureReasons, hasLength(2));
    expect(notification.errorMessage, isNull);
  });

  test('unknown or missing values fall back safely', () {
    final AdminNotification notification = AdminNotification.fromDocument(
      'n2',
      {'status': 'somethingNew', 'audience': 'selectedShops', 'error': ' '},
    );
    expect(notification.status, NotificationStatus.draft);
    expect(notification.audience, NotificationAudience.allOwners);
    expect(notification.deliveredShare, isNull);
    expect(notification.errorMessage, isNull);
  });

  test('the delivered share is counted per device, not per owner', () {
    final AdminNotification notification = AdminNotification.fromDocument(
      'n3',
      {
        'status': 'sent',
        'recipients': 10,
        'devices': 40,
        'ownersWithoutDevices': 2,
        'delivered': 30,
        'failed': 10,
      },
    );
    expect(notification.deliveredShare, closeTo(0.75, 0.0001));
    expect(notification.devices, 40);
    expect(notification.ownersWithoutDevices, 2);
  });

  test('queued and sending count as in progress', () {
    expect(NotificationStatus.queued.isInProgress, isTrue);
    expect(NotificationStatus.sending.isInProgress, isTrue);
    expect(NotificationStatus.sent.isInProgress, isFalse);
  });
}
