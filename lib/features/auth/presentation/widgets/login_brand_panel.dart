import 'package:flutter/material.dart';

import '../../../../core/resources/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_brand_logo.dart';

class LoginBrandPanel extends StatelessWidget {
  const LoginBrandPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.ink,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppBrandLogo(onDark: true),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 480),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.loginHeroTitle,
                            style: AppTextStyles.displayHero,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            AppStrings.loginHeroSubtitle,
                            style: AppTextStyles.heroSubtitle,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const _SecurityNote(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SecurityNote extends StatelessWidget {
  const _SecurityNote();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.shield_outlined,
          size: 16,
          color: AppColors.onInkMuted,
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            AppStrings.loginSecurityNote,
            style: AppTextStyles.caption,
          ),
        ),
      ],
    );
  }
}
