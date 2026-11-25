import 'package:flutter/material.dart';

import '../resources/strings/app_strings.dart';
import '../theme/app_colors.dart';
import 'app_status_pill.dart';

class AppAccessStatusPill extends StatelessWidget {
  const AppAccessStatusPill({super.key, required this.isRestricted});

  final bool isRestricted;

  @override
  Widget build(BuildContext context) {
    return isRestricted
        ? const AppStatusPill(
            label: AppStrings.statusRestricted,
            color: AppColors.pillRedText,
            backgroundColor: AppColors.pillRedBackground,
          )
        : const AppStatusPill(
            label: AppStrings.statusActive,
            color: AppColors.statusGreen,
            backgroundColor: AppColors.pillGreenBackground,
          );
  }
}
