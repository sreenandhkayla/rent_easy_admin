import 'package:flutter/material.dart';

import '../../../../core/resources/strings/subscriptions_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_status_pill.dart';
import '../../data/models/plan_definition.dart';

class PlanStatusPill extends StatelessWidget {
  const PlanStatusPill({super.key, required this.status});

  final PlanStatus status;

  @override
  Widget build(BuildContext context) {
    return switch (status) {
      PlanStatus.active => const AppStatusPill(
        label: SubscriptionsStrings.planActive,
        color: AppColors.statusGreen,
        backgroundColor: AppColors.pillGreenBackground,
      ),
      PlanStatus.archived => const AppStatusPill(
        label: SubscriptionsStrings.planArchived,
        color: AppColors.textSecondary,
        backgroundColor: AppColors.iconCircle,
      ),
    };
  }
}
