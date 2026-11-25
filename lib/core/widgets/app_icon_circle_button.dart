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
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final double size;
  final bool showDot;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: AppColors.iconCircle,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
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
