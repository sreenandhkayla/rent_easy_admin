import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';

class AppSecondaryButton extends StatelessWidget {
  const AppSecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.svgIcon,
    this.isDestructive = false,
    this.isExpanded = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final String? svgIcon;
  final bool isDestructive;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final Color foreground = isDestructive
        ? AppColors.danger
        : AppColors.textPrimary;
    final Color iconColor = isDestructive
        ? AppColors.danger
        : AppColors.textSecondary;
    final Widget? leading = svgIcon != null
        ? SvgPicture.asset(
            svgIcon!,
            width: 16,
            height: 16,
            colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
          )
        : icon != null
        ? Icon(icon, size: 16, color: iconColor)
        : null;
    return SizedBox(
      height: AppTheme.compactButtonHeight,
      width: isExpanded ? double.infinity : null,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.surface,
          foregroundColor: foreground,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          side: BorderSide(
            color: isDestructive ? AppColors.dangerBorder : AppColors.border,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
          textStyle: AppTextStyles.buttonSecondary,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leading != null) ...[leading, const SizedBox(width: 8)],
            Flexible(
              child: Text(
                label,
                style: AppTextStyles.buttonSecondary.copyWith(
                  color: foreground,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
