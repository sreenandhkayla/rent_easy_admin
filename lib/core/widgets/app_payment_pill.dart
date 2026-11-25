import 'package:flutter/material.dart';

import '../enums/payment_status.dart';
import '../resources/strings/app_strings.dart';
import '../theme/app_colors.dart';
import 'app_status_pill.dart';

class AppPaymentPill extends StatelessWidget {
  const AppPaymentPill({super.key, required this.status});

  final PaymentStatus status;

  @override
  Widget build(BuildContext context) {
    return switch (status) {
      PaymentStatus.paid => const AppStatusPill(
        label: AppStrings.paymentPaid,
        color: AppColors.statusGreen,
        backgroundColor: AppColors.pillGreenBackground,
      ),
      PaymentStatus.pending => const AppStatusPill(
        label: AppStrings.paymentPending,
        color: AppColors.pillAmberText,
        backgroundColor: AppColors.pillAmberBackground,
      ),
      PaymentStatus.failed => const AppStatusPill(
        label: AppStrings.paymentFailed,
        color: AppColors.pillRedText,
        backgroundColor: AppColors.pillRedBackground,
      ),
      PaymentStatus.none => const AppStatusPill(
        label: AppStrings.noPayment,
        color: AppColors.textSecondary,
        backgroundColor: AppColors.iconCircle,
      ),
    };
  }
}
