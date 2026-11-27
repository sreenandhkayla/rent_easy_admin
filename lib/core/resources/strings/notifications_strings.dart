class NotificationsStrings {
  NotificationsStrings._();

  static const String title = 'Notifications';
  static const String subtitle = 'Push notifications to shop owners';

  static const String filterAll = 'All';
  static const String filterSent = 'Sent';
  static const String filterDrafts = 'Drafts';
  static const String filterFailed = 'Failed';

  static const String statusDraft = 'Draft';
  static const String statusQueued = 'Queued';
  static const String statusSending = 'Sending';
  static const String statusSent = 'Sent';
  static const String statusFailed = 'Failed';

  static const String typeImportant = 'Important platform information';
  static const String typeMaintenance = 'Maintenance announcement';
  static const String typeExpiringSoon = 'Subscription expiring soon';
  static const String typeFeature = 'Feature announcement';
  static const String typeAppUpdate = 'App update';
  static const String typeExpired = 'Subscription expired';

  static const String audienceAllOwners = 'All owners';
  static const String audienceSubscribedShops = 'Subscribed shops';
  static const String audienceExpiredShops = 'Expired subscription shops';

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

  static const String loadFailedTitle = "Couldn't load notifications";
  static const String noNotificationsTitle = 'No notifications here';
  static const String noNotificationsMessage =
      'Notifications with this status will appear here.';

  static String deliveredOf(String delivered, String recipients) =>
      '$delivered / $recipients';
  static String listLimitNote(int limit) =>
      'Showing the latest $limit notifications.';

  static const String createSubtitle =
      'Compose, choose an audience, preview and send';
  static const String editSubtitle = 'Update the draft, then save or send it';
  static const String notificationType = 'Notification type';
  static const String titleLabel = 'Title *';
  static const String titleHint = 'Short, clear headline';
  static const String messageLabel = 'Message *';
  static const String messageHint = 'What owners need to know';
  static const String audienceLabel = 'Audience *';
  static const String audienceAllOwnersNote = 'Every registered owner';
  static const String audienceDedupeNote =
      'Owners with several shops in the audience receive one notification, '
      'not duplicates.';
  static const String cancel = 'Cancel';
  static const String saveDraft = 'Save draft';
  static const String reviewAndSend = 'Review & send';
  static const String titleRequired = 'Enter a title.';
  static const String messageRequired = 'Enter a message.';
  static const String preview = 'Preview';
  static const String ownerAppPush = 'Owner App push';
  static const String previewTime = '9:41';
  static const String previewTitle = 'Notification title';
  static const String previewMessage =
      'Your message appears here as owners will see it.';
  static const String previewNow = 'now';
  static const String uniqueRecipients = 'Unique recipients';
  static const String counting = 'Counting…';
  static const String countedWhenSent = 'Counted when sent';
  static const String sendTitle = 'Send this notification?';
  static const String sendNotice =
      'Owners with several shops receive one notification. Sent notifications '
      'cannot be recalled.';
  static const String notEditableTitle = "This notification can't be edited";
  static const String notEditableMessage =
      'Only drafts can be edited. Open it from the list to see its delivery '
      'status.';
  static const String signedOut =
      'Your session has ended. Sign in again to continue.';
  static const String noLongerDraft =
      'This notification is no longer a draft, so it was not changed.';

  static String ownersCount(String owners) => '$owners owners';
  static String shopsCount(String shops) => '$shops shops';
  static String sendMessage(String title, String recipients, String audience) =>
      '"$title" will be sent to $recipients ($audience) now.';
  static String queuedSnack(String title) => '"$title" is queued for sending.';
  static String draftSnack(String title) => '"$title" saved as a draft.';
  static String draftUpdatedSnack(String title) => '"$title" draft updated.';

  static const String detailsSubtitle =
      'Notification details and delivery status';
  static const String notificationNotFound = 'Notification not found';
  static const String notificationNotFoundMessage =
      'This notification does not exist or is no longer available.';
  static const String backToNotifications = 'Back to Notifications';
  static const String failed = 'Failed';
  static const String failedCaption = 'Push could not be delivered';
  static const String notSentYet = 'Not sent yet';
  static const String message = 'Message';
  static const String deliveryStatus = 'Delivery status';
  static const String createdBy = 'Created by';
  static const String createdAt = 'Created';
  static const String queuedAt = 'Send requested';
  static const String sentAt = 'Sent';
  static const String devicesTargeted = 'Devices targeted';
  static const String ownersWithoutDevices = 'Owners with no device registered';
  static const String draftNote =
      'This is a draft. Nothing is sent until you choose Review & send.';
  static const String queuedNote =
      'Waiting for the send function to pick this up. Refresh to see '
      'progress.';
  static const String sendingNote =
      'Sending to owner devices now. Refresh to see the results.';
  static const String sentNote =
      'Delivered means FCM accepted the push for that device. It does not '
      'mean the owner opened it.';
  static const String failedNote = 'The send function could not finish.';
  static const String failureReasons = 'Failure reasons';
  static const String failureReasonsNote = 'Per device, as reported by FCM';
  static const String noFailedDeliveries = 'No failed deliveries.';

  static String deliveredShare(String percent) => '$percent delivered';
  static String devicesCount(String count) => '$count devices';
}
