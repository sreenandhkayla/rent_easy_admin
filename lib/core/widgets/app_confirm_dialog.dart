import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';
import 'app_dialog_frame.dart';
import 'app_notice_banner.dart';
import 'app_primary_button.dart';
import 'app_secondary_button.dart';

class AppConfirmDialog extends StatelessWidget {
  const AppConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.cancelLabel,
    this.notice,
    this.isDestructive = false,
    this.maxWidth = AppTheme.dialogMaxWidth,
    this.borderRadius = AppTheme.radiusCard,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final String? notice;
  final bool isDestructive;
  final double maxWidth;
  final double borderRadius;

  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
    required String cancelLabel,
    String? notice,
    bool isDestructive = false,
    double maxWidth = AppTheme.dialogMaxWidth,
    double borderRadius = AppTheme.radiusCard,
  }) async {
    final bool? result = await showDialog<bool>(
      context: context,
      barrierColor: AppColors.scrim,
      builder: (_) => AppConfirmDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        notice: notice,
        isDestructive: isDestructive,
        maxWidth: maxWidth,
        borderRadius: borderRadius,
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final NavigatorState navigator = Navigator.of(context);
    return AppDialogFrame(
      title: title,
      onClose: () => navigator.pop(false),
      maxWidth: maxWidth,
      borderRadius: borderRadius,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(message, style: AppTextStyles.bodySmall),
          if (notice case final String text) ...[
            const SizedBox(height: 16),
            AppNoticeBanner(
              tone: AppNoticeTone.info,
              icon: Icons.warning_amber_rounded,
              message: text,
            ),
          ],
        ],
      ),
      actions: [
        AppSecondaryButton(
          label: cancelLabel,
          onPressed: () => navigator.pop(false),
        ),
        AppPrimaryButton(
          label: confirmLabel,
          isCompact: true,
          isDestructive: isDestructive,
          onPressed: () => navigator.pop(true),
        ),
      ],
    );
  }
}
