class SettingsStrings {
  SettingsStrings._();

  static const String title = 'Settings';
  static const String subtitle =
      'Your profile, admin access and platform configuration';

  static const String tabAdminProfile = 'Admin profile';
  static const String tabAdminStaff = 'Admin staff';
  static const String tabRoles = 'Roles & permissions';
  static const String tabPlatform = 'Platform settings';
  static const String tabActivity = 'Activity logs';
  static const List<String> tabs = [
    tabAdminProfile,
    tabAdminStaff,
    tabRoles,
    tabPlatform,
    tabActivity,
  ];

  static const String editProfile = 'Edit profile';
  static const String fullName = 'Full name';
  static const String workEmail = 'Work email';
  static const String mobileNumber = 'Mobile number';
  static const String role = 'Role';
  static const String lastSignIn = 'Last sign-in';
  static const String adminId = 'Admin ID';

  static const String accountSecurity = 'Account security';
  static const String twoStepVerification = 'Two-step verification';
  static const String twoStepNote = 'Authenticator app · required for admins';
  static const String on = 'On';
  static const String off = 'Off';
  static const String changePassword = 'Change password';
  static const String currentPassword = 'Current password';
  static const String newPassword = 'New password';
  static const String newPasswordHelper = 'At least 10 characters.';
  static const String confirmNewPassword = 'Confirm new password';
  static const String updatePassword = 'Update password';
  static const String currentPasswordRequired = 'Enter your current password.';
  static const String newPasswordTooShort =
      'Use at least 10 characters for the new password.';
  static const String newPasswordSame =
      'The new password must differ from the current one.';
  static const String passwordsDoNotMatch = 'The passwords do not match.';
  static const String passwordUpdated = 'Password updated.';
  static const String currentPasswordWrong =
      'Your current password is incorrect.';
  static const String passwordRecentLogin =
      'For security, log out and sign in again, then change your password.';
  static const String passwordChangeFailed =
      "Couldn't change your password. Try again.";
  static const String changePasswordMessage =
      'Enter your current password, then choose a new one. You stay signed '
      'in on this device.';
  static const String passwordLabel = 'Password *';
  static const String passwordHint = 'Password for the new admin';
  static const String passwordHelper =
      'At least 10 characters. Share it with the admin privately; they can '
      'change it after signing in.';
  static const String passwordTooShort =
      'Use at least 10 characters for the password.';

  static const String staffSearchHint = 'Search name or email';
  static const String addAdmin = 'Add admin';
  static const String admin = 'Admin';
  static const String email = 'Email';
  static const String status = 'Status';
  static const String manage = 'Manage';
  static const String invitationSent = 'Invitation sent';
  static const String statusActive = 'Active';
  static const String statusInactive = 'Inactive';
  static const String noStaffTitle = 'No matching admins';
  static const String noStaffMessage = 'Try a different name or email.';

  static const String roleSuperAdmin = 'Super Admin';
  static const String roleSuperAdminNote =
      'Authorised access to all platform functions, including admin staff, '
      'roles and platform settings.';
  static const String roleOperationsAdmin = 'Operations Admin';
  static const String roleOperationsAdminNote =
      'Owner, shop, subscription and operational administration within '
      'assigned permissions.';
  static const String roleSupportAdmin = 'Support Admin';
  static const String roleSupportAdminNote =
      'Limited account lookup, report review and support-related actions.';

  static const String addAdminSubtitle = 'Admin account and role';
  static const String fullNameLabel = 'Full name *';
  static const String fullNameHint = "Admin's full name";
  static const String workEmailLabel = 'Work email *';
  static const String workEmailHint = 'name@toolrent.in';
  static const String roleLabel = 'Role *';
  static const String accountActive = 'Account active';
  static const String accountActiveNote = "Inactive admins can't sign in";
  static const String cancel = 'Cancel';
  static const String whatHappensNext = 'What happens next';
  static const String whatHappensNextBody =
      'The new admin signs in with this work email and password, then can '
      'change the password from Change password in the sidebar. If the email '
      'already has a sign-in, its existing password is kept. Inactive admins '
      "stay listed but can't sign in.";
  static const String nameRequired = "Enter the admin's full name.";
  static const String emailInvalid = 'Enter a valid work email.';
  static const String emailTaken = 'An admin with this email already exists.';

  static const String adminLoginFailed =
      "Couldn't create a sign-in for this admin. Try again.";
  static const String staffLoadFailed = "Couldn't load admins";
  static const String emailLocked =
      "The work email is this admin's sign-in and can't be changed here.";
  static const String superAdminOnly =
      'Only a Super Admin can add, change or remove a Super Admin.';
  static const String cannotDeactivateSelf =
      "You can't deactivate your own account.";

  static String adminCreated(String name, String role) =>
      '$name added as $role. They can sign in with the email and password '
      'you set.';
  static String adminAddedExistingLogin(String name, String role) =>
      '$name added as $role. This email already had a sign-in, so its '
      'existing password is kept, not the one you entered.';

  static const String permissions = 'Permissions';
  static const String permissionsNote =
      'Saved to Firestore · applied to every admin with that role';
  static const String permissionsReadOnly =
      'Only a Super Admin can change permissions.';
  static const String permissionsFixedNote =
      'Super Admins always have every permission. Each role needs at least '
      'one page permission so its admins have somewhere to land after '
      'signing in.';
  static const String platformDeniedTitle = "You can't open this tab";
  static const String platformDenied =
      "Your role can't view platform settings or activity logs. Ask a Super "
      'Admin to change this in Settings > Roles & permissions.';
  static const String rolesLoadFailed = "Couldn't load role permissions";
  static const String discardChanges = 'Discard';
  static const String savePermissionsTitle = 'Save permission changes?';
  static const String savePermissionsMessage =
      'Every admin with a changed role gets the new access. Admins who are '
      'signed in see it the next time they reload or sign in.';
  static const String permission = 'Permission';
  static const String permViewDashboard = 'View dashboard & aggregate counts';
  static const String permViewOwnersShops = 'View shop owners and shops';
  static const String permRestrictOwnersShops =
      'Restrict / restore owners and shops';
  static const String permViewSubscriptions = 'View subscriptions & payments';
  static const String permManagePlans = 'Create, edit & archive plans';
  static const String permReviewReports = 'Review reports & record decisions';
  static const String permAnalyticsExport = 'Analytics & aggregate export';
  static const String permSendNotifications = 'Create & send notifications';
  static const String permManageStaff = 'Manage admin staff & roles';
  static const String permPlatformSettings =
      'Platform settings & activity logs';

  static String roleNeedsPage(String role) =>
      '$role needs at least one page permission, such as View dashboard.';
  static String permissionsSaved(int count) =>
      'Permissions saved. Updated $count ${count == 1 ? 'admin' : 'admins'}.';
  static String adminCount(int count) =>
      '$count ${count == 1 ? 'admin' : 'admins'}';
  static String previewConsoleAs(String role) => 'Preview console as $role';
  static String permissionFor(String role, String permission, bool granted) =>
      '$role: $permission, ${granted ? 'allowed' : 'not allowed'}';

  static const String general = 'General';
  static const String platformName = 'Platform name';
  static const String logo = 'Logo';
  static const String logoNote =
      'Current logo · PNG or SVG, 512×512. Upload is not connected in this '
      'prototype.';
  static const String supportEmail = 'Support email';
  static const String supportPhone = 'Support phone';
  static const String subscriptionConfig =
      'Subscription & notification configuration';
  static const String expiringWindow = '“Expiring soon” window';
  static const String sessionTimeout = 'Admin session timeout';
  static const String expiryReminders = 'Send automatic expiry reminders';
  static const String expiryRemindersNote =
      'Owner App push when a shop enters the expiring window';
  static const String onePerOwner = 'One notification per owner';
  static const String onePerOwnerNote =
      'De-duplicate when an owner has several shops in an audience';
  static const String requireTwoStep =
      'Require two-step verification for all admins';
  static const String requireTwoStepNote = 'Admin security';
  static const String returnsAfterExpiry = 'Allow returns & dues after expiry';
  static const String returnsAfterExpiryNote =
      'Recommended exception — awaiting business approval, not enforced';
  static const String needsApproval = 'Needs approval';
  static const String saveSettings = 'Save settings';
  static const String settingsSaved = 'Platform settings saved.';
  static const String appVersionInfo = 'App version information';
  static const String ownerAndroid = 'Owner App · Android';
  static const String ownerIos = 'Owner App · iOS';
  static const String minimumSupported = 'Minimum supported';
  static const String adminWeb = 'Admin Web';
  static const String sampleVersions = 'Sample version numbers.';
  static const String platformNameRequired = 'Enter the platform name.';
  static const String supportEmailInvalid = 'Enter a valid support email.';
  static const String supportPhoneRequired =
      'Enter a valid support phone number with at least 10 digits.';
  static const String platformLoadFailed = "Couldn't load platform settings";

  static String daysBeforeExpiry(int days) => '$days days before expiry';
  static String minutes(int value) => '$value minutes';

  static const String logSearchHint = 'Search action or target';
  static const String allAdmins = 'All admins';
  static const String time = 'Time';
  static const String action = 'Action';
  static const String target = 'Target';
  static const String reason = 'Reason';
  static const String auditNote =
      'Audit entries are append-only and cannot be edited.';
  static const String noLogsTitle = 'No matching activity';
  static const String noLogsMessage =
      'Try a different action or target, or choose another admin.';
  static const String emptyValue = '—';

  static const String editProfileSubtitle = 'Your name and contact details';
  static const String mobileNumberLabel = 'Mobile number *';
  static const String mobileNumberHint = '+91 98950 11220';
  static const String managedBySuperAdmin = 'Managed by a Super Admin';
  static const String saveChanges = 'Save changes';
  static const String aboutProfile = 'About your profile';
  static const String aboutProfileBody =
      'Your name and mobile number appear to other admins and in the activity '
      'log. Work email and role changes are made by a Super Admin from Admin '
      'staff.';
  static const String mobileInvalid = 'Enter a valid 10-digit mobile number.';
  static const String profileUpdated = 'Profile updated.';
  static const String profileLoadFailed = "Couldn't load your profile";
  static const String profileNotFound =
      'No admin record was found for this account.';
  static const String profileSignedOut =
      'Your session has ended. Sign in again to see your profile.';

  static const String manageAdminSubtitle = 'Admin account, role and access';
  static const String account = 'Account';
  static const String removeAdmin = 'Remove admin';
  static const String removeAdminNote =
      'Removing revokes console access immediately. The removal is written to '
      'the activity log.';
  static const String cannotRemoveSelf =
      "You can't remove your own account. Ask another Super Admin.";
  static const String lastSuperAdmin =
      'There must be at least one active Super Admin. Add or activate another '
      'Super Admin first.';
  static const String adminNotFound = 'Admin not found';
  static const String adminNotFoundMessage =
      'This admin does not exist or has been removed.';
  static const String backToAdminStaff = 'Back to Admin staff';

  static String removeAdminTitle(String name) => 'Remove $name?';
  static String removeAdminMessage(String name) =>
      '$name loses console access immediately. Their past actions stay in '
      'the activity log.';
  static String adminSaved(String name) => 'Changes saved for $name.';
  static String adminRemoved(String name) => '$name removed.';

  static String roleAndEmail(String role, String email) => '$role · $email';
}
