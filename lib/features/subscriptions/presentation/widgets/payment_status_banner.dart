import 'package:flutter/material.dart';

import '../../../../core/resources/strings/subscriptions_strings.dart';
import '../../../../core/widgets/app_notice_banner.dart';
import '../../data/models/payment_attempt.dart';
import '../../data/models/subscription_payment.dart';

class PaymentStatusBanner extends StatelessWidget {
  const PaymentStatusBanner({super.key, required this.payment});

  final SubscriptionPayment payment;

  @override
  Widget build(BuildContext context) {
    if (payment.status == AttemptStatus.failed) {
      return AppNoticeBanner(
        tone: AppNoticeTone.danger,
        icon: Icons.warning_amber_rounded,
        title: SubscriptionsStrings.paymentFailedTitle,
        message: SubscriptionsStrings.paymentFailedMessage(
          payment.failureReason ?? SubscriptionsStrings.defaultFailureReason,
        ),
      );
    }
    if (payment.isVerified) {
      return const AppNoticeBanner(
        tone: AppNoticeTone.success,
        icon: Icons.check_circle_outline,
        title: SubscriptionsStrings.paymentVerifiedTitle,
        message: SubscriptionsStrings.paymentVerifiedMessage,
      );
    }
    return const AppNoticeBanner(
      tone: AppNoticeTone.warning,
      icon: Icons.schedule,
      title: SubscriptionsStrings.paymentPendingTitle,
      message: SubscriptionsStrings.paymentPendingMessage,
    );
  }
}
