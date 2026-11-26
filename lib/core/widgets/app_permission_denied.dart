import 'package:flutter/material.dart';

import '../resources/strings/app_strings.dart';
import '../theme/app_text_styles.dart';
import 'app_card.dart';
import 'app_icon_circle.dart';
import 'app_primary_button.dart';
import 'app_secondary_button.dart';

class AppPermissionDenied extends StatelessWidget {
  const AppPermissionDenied({
    super.key,
    required this.roleLabel,
    required this.accessSummary,
    required this.onBackToDashboard,
    required this.onExitPreview,
  });

  final String roleLabel;
  final String accessSummary;
  final VoidCallback onBackToDashboard;
  final VoidCallback onExitPreview;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AppIconCircle(icon: Icons.lock_outline, size: 40),
              const SizedBox(height: 14),
              const Text(
                AppStrings.noAccessTitle,
                style: AppTextStyles.emptyStateTitle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                AppStrings.noAccessMessage(roleLabel, accessSummary),
                style: AppTextStyles.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 10,
                runSpacing: 10,
                children: [
                  AppSecondaryButton(
                    label: AppStrings.backToDashboard,
                    onPressed: onBackToDashboard,
                  ),
                  AppPrimaryButton(
                    label: AppStrings.exitRolePreview,
                    isCompact: true,
                    onPressed: onExitPreview,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
