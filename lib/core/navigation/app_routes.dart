import 'package:flutter/material.dart';

import '../../features/auth/presentation/pages/account_recovery_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
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
  static const String subscriptions = '/subscriptions';
  static const String subscriptionDetails = '/subscriptions/details';
  static const String createPlan = '/subscriptions/plans/create';
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

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final Uri uri = Uri.parse(settings.name ?? login);
    switch (uri.path) {
      case subscriptions:
        return AppPageRoute<void>(
          settings: settings,
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
          builder: (_) =>
              PaymentDetailsPage(transactionId: uri.queryParameters['id']),
        );
      case planDetails:
        return AppPageRoute<void>(
          settings: settings,
          builder: (_) => PlanDetailsPage(planId: uri.queryParameters['id']),
        );
      case createPlan:
        return AppPageRoute<void>(
          settings: settings,
          builder: (_) => const CreatePlanPage(),
        );
      case subscriptionDetails:
        return AppPageRoute<void>(
          settings: settings,
          builder: (_) =>
              SubscriptionDetailsPage(shopId: uri.queryParameters['id']),
        );
      case shopDetails:
        return AppPageRoute<void>(
          settings: settings,
          builder: (_) => ShopDetailsPage(shopId: uri.queryParameters['id']),
        );
      case shops:
        return AppPageRoute<void>(
          settings: settings,
          builder: (_) =>
              ShopsPage(initialQuery: uri.queryParameters['q'] ?? ''),
        );
      case ownerDetails:
        return AppPageRoute<void>(
          settings: settings,
          builder: (_) => OwnerDetailsPage(ownerId: uri.queryParameters['id']),
        );
      case shopOwners:
        return AppPageRoute<void>(
          settings: settings,
          builder: (_) => const ShopOwnersPage(),
        );
      case dashboard:
        return AppPageRoute<void>(
          settings: settings,
          builder: (_) => const DashboardPage(),
        );
      case accountRecovery:
        return AppPageRoute<void>(
          settings: settings,
          fadesWholePage: true,
          builder: (_) => const AccountRecoveryPage(),
        );
      case login:
      default:
        return AppPageRoute<void>(
          settings: settings,
          fadesWholePage: true,
          builder: (_) => const LoginPage(),
        );
    }
  }
}
