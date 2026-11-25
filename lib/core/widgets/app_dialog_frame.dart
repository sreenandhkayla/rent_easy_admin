import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';
import 'app_icon_circle_button.dart';

class AppDialogFrame extends StatelessWidget {
  const AppDialogFrame({
    super.key,
    required this.title,
    required this.body,
    required this.actions,
    required this.onClose,
  });

  final String title;
  final Widget body;
  final List<Widget> actions;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppTheme.dialogMaxWidth),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(title, style: AppTextStyles.cardTitle),
                          ),
                        ),
                        AppIconCircleButton(
                          icon: Icons.close,
                          tooltip: MaterialLocalizations.of(context)
                              .closeButtonTooltip,
                          onPressed: onClose,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    body,
                  ],
                ),
              ),
              const Divider(height: 1, color: AppColors.divider),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  alignment: WrapAlignment.end,
                  spacing: 10,
                  runSpacing: 10,
                  children: actions,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
