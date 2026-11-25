import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'app_dialog_frame.dart';
import 'app_primary_button.dart';
import 'app_secondary_button.dart';

class AppConfirmDialog extends StatelessWidget {
  const AppConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.cancelLabel,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;

  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
    required String cancelLabel,
  }) async {
    final bool? result = await showDialog<bool>(
      context: context,
      barrierColor: AppColors.scrim,
      builder: (_) => AppConfirmDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
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
      body: Text(message, style: AppTextStyles.bodySmall),
      actions: [
        AppSecondaryButton(
          label: cancelLabel,
          onPressed: () => navigator.pop(false),
        ),
        AppPrimaryButton(
          label: confirmLabel,
          isCompact: true,
          onPressed: () => navigator.pop(true),
        ),
      ],
    );
  }
}
