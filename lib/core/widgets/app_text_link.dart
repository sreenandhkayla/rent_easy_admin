import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppTextLink extends StatelessWidget {
  const AppTextLink({
    super.key,
    required this.label,
    required this.onTap,
    this.showChevron = true,
  });

  final String label;
  final VoidCallback onTap;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(child: Text(label, style: AppTextStyles.link)),
            if (showChevron) ...[
              const SizedBox(width: 4),
              const Icon(
                Icons.chevron_right,
                size: 18,
                color: AppColors.textPrimary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
