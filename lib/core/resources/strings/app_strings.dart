import '../../utils/app_formatters.dart';

class AppStrings {
  AppStrings._();

  static const String appName = 'ToolRent';
  static const String consoleTitle = 'RentEasy Admin';

  static String consoleTitleFor(String platformName) => '$platformName Admin';
  static const String adminConsole = 'Admin Console';

  static const String loginHeroTitle =
      'Administer the ToolRent platform in one place.';
  static const String loginHeroSubtitle =
      'Owners, shops, subscriptions and platform\n'
      'communications — for '
      'authorised ToolRent administrators only.';
  static const String loginSecurityNote =
      'Access is logged and protected by multi-factor authentication.';
  static const String signIn = 'Sign in';
  static const String signInSubtitle = 'Use your ToolRent admin account.';
  static const String workEmail = 'Work email';
  static const String workEmailHint = 'name@toolrent.in';
  static const String password = 'Password';
  static const String passwordHint = '••••••••';
  static const String forgotPassword = 'Forgot password?';
  static const String showPassword = 'Show password';
  static const String hidePassword = 'Hide password';
  static const String continueLabel = 'Continue';
  static const String invalidWorkEmail = 'Enter a valid work email.';
  static const String enterPassword = 'Enter your password.';
  static const String loginFailed =
      'The email address or password you entered is incorrect. Please try '
      'again.';
  static const String loginNoAccess =
      'This account has not been given access to the admin panel. Ask a '
      'Super Admin to add you in Settings > Admin staff.';
  static const String loginAdminRecordDenied =
      'Your email and password are correct, but this account is not allowed '
      'to read its admin record. Ask a Super Admin to check the Firestore '
      'rules for the admin collection.';
  static const String loginAccountDisabled =
      'This account has been disabled. Contact your administrator.';
  static const String loginTooManyAttempts =
      'Too many attempts. Wait a few minutes and try again.';
  static const String loginSecondFactorRequired =
      'This account needs a second verification step that this sign-in page '
      'does not support yet. Contact your administrator.';
  static const String loginUnavailable =
      'Sign-in is unavailable right now. Try again in a moment.';
  static const String logoutFailed = 'Could not log out. Try again.';
  static const String sessionCheckFailed = "Couldn't verify your session";
  static const String noModuleAccessTitle = 'No access to this module';
  static const String noModuleAccessMessage =
      'Your account does not have permission to open this module. Ask a '
      'Super Admin to update your role in Settings.';
  static const String recordsLoadFailed =
      'Could not load these records. Try again.';
  static const String recordsAccessDenied =
      'You do not have permission to view these records. Sign in again or '
      'contact your administrator.';
  static const String recordsSaveFailed = 'Could not save. Try again.';
  static const String recordsWriteDenied =
      'You do not have permission to make this change.';
  static const String recordNotFound = 'This record no longer exists.';
  static const String accountRecovery = 'Account recovery';
  static const String accountRecoverySubtitle =
      "We'll send a reset link to your registered admin email.";
  static const String backToSignIn = 'Back to sign in';
  static const String sendResetLink = 'Send reset link';
  static const String accountRecoveryMfaNote =
      'Lost access to your authenticator? Contact a Super Admin to '
      'reset multi-factor authentication.';
  static const String resetLinkPending =
      'Reset request accepted. Email delivery is not connected yet.';

  static const String menuLabel = 'MENU';
  static const String navDashboard = 'Dashboard';
  static const String navShopOwners = 'Shop Owners';
  static const String navShopsAndBranches = 'Shops & Branches';
  static const String navSubscriptions = 'Subscriptions';
  static const String navReportsAndComplaints = 'Reports & Complaints';
  static const String navAnalyticsAndReports = 'Analytics & Reports';
  static const String navNotifications = 'Notifications';
  static const String navSettings = 'Settings';
  static const String expandSidebar = 'Expand sidebar';
  static const String collapseSidebar = 'Collapse sidebar';
  static const String logOut = 'Log out';
  static const String logOutTitle = 'Log out?';
  static const String logOutMessage =
      'You will need your password and verification code to sign in again.';
  static const String cancel = 'Cancel';
  static const String refresh = 'Refresh';
  static const String retry = 'Retry';
  static const String checkConnection = 'Check your connection and try again.';
  static const String view = 'View';
  static const String previousPage = 'Previous page';
  static const String nextPage = 'Next page';
  static const String anyRegistrationDate = 'Any registration date';
  static const String registeredLast30Days = 'Registered in last 30 days';
  static const String registeredLast90Days = 'Registered in last 90 days';
  static const String registeredLast12Months = 'Registered in last 12 months';
  static const String statusActive = 'Active';
  static const String statusRestricted = 'Restricted';
  static const String statusExpiringSoon = 'Expiring soon';
  static const String statusExpired = 'Expired';
  static const String statusUnsubscribed = 'Unsubscribed';
  static const String allPlans = 'All plans';
  static const String planBasic = 'Basic';
  static const String planProfessional = 'Professional';
  static const String planPremium = 'Premium';
  static const String paymentPaid = 'Paid';
  static const String paymentPending = 'Pending';
  static const String paymentFailed = 'Failed';
  static const String noPayment = 'No payment';

  static String updatedAt(DateTime date) =>
      'Updated ${AppFormatters.dateTime(date)}';

  static const String previewLead = 'Previewing the console as ';
  static const String previewTail =
      '. Restricted pages show the permission-denied state.';
  static const String exitPreview = 'Exit preview';
  static const String noAccessTitle = "You don't have access to this page";
  static const String backToDashboard = 'Back to dashboard';
  static const String exitRolePreview = 'Exit role preview';
  static const String accessDashboard = 'the dashboard';
  static const String accessOwnersAndShops = 'shop owners and shops';
  static const String accessSubscriptions = 'subscriptions and payments';
  static const String accessReports = 'reports and complaints';
  static const String accessAnalytics = 'analytics and aggregate export';
  static const String accessNotifications =
      'creating and sending notifications';
  static const String accessSettings =
      'admin staff, roles, platform settings and activity logs';

  static String noAccessMessage(String role, String summary) =>
      "Your role ($role) doesn't include $summary. Ask a Super Admin to "
      'update your permissions.';

  static String sectionNotBuilt(String label) => '$label is not built yet.';
}
