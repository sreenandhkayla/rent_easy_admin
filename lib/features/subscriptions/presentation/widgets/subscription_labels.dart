import 'package:flutter/material.dart';

import '../../../../core/enums/subscription_status.dart';
import '../../../../core/resources/strings/subscriptions_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_status_pill.dart';
import '../../data/models/payment_attempt.dart';
import '../../data/models/shop_subscription.dart';

class SubscriptionLabels {
  SubscriptionLabels._();

  static String newRentalCreation(ShopSubscription subscription) {
    if (subscription.isShopRestricted) {
      return SubscriptionsStrings.blockedShopRestricted;
    }
    return switch (subscription.status) {
      SubscriptionStatus.active ||
      SubscriptionStatus.expiringSoon => SubscriptionsStrings.allowed,
      SubscriptionStatus.expired ||
      SubscriptionStatus.unsubscribed => SubscriptionsStrings.restricted,
    };
  }
}

class AttemptStatusPill extends StatelessWidget {
  const AttemptStatusPill({super.key, required this.status});

  final AttemptStatus status;

  @override
  Widget build(BuildContext context) {
    return switch (status) {
      AttemptStatus.successful => const AppStatusPill(
        label: SubscriptionsStrings.successful,
        color: AppColors.statusGreen,
        backgroundColor: AppColors.pillGreenBackground,
      ),
      AttemptStatus.pending => const AppStatusPill(
        label: SubscriptionsStrings.pending,
        color: AppColors.pillAmberText,
        backgroundColor: AppColors.pillAmberBackground,
      ),
      AttemptStatus.failed => const AppStatusPill(
        label: SubscriptionsStrings.failed,
        color: AppColors.pillRedText,
        backgroundColor: AppColors.pillRedBackground,
      ),
    };
  }
}

class VerificationPill extends StatelessWidget {
  const VerificationPill({super.key, required this.status});

  final VerificationStatus status;

  @override
  Widget build(BuildContext context) {
    return switch (status) {
      VerificationStatus.verified => const AppStatusPill(
        label: SubscriptionsStrings.verified,
        color: AppColors.statusGreen,
        backgroundColor: AppColors.pillGreenBackground,
      ),
      VerificationStatus.awaiting => const AppStatusPill(
        label: SubscriptionsStrings.awaitingVerification,
        color: AppColors.pillAmberText,
        backgroundColor: AppColors.pillAmberBackground,
      ),
      VerificationStatus.notVerified => const AppStatusPill(
        label: SubscriptionsStrings.notVerified,
        color: AppColors.textSecondary,
        backgroundColor: AppColors.iconCircle,
      ),
    };
  }
}
