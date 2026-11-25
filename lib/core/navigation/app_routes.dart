import 'package:flutter/material.dart';

import '../../features/auth/presentation/pages/account_recovery_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/shop_owners/presentation/pages/owner_details_page.dart';
import '../../features/shop_owners/presentation/pages/shop_owners_page.dart';
import '../../features/shops/presentation/pages/shop_details_page.dart';
import '../../features/shops/presentation/pages/shops_page.dart';
import '../../features/subscriptions/presentation/pages/subscription_details_page.dart';
import '../../features/subscriptions/presentation/pages/subscriptions_page.dart';

class AppRoutes {
  AppRoutes._();

  static const String login = '/';
  static const String accountRecovery = '/account-recovery';
  static const String dashboard = '/dashboard';
  static const String shopOwners = '/shop-owners';
  static const String ownerDetails = '/shop-owners/details';
  static const String shops = '/shops';
  static const String subscriptions = '/subscriptions';
  static const String subscriptionDetails = '/subscriptions/details';
  static final String shopSubscriptions = Uri(
    path: subscriptions,
    queryParameters: {'tab': 'shops'},
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
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => SubscriptionsPage(
            showShopSubscriptions: uri.queryParameters['tab'] == 'shops',
          ),
        );
      case subscriptionDetails:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) =>
              SubscriptionDetailsPage(shopId: uri.queryParameters['id']),
        );
      case shopDetails:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => ShopDetailsPage(shopId: uri.queryParameters['id']),
        );
      case shops:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) =>
              ShopsPage(initialQuery: uri.queryParameters['q'] ?? ''),
        );
      case ownerDetails:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => OwnerDetailsPage(ownerId: uri.queryParameters['id']),
        );
      case shopOwners:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const ShopOwnersPage(),
        );
      case dashboard:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const DashboardPage(),
        );
      case accountRecovery:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const AccountRecoveryPage(),
        );
      case login:
      default:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const LoginPage(),
        );
    }
  }
}
