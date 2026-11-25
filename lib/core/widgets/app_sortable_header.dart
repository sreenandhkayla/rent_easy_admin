import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppSortableHeader extends StatelessWidget {
  const AppSortableHeader({
    super.key,
    required this.label,
    required this.isActive,
    required this.isAscending,
    required this.onTap,
    this.alignEnd = false,
  });

  final String label;
  final bool isActive;
  final bool isAscending;
  final VoidCallback onTap;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    final IconData icon = !isActive
        ? Icons.unfold_more
        : isAscending
        ? Icons.arrow_upward
        : Icons.arrow_downward;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Row(
          mainAxisAlignment: alignEnd
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Flexible(child: Text(label, style: AppTextStyles.tableHeader)),
            const SizedBox(width: 4),
            Icon(icon, size: 13, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
