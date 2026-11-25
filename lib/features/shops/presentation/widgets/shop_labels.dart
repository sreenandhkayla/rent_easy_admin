import 'package:flutter/material.dart';

import '../../../../core/resources/strings/shops_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_status_pill.dart';
import '../../data/models/shop.dart';

class ShopLabels {
  ShopLabels._();

  static String plan(ShopPlan? plan) => switch (plan) {
    null => ShopsStrings.emptyValue,
    ShopPlan.basic => ShopsStrings.basic,
    ShopPlan.professional => ShopsStrings.professional,
    ShopPlan.premium => ShopsStrings.premium,
  };

  static String kind(Shop shop) {
    final String? branchOf = shop.branchOf;
    return branchOf == null
        ? ShopsStrings.mainShop
        : ShopsStrings.branchOf(branchOf);
  }
}

class PaymentStatusPill extends StatelessWidget {
  const PaymentStatusPill({super.key, required this.status});

  final PaymentStatus status;

  @override
  Widget build(BuildContext context) {
    return switch (status) {
      PaymentStatus.verified => const AppStatusPill(
        label: ShopsStrings.paymentVerified,
        color: AppColors.statusGreen,
        backgroundColor: AppColors.pillGreenBackground,
      ),
      PaymentStatus.pending => const AppStatusPill(
        label: ShopsStrings.paymentPending,
        color: AppColors.pillAmberText,
        backgroundColor: AppColors.pillAmberBackground,
      ),
      PaymentStatus.failed => const AppStatusPill(
        label: ShopsStrings.paymentFailed,
        color: AppColors.pillRedText,
        backgroundColor: AppColors.pillRedBackground,
      ),
      PaymentStatus.none => const AppStatusPill(
        label: ShopsStrings.noPayment,
        color: AppColors.textSecondary,
        backgroundColor: AppColors.iconCircle,
      ),
    };
  }
}
