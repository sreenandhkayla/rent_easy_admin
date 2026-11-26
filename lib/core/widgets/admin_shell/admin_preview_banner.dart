import 'package:flutter/material.dart';

import '../../resources/strings/app_strings.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_theme.dart';
import '../app_secondary_button.dart';

class AdminPreviewBanner extends StatelessWidget {
  const AdminPreviewBanner({
    super.key,
    required this.roleLabel,
    required this.onExit,
  });

  final String roleLabel;
  final VoidCallback onExit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
      decoration: BoxDecoration(
        color: AppColors.ink,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  const TextSpan(text: AppStrings.previewLead),
                  TextSpan(
                    text: roleLabel,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const TextSpan(text: AppStrings.previewTail),
                ],
              ),
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.onInk),
            ),
          ),
          const SizedBox(width: 12),
          AppSecondaryButton(label: AppStrings.exitPreview, onPressed: onExit),
        ],
      ),
    );
  }
}
