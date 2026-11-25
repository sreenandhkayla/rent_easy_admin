import '../../../../core/enums/subscription_plan.dart';
import '../../../../core/resources/strings/shops_strings.dart';
import '../../data/models/shop.dart';

class ShopLabels {
  ShopLabels._();

  static String plan(SubscriptionPlan? plan) =>
      plan?.label ?? ShopsStrings.emptyValue;

  static String kind(Shop shop) {
    final String? branchOf = shop.branchOf;
    return branchOf == null
        ? ShopsStrings.mainShop
        : ShopsStrings.branchOf(branchOf);
  }
}
