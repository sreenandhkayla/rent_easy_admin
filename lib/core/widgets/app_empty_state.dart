import 'package:flutter/material.dart';

import '../theme/app_text_styles.dart';
import 'app_icon_circle.dart';

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.title,
    this.icon,
    this.svgIcon,
    required this.message,
  });

  final IconData? icon;
  final String? svgIcon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 44),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 340),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppIconCircle(icon: icon, svgIcon: svgIcon, size: 40),
              const SizedBox(height: 14),
              Text(
                title,
                style: AppTextStyles.emptyStateTitle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: AppTextStyles.bodyCaption,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
