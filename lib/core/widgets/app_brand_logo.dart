import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../resources/images/app_images.dart';
import '../resources/strings/app_strings.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';

class AppBrandLogo extends StatelessWidget {
  const AppBrandLogo({
    super.key,
    this.onDark = false,
    this.showText = true,
    this.size = 40,
    this.name,
  });

  final bool onDark;
  final bool showText;
  final double size;
  final String? name;

  @override
  Widget build(BuildContext context) {
    final Widget mark = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: onDark ? AppColors.surface : AppColors.ink,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: Center(
        child: SvgPicture.asset(
          AppImages.buildIcon,
          width: size * 0.55,
          height: size * 0.55,
          colorFilter: onDark
              ? null
              : const ColorFilter.mode(AppColors.onInk, BlendMode.srcIn),
        ),
      ),
    );
    if (!showText) return mark;
    return Row(
      children: [
        mark,
        const SizedBox(width: 12),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name ?? AppStrings.appName,
                style: onDark
                    ? AppTextStyles.brandTitle
                    : AppTextStyles.sidebarBrandTitle,
              ),
              Text(
                AppStrings.adminConsole,
                style: onDark ? AppTextStyles.caption : AppTextStyles.meta,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
