import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors.dart';

class AppIconCircle extends StatelessWidget {
  const AppIconCircle({super.key, this.icon, this.svgIcon, this.size = 32})
    : assert(icon != null || svgIcon != null);

  final IconData? icon;
  final String? svgIcon;
  final double size;

  @override
  Widget build(BuildContext context) {
    final double iconSize = size * 0.5;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColors.iconCircle,
        shape: BoxShape.circle,
      ),
      child: svgIcon != null
          ? SvgPicture.asset(
              svgIcon!,
              width: iconSize,
              height: iconSize,
              colorFilter: const ColorFilter.mode(
                AppColors.textPrimary,
                BlendMode.srcIn,
              ),
            )
          : Icon(icon, size: iconSize, color: AppColors.textPrimary),
    );
  }
}
