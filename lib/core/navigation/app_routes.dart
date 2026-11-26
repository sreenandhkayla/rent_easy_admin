import 'package:flutter/material.dart';

import '../../features/analytics/presentation/pages/analytics_page.dart';
import '../../features/auth/presentation/pages/account_recovery_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/notifications/presentation/pages/create_notification_page.dart';
import '../../features/notifications/presentation/pages/notification_details_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/reports/presentation/pages/report_details_page.dart';
import '../../features/reports/presentation/pages/reports_page.dart';
import '../../features/reports/presentation/state/reports_state.dart';
import '../../features/settings/presentation/pages/add_admin_page.dart';
import '../../features/settings/presentation/pages/edit_profile_page.dart';
import '../../features/settings/presentation/pages/manage_admin_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/settings/presentation/state/settings_state.dart';
import '../../features/shop_owners/presentation/pages/owner_details_page.dart';
import '../../features/shop_owners/presentation/pages/shop_owners_page.dart';
import '../../features/shops/presentation/pages/shop_details_page.dart';
import '../../features/shops/presentation/pages/shops_page.dart';
import '../../features/subscriptions/presentation/pages/create_plan_page.dart';
import '../../features/subscriptions/presentation/pages/payment_details_page.dart';
import '../../features/subscriptions/presentation/pages/plan_details_page.dart';
import '../../features/subscriptions/presentation/pages/subscription_details_page.dart';
import '../../features/subscriptions/presentation/pages/subscriptions_page.dart';
import '../../features/subscriptions/presentation/state/subscriptions_state.dart';
import '../widgets/admin_shell/admin_section.dart';
import 'app_page_route.dart';

class AppRoutes {
  AppRoutes._();

  static final RouteObserver<PageRoute<dynamic>> observer =
      RouteObserver<PageRoute<dynamic>>();

  static const String login = '/';
  static const String accountRecovery = '/account-recovery';
  static const String dashboard = '/dashboard';
  static const String shopOwners = '/shop-owners';
  static const String ownerDetails = '/shop-owners/details';
  static const String shops = '/shops';
  static const String analytics = '/analytics';
  static const String settings = '/settings';
  static const String addAdmin = '/settings/staff/add';
  static const String editProfile = '/settings/profile/edit';
  static const String manageAdmin = '/settings/staff/manage';

  static String manageAdminFor(String adminId) =>
      Uri(path: manageAdmin, queryParameters: {'id': adminId}).toString();

  static final String adminStaff = Uri(
    path: settings,
    queryParameters: {'tab': 'staff'},
  ).toString();
  static const String notifications = '/notifications';
  static const String createNotification = '/notifications/create';
  static const String editNotification = '/notifications/edit';

  static String editNotificationFor(String notificationId) => Uri(
    path: editNotification,
    queryParameters: {'id': notificationId},
  ).toString();

  static const String notificationDetails = '/notifications/details';

  static String notificationDetailsFor(String notificationId) => Uri(
    path: notificationDetails,
    queryParameters: {'id': notificationId},
  ).toString();

  static const String reports = '/reports';
  static const String reportDetails = '/reports/details';

  static String reportDetailsFor(String reportId) =>
      Uri(path: reportDetails, queryParameters: {'id': reportId}).toString();

  static final String pendingReports = Uri(
    path: reports,
    queryParameters: {'status': 'pending'},
  ).toString();
  static const String subscriptions = '/subscriptions';
  static const String subscriptionDetails = '/subscriptions/details';
  static const String createPlan = '/subscriptions/plans/create';
  static const String editPlan = '/subscriptions/plans/edit';

  static String editPlanFor(String planId) =>
      Uri(path: editPlan, queryParameters: {'id': planId}).toString();

  static const String planDetails = '/subscriptions/plans/details';
  static const String paymentDetails = '/subscriptions/payments/details';
  static final String subscriptionPayments = Uri(
    path: subscriptions,
    queryParameters: {'tab': 'payments'},
  ).toString();

  static String paymentDetailsFor(String transactionId) => Uri(
    path: paymentDetails,
    queryParameters: {'id': transactionId},
  ).toString();

  static String planDetailsFor(String planId) =>
      Uri(path: planDetails, queryParameters: {'id': planId}).toString();

  static final String shopSubscriptions = Uri(
    path: subscriptions,
    queryParameters: {'tab': 'shops'},
  ).toString();
  static final String subscriptionPlans = Uri(
    path: subscriptions,
    queryParameters: {'tab': 'plans'},
  ).toString();

  static String subscriptionDetailsFor(String shopId) => Uri(
    path: subscriptionDetails,
    queryParameters: {'id': shopId},
  ).toString();

  static const String shopDetails = '/shops/details';

  static String shopDetailsFor(String shopId) =>
      Uri(path: shopDetails, queryParameters: {'id': shopId}).toString();

  static String shopsMatching(String query) =>
      Uri(path: shops, queryParameters: {'q': query}).toString();

  static String ownerDetailsFor(String ownerId) =>
      Uri(path: ownerDetails, queryParameters: {'id': ownerId}).toString();

  static final Map<String, AdminSection> _sections = {
    dashboard: AdminSection.dashboard,
    shopOwners: AdminSection.shopOwners,
    ownerDetails: AdminSection.shopOwners,
    shops: AdminSection.shopsAndBranches,
    shopDetails: AdminSection.shopsAndBranches,
    subscriptions: AdminSection.subscriptions,
    subscriptionDetails: AdminSection.subscriptions,
    createPlan: AdminSection.subscriptions,
    editPlan: AdminSection.subscriptions,
    planDetails: AdminSection.subscriptions,
    paymentDetails: AdminSection.subscriptions,
    reports: AdminSection.reportsAndComplaints,
    reportDetails: AdminSection.reportsAndComplaints,
    analytics: AdminSection.analyticsAndReports,
    notifications: AdminSection.notifications,
    createNotification: AdminSection.notifications,
    editNotification: AdminSection.notifications,
    notificationDetails: AdminSection.notifications,
    settings: AdminSection.settings,
    addAdmin: AdminSection.settings,
    editProfile: AdminSection.settings,
    manageAdmin: AdminSection.settings,
  };

  static AdminSection? _sectionFor(String path) => _sections[path];

  static List<Route<dynamic>> onGenerateInitialRoutes(String initialRoute) => [
    onGenerateRoute(RouteSettings(name: initialRoute)),
  ];

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final Uri uri = Uri.parse(settings.name ?? login);
    switch (uri.path) {
      case subscriptions:
        return AppPageRoute<void>(
          settings: settings,
          section: _sectionFor(uri.path),
          builder: (_) => SubscriptionsPage(
            initialTab: switch (uri.queryParameters['tab']) {
              'shops' => SubscriptionsTab.shopSubscriptions,
              'plans' => SubscriptionsTab.plans,
              'payments' => SubscriptionsTab.payments,
              'reconciliation' => SubscriptionsTab.reconciliation,
              _ => SubscriptionsTab.overview,
            },
          ),
        );
      case paymentDetails:
        return AppPageRoute<void>(
          settings: settings,
          section: _sectionFor(uri.path),
          builder: (_) =>
              PaymentDetailsPage(transactionId: uri.queryParameters['id']),
        );
      case planDetails:
        return AppPageRoute<void>(
          settings: settings,
          section: _sectionFor(uri.path),
          builder: (_) => PlanDetailsPage(planId: uri.queryParameters['id']),
        );
      case editPlan:
        return AppPageRoute<void>(
          settings: settings,
          section: _sectionFor(uri.path),
          builder: (_) =>
              CreatePlanPage(planId: uri.queryParameters['id'] ?? ''),
        );
      case createPlan:
        return AppPageRoute<void>(
          settings: settings,
          section: _sectionFor(uri.path),
          builder: (_) => const CreatePlanPage(),
        );
      case subscriptionDetails:
        return AppPageRoute<void>(
          settings: settings,
          section: _sectionFor(uri.path),
          builder: (_) =>
              SubscriptionDetailsPage(shopId: uri.queryParameters['id']),
        );
      case notificationDetails:
        return AppPageRoute<void>(
          settings: settings,
          section: _sectionFor(uri.path),
          builder: (_) => NotificationDetailsPage(
            notificationId: uri.queryParameters['id'],
          ),
        );
      case editNotification:
        return AppPageRoute<void>(
          settings: settings,
          section: _sectionFor(uri.path),
          builder: (_) =>
              CreateNotificationPage(notificationId: uri.queryParameters['id']),
        );
      case createNotification:
        return AppPageRoute<void>(
          settings: settings,
          section: _sectionFor(uri.path),
          builder: (_) => const CreateNotificationPage(),
        );
      case notifications:
        return AppPageRoute<void>(
          settings: settings,
          section: _sectionFor(uri.path),
          builder: (_) => const NotificationsPage(),
        );
      case manageAdmin:
        return AppPageRoute<void>(
          settings: settings,
          section: _sectionFor(uri.path),
          builder: (_) => ManageAdminPage(adminId: uri.queryParameters['id']),
        );
      case editProfile:
        return AppPageRoute<void>(
          settings: settings,
          section: _sectionFor(uri.path),
          builder: (_) => const EditProfilePage(),
        );
      case addAdmin:
        return AppPageRoute<void>(
          settings: settings,
          section: _sectionFor(uri.path),
          builder: (_) => const AddAdminPage(),
        );
      case AppRoutes.settings:
        return AppPageRoute<void>(
          settings: settings,
          section: _sectionFor(uri.path),
          builder: (_) => SettingsPage(
            initialTab: switch (uri.queryParameters['tab']) {
              'staff' => SettingsTab.adminStaff,
              'roles' => SettingsTab.roles,
              'platform' => SettingsTab.platform,
              'activity' => SettingsTab.activity,
              _ => SettingsTab.adminProfile,
            },
          ),
        );
      case analytics:
        return AppPageRoute<void>(
          settings: settings,
          section: _sectionFor(uri.path),
          builder: (_) => const AnalyticsPage(),
        );
      case reportDetails:
        return AppPageRoute<void>(
          settings: settings,
          section: _sectionFor(uri.path),
          builder: (_) =>
              ReportDetailsPage(reportId: uri.queryParameters['id']),
        );
      case reports:
        return AppPageRoute<void>(
          settings: settings,
          section: _sectionFor(uri.path),
          builder: (_) => ReportsPage(
            initialFilter: ReportStatusFilter.values.firstWhere(
              (filter) => filter.name == uri.queryParameters['status'],
              orElse: () => ReportStatusFilter.all,
            ),
          ),
        );
      case shopDetails:
        return AppPageRoute<void>(
          settings: settings,
          section: _sectionFor(uri.path),
          builder: (_) => ShopDetailsPage(shopId: uri.queryParameters['id']),
        );
      case shops:
        return AppPageRoute<void>(
          settings: settings,
          section: _sectionFor(uri.path),
          builder: (_) =>
              ShopsPage(initialQuery: uri.queryParameters['q'] ?? ''),
        );
      case ownerDetails:
        return AppPageRoute<void>(
          settings: settings,
          section: _sectionFor(uri.path),
          builder: (_) => OwnerDetailsPage(ownerId: uri.queryParameters['id']),
        );
      case shopOwners:
        return AppPageRoute<void>(
          settings: settings,
          section: _sectionFor(uri.path),
          builder: (_) => const ShopOwnersPage(),
        );
      case dashboard:
        return AppPageRoute<void>(
          settings: settings,
          section: _sectionFor(uri.path),
          builder: (_) => const DashboardPage(),
        );
      case accountRecovery:
        return AppPageRoute<void>(
          settings: settings,
          section: _sectionFor(uri.path),
          fadesWholePage: true,
          builder: (_) => const AccountRecoveryPage(),
        );
      case login:
      default:
        return AppPageRoute<void>(
          settings: settings,
          section: _sectionFor(uri.path),
          fadesWholePage: true,
          builder: (_) => const LoginPage(),
        );
    }
  }
}
