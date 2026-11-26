class NotificationsStrings {
  NotificationsStrings._();

  static const String title = 'Notifications';
  static const String subtitle = 'Platform communications to owners and shops';

  static const String filterAll = 'All';
  static const String filterSent = 'Sent';
  static const String filterScheduled = 'Scheduled';
  static const String filterDrafts = 'Drafts';

  static const String statusSent = 'Sent';
  static const String statusScheduled = 'Scheduled';
  static const String statusDraft = 'Draft';

  static const String typeImportant = 'Important platform information';
  static const String typeMaintenance = 'Maintenance announcement';
  static const String typeExpiringSoon = 'Subscription expiring soon';
  static const String typeFeature = 'Feature announcement';
  static const String typeAppUpdate = 'App update';
  static const String typeExpired = 'Subscription expired';

  static const String audienceSubscribedShops = 'Subscribed shops';
  static const String audienceAllOwners = 'All owners';
  static const String audienceExpiringSoon = 'Expiring soon';
  static const String audienceAllShops = 'All registered shops';
  static const String audienceExpiredShops = 'Expired subscription shops';
  static const String audienceSelectedShops = 'Selected shops';

  static const String createNotification = 'Create notification';
  static const String notification = 'Notification';
  static const String type = 'Type';
  static const String audience = 'Audience';
  static const String date = 'Date';
  static const String status = 'Status';
  static const String delivered = 'Delivered';
  static const String edit = 'Edit';
  static const String emptyValue = '—';
  static const String editNotification = 'Edit notification';

  static const String noNotificationsTitle = 'No notifications here';
  static const String noNotificationsMessage =
      'Notifications with this status will appear here.';

  static String deliveredOf(String delivered, String recipients) =>
      '$delivered / $recipients';

  static const String createSubtitle =
      'Compose, choose an audience, preview and send';
  static const String notificationType = 'Notification type';
  static const String titleLabel = 'Title *';
  static const String titleHint = 'Short, clear headline';
  static const String messageLabel = 'Message *';
  static const String messageHint = 'What owners need to know';
  static const String audienceLabel = 'Audience *';
  static const String audienceAllOwnersNote = 'Every registered owner';
  static const String audienceSelectedShopsNote = 'Pick specific shops';
  static const String audienceDedupeNote =
      'Owners with several shops in the audience receive one notification, '
      'not duplicates.';
  static const String deliveryLabel = 'Delivery';
  static const String sendNow = 'Send now';
  static const String sendNowNote = 'Delivered immediately after confirmation';
  static const String schedule = 'Schedule';
  static const String scheduleNote = 'Pick a date and time (IST)';
  static const String pickDateTime = 'Pick date and time';
  static const String cancel = 'Cancel';
  static const String saveDraft = 'Save draft';
  static const String reviewAndSend = 'Review & send';
  static const String titleRequired = 'Enter a title.';
  static const String messageRequired = 'Enter a message.';
  static const String selectedShopsUnavailable =
      'Shop selection is not available yet. Choose another audience.';
  static const String scheduleRequired =
      'Pick a future date and time for the scheduled delivery.';
  static const String preview = 'Preview';
  static const String ownerAppPush = 'Owner App push';
  static const String previewTime = '9:41';
  static const String previewTitle = 'Notification title';
  static const String previewMessage =
      'Your message appears here as owners will see it.';
  static const String previewNow = 'now';
  static const String uniqueRecipients = 'Unique recipients';
  static const String delivery = 'Delivery';
  static const String immediately = 'Immediately';
  static const String sendTitle = 'Send this notification?';
  static const String scheduleTitle = 'Schedule this notification?';
  static const String sendNotice =
      'Owners with several shops receive one notification. Sent notifications '
      'cannot be recalled.';

  static String shopsAndOwners(String shops, String owners) =>
      '$shops shops · $owners unique owners';
  static String ownersCount(String owners) => '$owners owners';
  static String scheduledFor(String when) => '$when IST';
  static String sendMessage(String title, String recipients, String audience) =>
      '"$title" will be sent to $recipients ($audience) immediately.';
  static String scheduleMessage(
    String title,
    String recipients,
    String audience,
    String when,
  ) => '"$title" will be sent to $recipients ($audience) on $when IST.';
  static String sentSnack(String id) => '$id sent.';
  static String scheduledSnack(String id) => '$id scheduled.';
  static String draftSnack(String id) => '$id saved as a draft.';
  static String draftUpdatedSnack(String id) => '$id draft updated.';
  static const String editSubtitle =
      'Update the draft, then save it or send it';

  static const String detailsSubtitle =
      'Notification details and delivery status';
  static const String notificationNotFound = 'Notification not found';
  static const String notificationNotFoundMessage =
      'This notification does not exist or is no longer available.';
  static const String backToNotifications = 'Back to Notifications';
  static const String failed = 'Failed';
  static const String failedCaption = 'Push could not be delivered';
  static const String notSentYet = 'Not sent yet';
  static const String notScheduled = 'Not scheduled';
  static const String message = 'Message';
  static const String deliveryStatus = 'Delivery status';
  static const String createdBy = 'Created by';
  static const String deliveryNote =
      'Delivery figures are simulated in this prototype — no notification was '
      'actually sent.';
  static const String failedDeliveries = 'Failed deliveries';
  static const String failedDeliveriesNote = 'Shop-level, no customer data';
  static const String noFailedDeliveries = 'No failed deliveries.';
  static const String cancelScheduledSend = 'Cancel scheduled send';
  static const String cancelScheduledTitle = 'Cancel scheduled send?';
  static const String cancelSend = 'Cancel send';
  static const String keepScheduled = 'Keep scheduled';

  static String deliveredShare(String percent) => '$percent delivered';
  static String cancelScheduledMessage(String id, String when) =>
      '$id will not be sent on $when IST. It moves to Drafts so you can edit '
      'or reschedule it.';
  static String movedToDrafts(String id) => '$id moved to drafts.';
}
