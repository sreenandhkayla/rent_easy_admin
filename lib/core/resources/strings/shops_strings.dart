import '../../utils/app_formatters.dart';

class ShopsStrings {
  ShopsStrings._();

  static const String title = 'Shops & Branches';
  static const String subtitle = 'Registered rental shops and their branches';
  static const String searchHint = 'Search shop name, shop ID or owner';

  static const String allSubscriptions = 'All subscriptions';
  static const String allShopStatuses = 'All shop statuses';

  static const String shopName = 'Shop name';
  static const String shopId = 'Shop ID';
  static const String owner = 'Owner';
  static const String location = 'Location';
  static const String plan = 'Plan';
  static const String subscription = 'Subscription';
  static const String expiry = 'Expiry';
  static const String shopStatus = 'Shop status';
  static const String mainShop = 'Main shop';
  static const String notAvailable = 'N/A';
  static const String unnamedOwner = 'Unnamed owner';
  static const String emptyValue = '—';

  static const String noShopsTitle = 'No shops yet';
  static const String noShopsMessage =
      'Shops appear here once owners register them through the ToolRent '
      'Owner App.';
  static const String loadErrorTitle = "Couldn't load shops";
  static const String refreshError =
      "Couldn't refresh shops. Check your connection and try again.";
  static const String noMatchesTitle = 'No matching shops';
  static const String noMatchesMessage =
      'Try a different shop name, shop ID or owner, or clear the filters.';

  static const String shopDetailsSubtitle = 'Shop details';
  static const String shopNotFound = 'Shop not found';
  static const String shopNotFoundMessage =
      'This shop record does not exist or is no longer available.';
  static const String backToShops = 'Back to Shops & Branches';
  static const String contact = 'Contact';
  static const String shopAddress = 'Shop address';
  static const String registrationDate = 'Registration date';

  static const String subscriptionSummary = 'Subscription summary';
  static const String viewSubscription = 'View subscription';
  static const String currentPlan = 'Current plan';
  static const String status = 'Status';
  static const String lastPayment = 'Last payment';
  static const String startDate = 'Start date';
  static const String expiryDate = 'Expiry date';
  static const String newRentalCreation = 'New rental creation';
  static const String allowed = 'Allowed';
  static const String restricted = 'Restricted';
  static const String blockedShopRestricted = 'Blocked — shop restricted';

  static const String relatedBranches = 'Related branches';
  static const String relatedBranchesNote =
      'Same owner, separate subscriptions';
  static const String noRelatedBranches =
      'No branches are linked to this shop.';

  static const String shopActions = 'Shop actions';
  static const String viewOwner = 'View owner';
  static const String restrictShop = 'Restrict shop';
  static const String restoreShop = 'Restore shop';
  static const String shopActionsNote =
      'Items, customers and rental transactions stay in the Owner App and are '
      'not listed here.';
  static const String administrativeActivity = 'Administrative activity';

  static const String expiredTitlePrefix = 'Subscription expired on';
  static const String expiredMessage =
      'New rental creation is restricted in the Owner App. Existing items, '
      'rentals, customers and records stay viewable. Renewal restores access '
      'after the payment is verified.';
  static const String expiringTitlePrefix = 'Subscription expires on';
  static const String expiringMessage =
      'Renew before the expiry date to keep new rental creation available.';
  static const String noSubscriptionTitle = 'No subscription.';
  static const String noSubscriptionMessage =
      'This shop has never subscribed. New rental creation needs an active '
      'subscription.';
  static const String restrictedTitle = 'Shop restricted by an administrator.';
  static const String restrictedMessage =
      "Staff can't operate this shop until it is restored.";

  static const String restrictDialogMessage =
      'Staff will not be able to operate this shop in the Owner App until it '
      'is restored. Items, rentals and subscription records are kept.';
  static const String reasonLabel = 'Reason (required)';
  static const String reasonHint = 'Why is this shop being restricted?';
  static const String reasonRequired = 'Enter a reason to restrict this shop.';
  static const String restoreDialogMessage =
      'Staff will be able to operate this shop in the Owner App again.';

  static String expiredTitle(String date) => '$expiredTitlePrefix $date.';
  static String expiringTitle(String date) => '$expiringTitlePrefix $date.';
  static String restrictTitle(String name) => 'Restrict $name?';
  static String restoreTitle(String name) => 'Restore $name?';
  static String restrictedSnack(String name) => '$name has been restricted.';
  static String restoredSnack(String name) => '$name has been restored.';
  static String reasonLine(String reason) => 'Reason: $reason';
  static String shopSummary(String shopId, String kind) => '$shopId · $kind';
  static String branchSummary(String kind, String city) => '$kind · $city';

  static String branchOf(String shopName) => 'Branch of $shopName';

  static String perPage(int size) => '$size per page';

  static String archivedPlan(String name) => '$name (archived)';

  static String showingRange(int start, int end, int total, int platform) {
    final String range = total == 0
        ? 'Showing 0 of 0 shops'
        : 'Showing $start–$end of ${AppFormatters.number(total)} shops';
    return '$range · ${AppFormatters.number(platform)} shops on platform';
  }
}
