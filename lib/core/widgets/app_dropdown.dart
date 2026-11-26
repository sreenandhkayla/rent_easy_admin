import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';

class AppDropdown<T> extends StatelessWidget {
  const AppDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.labelOf,
    required this.onChanged,
    this.isExpanded = false,
  });

  final T value;
  final List<T> items;
  final String Function(T item) labelOf;
  final ValueChanged<T> onChanged;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      initialValue: value,
      onSelected: onChanged,
      tooltip: '',
      position: PopupMenuPosition.under,
      color: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        side: const BorderSide(color: AppColors.divider),
      ),
      itemBuilder: (_) => [
        for (final T item in items)
          PopupMenuItem<T>(
            value: item,
            child: Text(labelOf(item), style: AppTextStyles.tableCell),
          ),
      ],
      child: Container(
        height: AppTheme.toolbarControlHeight,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
          children: [
            Flexible(
              fit: isExpanded ? FlexFit.tight : FlexFit.loose,
              child: Text(labelOf(value), style: AppTextStyles.tableCell),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.keyboard_arrow_down,
              size: 18,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
