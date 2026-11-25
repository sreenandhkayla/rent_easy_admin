import '../../utils/app_formatters.dart';

class ShopOwnersStrings {
  ShopOwnersStrings._();

  static const String title = 'Shop Owners';
  static const String subtitle = 'Registered owner accounts on ToolRent';
  static const String searchHint = 'Search name, mobile or owner ID';

  static const String allStatuses = 'All statuses';
  static const String active = 'Active';
  static const String restricted = 'Restricted';

  static const String ownerName = 'Owner name';
  static const String mobileNumber = 'Mobile number';
  static const String ownerId = 'Owner ID';
  static const String registered = 'Registered';
  static const String shops = 'Shops';
  static const String subscribed = 'Subscribed';
  static const String status = 'Status';
  static const String noOwnersTitle = 'No shop owners yet';
  static const String noOwnersMessage =
      'Owners appear here once they register through the ToolRent Owner App.';
  static const String noMatchesTitle = 'No matching owners';
  static const String noMatchesMessage =
      'Try a different name, mobile number or owner ID, or clear the filters.';

  static const String ownerDetailsSubtitle = 'Owner details';
  static const String ownerNotFound = 'Owner not found';
  static const String ownerNotFoundMessage =
      'This owner record does not exist or is no longer available.';
  static const String backToShopOwners = 'Back to Shop Owners';
  static const String numberOfShops = 'Number of shops';
  static const String subscribedShops = 'Subscribed shops';
  static const String unsubscribedOrExpired = 'Unsubscribed or expired';
  static const String registrationDate = 'Registration date';

  static const String linkedShops = 'Linked shops';
  static const String linkedShopsNote = 'Each shop has its own subscription';
  static const String shop = 'Shop';
  static const String location = 'Location';
  static const String plan = 'Plan';
  static const String subscription = 'Subscription';
  static const String expiry = 'Expiry';
  static const String branch = 'Branch';
  static const String shopDetails = 'Shop details';
  static const String emptyValue = '—';

  static const String accountActions = 'Account actions';
  static const String viewLinkedShops = 'View linked shops in Shops & Branches';
  static const String restrictAccount = 'Restrict account';
  static const String restoreAccount = 'Restore account';
  static const String accountActionsNote =
      'Customers, items and rentals of this owner are not shown in the '
      'Admin Web.';
  static const String administrativeActivity = 'Administrative activity';

  static const String restrictMessage =
      'The owner will be signed out of the Owner App and cannot sign in '
      'until restored. Shop data and subscriptions are kept.';
  static const String reasonLabel = 'Reason (required)';
  static const String reasonHint = 'Why is this account being restricted?';
  static const String reasonRequired =
      'Enter a reason to restrict this account.';
  static const String restoreMessage =
      'The owner will be able to sign in to the Owner App again.';

  static String restrictTitle(String name) => 'Restrict $name?';
  static String restoreTitle(String name) => 'Restore $name?';
  static String restrictedMessage(String name) => '$name has been restricted.';
  static String restoredMessage(String name) => '$name has been restored.';

  static String ownerSummary(String ownerId, DateTime registeredAt) =>
      '$ownerId · Registered ${AppFormatters.date(registeredAt)}';

  static String ownersOnPlatform(int count) =>
      '${AppFormatters.number(count)} owners on platform';

  static String showingRange(int start, int end, int total) => total == 0
      ? 'Showing 0 of 0 sample records'
      : 'Showing $start–$end of $total sample records';
}
