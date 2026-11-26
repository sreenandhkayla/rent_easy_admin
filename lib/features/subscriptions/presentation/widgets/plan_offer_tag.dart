import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_status_pill.dart';

class PlanOfferTag extends StatelessWidget {
  const PlanOfferTag({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => AppStatusPill(
    label: label,
    color: AppColors.pillAmberText,
    backgroundColor: AppColors.pillAmberBackground,
    showDot: false,
  );
}
