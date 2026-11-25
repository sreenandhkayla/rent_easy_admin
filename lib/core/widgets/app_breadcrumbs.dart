import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppBreadcrumb {
  const AppBreadcrumb(this.label, {this.onTap});

  final String label;
  final VoidCallback? onTap;
}

class AppBreadcrumbs extends StatelessWidget {
  const AppBreadcrumbs({super.key, required this.items});

  final List<AppBreadcrumb> items;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 6,
      runSpacing: 4,
      children: [
        for (int i = 0; i < items.length; i++) ...[
          if (i > 0)
            const Icon(
              Icons.chevron_right,
              size: 14,
              color: AppColors.textSecondary,
            ),
          _Crumb(item: items[i], isLast: i == items.length - 1),
        ],
      ],
    );
  }
}

class _Crumb extends StatelessWidget {
  const _Crumb({required this.item, required this.isLast});

  final AppBreadcrumb item;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final Text text = Text(
      item.label,
      style: isLast ? AppTextStyles.labelRegular : AppTextStyles.bodyCaption,
    );
    if (item.onTap == null) return text;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(onTap: item.onTap, child: text),
    );
  }
}
