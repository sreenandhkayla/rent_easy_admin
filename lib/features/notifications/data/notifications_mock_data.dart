import 'models/admin_notification.dart';

class NotificationsMockData {
  NotificationsMockData._();

  static List<AdminNotification> notifications() => List.of(_notifications);

  static const Map<NotificationAudience, AudienceReach> _reach = {
    NotificationAudience.allOwners: AudienceReach(owners: 1248),
    NotificationAudience.allRegisteredShops: AudienceReach(
      shops: 1532,
      owners: 1248,
    ),
    NotificationAudience.subscribedShops: AudienceReach(
      shops: 987,
      owners: 861,
    ),
    NotificationAudience.expiredSubscriptionShops: AudienceReach(
      shops: 214,
      owners: 203,
    ),
    NotificationAudience.expiringSoon: AudienceReach(shops: 46, owners: 46),
    NotificationAudience.selectedShops: AudienceReach(),
  };

  static AudienceReach reachOf(NotificationAudience audience) =>
      _reach[audience] ?? const AudienceReach();

  static String nextId() {
    int highest = 0;
    for (final AdminNotification item in _notifications) {
      final int number =
          int.tryParse(item.notificationId.replaceFirst('N-', '')) ?? 0;
      if (number > highest) highest = number;
    }
    return 'N-${highest + 1}';
  }

  static void cancelScheduled(String id) {
    final int index = _notifications.indexWhere(
      (item) => item.notificationId == id,
    );
    if (index < 0 ||
        _notifications[index].status != NotificationStatus.scheduled) {
      return;
    }
    _notifications[index] = _notifications[index].toDraft();
  }

  static void add(AdminNotification notification) =>
      _notifications.add(notification);

  static const List<String> _failedShops = [
    'Kumar Event Hire',
    'Rasheed Wedding Decor',
    'Salam Generators',
    'Krishnan Decor Studio',
    'Varghese Furniture Rentals',
    'Muhammed Machinery – Tirur',
    'Pillai Tools Hub',
    'Nair Sound & Lights – Guruvayur',
  ];

  static const List<String> _failureReasons = [
    'Push token expired',
    'App uninstalled',
    'Notifications turned off',
  ];

  static List<DeliveryFailure> _failures(int count, DateTime at) => [
    for (int i = 0; i < count; i++)
      DeliveryFailure(
        shopName: _failedShops[i % _failedShops.length],
        reason: _failureReasons[i % _failureReasons.length],
        at: at,
      ),
  ];

  static AdminNotification? notification(String id) {
    for (final AdminNotification item in _notifications) {
      if (item.notificationId == id) return item;
    }
    return null;
  }

  static final List<AdminNotification> _notifications = [
    AdminNotification(
      notificationId: 'N-503',
      title: 'Holiday season support hours',
      message: 'Support hours change from 24 Dec to 1 Jan. Urgent issues are still handled within 4 hours.',
      createdBy: 'Arjun Raghavan',
      type: NotificationType.importantInformation,
      audience: NotificationAudience.subscribedShops,
      status: NotificationStatus.draft,
      createdAt: DateTime(2026, 11, 24, 11, 20),
      recipients: 861,
    ),
    AdminNotification(
      notificationId: 'N-501',
      title: 'Scheduled maintenance on 30 Nov',
      message: 'ToolRent will be unavailable from 1:00 AM to 2:30 AM IST on 30 Nov for maintenance. Your records are safe.',
      createdBy: 'Arjun Raghavan',
      type: NotificationType.maintenance,
      audience: NotificationAudience.allOwners,
      status: NotificationStatus.scheduled,
      createdAt: DateTime(2026, 11, 23, 16, 5),
      sendAt: DateTime(2026, 11, 29, 22, 0),
      recipients: 1248,
    ),
    AdminNotification(
      notificationId: 'N-498',
      title: 'Your subscription expires soon',
      message: 'Renew your shop subscription to keep creating new rentals without interruption.',
      createdBy: 'Arjun Raghavan',
      type: NotificationType.subscriptionExpiringSoon,
      audience: NotificationAudience.expiringSoon,
      status: NotificationStatus.sent,
      createdAt: DateTime(2026, 11, 21, 18, 40),
      sendAt: DateTime(2026, 11, 22, 9, 0),
      delivered: 44,
      recipients: 46,
      failures: [
        DeliveryFailure(
          shopName: 'Kumar Event Hire',
          reason: 'Push token expired',
          at: DateTime(2026, 11, 22, 9, 0),
        ),
        DeliveryFailure(
          shopName: 'Rasheed Wedding Decor',
          reason: 'App uninstalled',
          at: DateTime(2026, 11, 22, 9, 0),
        ),
      ],
    ),
    AdminNotification(
      notificationId: 'N-495',
      title: 'New: maintenance tracking for items',
      message: 'Track servicing and repairs for each item, and get reminders before maintenance is due.',
      createdBy: 'Meera Suresh',
      type: NotificationType.featureAnnouncement,
      audience: NotificationAudience.allRegisteredShops,
      status: NotificationStatus.sent,
      createdAt: DateTime(2026, 11, 17, 15, 10),
      sendAt: DateTime(2026, 11, 18, 11, 30),
      delivered: 1231,
      recipients: 1248,
      failures: _failures(17, DateTime(2026, 11, 18, 11, 30)),
    ),
    AdminNotification(
      notificationId: 'N-490',
      title: 'ToolRent 3.4 is available',
      message: 'Update to ToolRent 3.4 for faster rental search and clearer return reminders.',
      createdBy: 'Kiran Joseph',
      type: NotificationType.appUpdate,
      audience: NotificationAudience.allOwners,
      status: NotificationStatus.sent,
      createdAt: DateTime(2026, 11, 9, 17, 45),
      sendAt: DateTime(2026, 11, 10, 10, 0),
      delivered: 1240,
      recipients: 1248,
      failures: _failures(8, DateTime(2026, 11, 10, 10, 0)),
    ),
    AdminNotification(
      notificationId: 'N-488',
      title: 'Renew to keep creating rentals',
      message: 'Your subscription has expired. Renew now to start creating new rentals again.',
      createdBy: 'Arjun Raghavan',
      type: NotificationType.subscriptionExpired,
      audience: NotificationAudience.expiredSubscriptionShops,
      status: NotificationStatus.sent,
      createdAt: DateTime(2026, 11, 4, 12, 30),
      sendAt: DateTime(2026, 11, 5, 9, 0),
      delivered: 198,
      recipients: 203,
      failures: _failures(5, DateTime(2026, 11, 5, 9, 0)),
    ),
  ];
}
