import 'package:flutter/material.dart';

import '../enums/subscription_status.dart';
import '../resources/strings/app_strings.dart';
import '../theme/app_colors.dart';
import 'app_status_pill.dart';

class AppSubscriptionPill extends StatelessWidget {
  const AppSubscriptionPill({super.key, required this.status});

  final SubscriptionStatus status;

  @override
  Widget build(BuildContext context) {
    return switch (status) {
      SubscriptionStatus.active => const AppStatusPill(
        label: AppStrings.statusActive,
        color: AppColors.statusGreen,
        backgroundColor: AppColors.pillGreenBackground,
      ),
      SubscriptionStatus.expiringSoon => const AppStatusPill(
        label: AppStrings.statusExpiringSoon,
        color: AppColors.pillAmberText,
        backgroundColor: AppColors.pillAmberBackground,
      ),
      SubscriptionStatus.expired => const AppStatusPill(
        label: AppStrings.statusExpired,
        color: AppColors.pillRedText,
        backgroundColor: AppColors.pillRedBackground,
      ),
      SubscriptionStatus.unsubscribed => const AppStatusPill(
        label: AppStrings.statusUnsubscribed,
        color: AppColors.textSecondary,
        backgroundColor: AppColors.iconCircle,
      ),
    };
  }
}
