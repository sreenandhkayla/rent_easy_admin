import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';

enum AppNoticeTone { danger, warning, info, success }

class AppNoticeBanner extends StatelessWidget {
  const AppNoticeBanner({
    super.key,
    required this.tone,
    this.title,
    this.message,
    this.spans,
    this.icon,
    this.svgIcon,
  });

  final AppNoticeTone tone;
  final String? title;
  final String? message;
  final List<InlineSpan>? spans;
  final IconData? icon;
  final String? svgIcon;

  @override
  Widget build(BuildContext context) {
    final (Color background, Color foreground) = switch (tone) {
      AppNoticeTone.danger => (
        AppColors.bannerDangerBackground,
        AppColors.bannerDangerText,
      ),
      AppNoticeTone.warning => (
        AppColors.bannerWarningBackground,
        AppColors.pillAmberText,
      ),
      AppNoticeTone.info => (
        AppColors.bannerInfoBackground,
        AppColors.textPrimary,
      ),
      AppNoticeTone.success => (
        AppColors.bannerSuccessBackground,
        AppColors.bannerSuccessText,
      ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: svgIcon != null
                ? SvgPicture.asset(
                    svgIcon!,
                    width: 16,
                    height: 16,
                    colorFilter: ColorFilter.mode(foreground, BlendMode.srcIn),
                  )
                : Icon(icon, size: 16, color: foreground),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  if (title != null) ...[
                    TextSpan(
                      text: title,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const TextSpan(text: ' '),
                  ],
                  if (message case final String text) TextSpan(text: text),
                  ...?spans,
                ],
              ),
              style: AppTextStyles.banner.copyWith(color: foreground),
            ),
          ),
        ],
      ),
    );
  }
}
