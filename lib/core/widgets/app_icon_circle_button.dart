import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

class AppIconCircleButton extends StatelessWidget {
  const AppIconCircleButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.size = AppTheme.iconButtonSize,
    this.showDot = false,
    this.borderRadius,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final double size;
  final bool showDot;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final double? radius = borderRadius;
    final ShapeBorder shape = radius == null
        ? const CircleBorder()
        : RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius));
    return Tooltip(
      message: tooltip,
      child: Material(
        color: AppColors.iconCircle,
        shape: shape,
        child: InkWell(
          onTap: onPressed,
          customBorder: shape,
          child: SizedBox.square(
            dimension: size,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(icon, size: size * 0.5, color: AppColors.textPrimary),
                if (showDot)
                  Positioned(
                    top: size * 0.24,
                    right: size * 0.26,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.statusCoral,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
