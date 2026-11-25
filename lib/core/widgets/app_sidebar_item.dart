import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';

class AppSidebarItem extends StatelessWidget {
  const AppSidebarItem({
    super.key,
    required this.label,
    this.icon,
    this.svgIcon,
    required this.onTap,
    this.isSelected = false,
    this.isCollapsed = false,
    this.badgeCount,
  });

  final IconData? icon;
  final String? svgIcon;
  final String label;
  final VoidCallback onTap;
  final bool isSelected;
  final bool isCollapsed;
  final int? badgeCount;

  @override
  Widget build(BuildContext context) {
    final Color foreground = isSelected
        ? AppColors.onInk
        : AppColors.sidebarText;
    final BorderRadius radius = BorderRadius.circular(AppTheme.radiusLarge);
    final bool hasBadge = badgeCount != null && badgeCount! > 0;
    final Widget iconWidget = svgIcon != null
        ? SvgPicture.asset(
            svgIcon!,
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(foreground, BlendMode.srcIn),
          )
        : Icon(icon, size: 20, color: foreground);
    final Widget content = isCollapsed
        ? Center(
            child: Badge(
              isLabelVisible: hasBadge,
              smallSize: 7,
              backgroundColor: AppColors.statusCoral,
              child: iconWidget,
            ),
          )
        : Padding(
            padding: AppTheme.sidebarItemPadding,
            child: Row(
              children: [
                iconWidget,
                const SizedBox(width: AppTheme.sidebarItemGap),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      label,
                      style: AppTextStyles.sidebarItem.copyWith(
                        color: foreground,
                        height: 1.3,
                      ),
                    ),
                  ),
                ),
                if (hasBadge) _CountBadge(count: badgeCount!),
              ],
            ),
          );
    return Tooltip(
      message: isCollapsed ? label : '',
      child: SizedBox(
        width: isCollapsed
            ? AppTheme.sidebarItemHeight
            : AppTheme.sidebarItemWidth,
        child: Material(
          color: isSelected ? AppColors.sidebarSelected : Colors.transparent,
          borderRadius: radius,
          child: InkWell(
            onTap: onTap,
            borderRadius: radius,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: AppTheme.sidebarItemHeight,
              ),
              child: content,
            ),
          ),
        ),
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 18),
      height: 18,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.statusCoral,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text('$count', style: AppTextStyles.badge),
    );
  }
}
