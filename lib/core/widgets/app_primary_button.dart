import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';

class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isCompact = false,
    this.isDestructive = false,
    this.svgIcon,
    this.icon,
    this.labelStyle,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isCompact;
  final bool isDestructive;
  final String? svgIcon;
  final IconData? icon;
  final TextStyle? labelStyle;

  TextStyle get _labelStyle =>
      labelStyle?.copyWith(color: AppColors.onInk) ?? AppTextStyles.button;

  @override
  Widget build(BuildContext context) {
    final Color background = isDestructive ? AppColors.danger : AppColors.ink;
    return SizedBox(
      height: isCompact ? AppTheme.compactButtonHeight : AppTheme.buttonHeight,
      width: isCompact ? null : double.infinity,
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: background,
          foregroundColor: AppColors.onInk,
          disabledBackgroundColor: background,
          padding: isCompact
              ? const EdgeInsets.symmetric(horizontal: 16)
              : AppTheme.buttonPadding,
          side: BorderSide(
            color: isDestructive ? AppColors.danger : AppColors.buttonBorder,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              isCompact ? AppTheme.radiusMedium : AppTheme.radiusLarge,
            ),
          ),
          textStyle: _labelStyle,
        ),
        child: isLoading
            ? const SizedBox.square(
                dimension: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.onInk,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (svgIcon != null) ...[
                    SvgPicture.asset(
                      svgIcon!,
                      width: 16,
                      height: 16,
                      colorFilter: const ColorFilter.mode(
                        AppColors.onInk,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ] else if (icon != null) ...[
                    Icon(icon, size: 16, color: AppColors.onInk),
                    const SizedBox(width: 8),
                  ],
                  Flexible(child: Text(label, style: _labelStyle)),
                ],
              ),
      ),
    );
  }
}
