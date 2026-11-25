import 'package:flutter/material.dart';

import '../resources/strings/app_strings.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';

class AppPagination extends StatelessWidget {
  const AppPagination({
    super.key,
    required this.currentPage,
    required this.pageCount,
    required this.onPageChanged,
  });

  final int currentPage;
  final int pageCount;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _PageButton(
          tooltip: AppStrings.previousPage,
          onTap: currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
          child: const Icon(Icons.chevron_left, size: 16),
        ),
        for (int page = 1; page <= pageCount; page++)
          _PageButton(
            isSelected: page == currentPage,
            onTap: () => onPageChanged(page),
            child: Text(
              '$page',
              style: AppTextStyles.labelRegular.copyWith(
                color: page == currentPage
                    ? AppColors.onInk
                    : AppColors.textPrimary,
              ),
            ),
          ),
        _PageButton(
          tooltip: AppStrings.nextPage,
          onTap: currentPage < pageCount
              ? () => onPageChanged(currentPage + 1)
              : null,
          child: const Icon(Icons.chevron_right, size: 16),
        ),
      ],
    );
  }
}

class _PageButton extends StatelessWidget {
  const _PageButton({
    required this.child,
    required this.onTap,
    this.isSelected = false,
    this.tooltip,
  });

  final Widget child;
  final VoidCallback? onTap;
  final bool isSelected;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onTap != null;
    final BorderRadius radius = BorderRadius.circular(AppTheme.radiusSmall);
    final Widget button = Material(
      color: isSelected ? AppColors.ink : AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: isSelected ? AppColors.ink : AppColors.border),
      ),
      child: InkWell(
        onTap: isSelected ? null : onTap,
        borderRadius: radius,
        child: SizedBox.square(
          dimension: 30,
          child: Center(
            child: IconTheme(
              data: IconThemeData(
                color: isEnabled ? AppColors.textPrimary : AppColors.statusGrey,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
    return tooltip == null ? button : Tooltip(message: tooltip, child: button);
  }
}
