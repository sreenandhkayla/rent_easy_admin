import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  static const double radiusSmall = 8;
  static const double radiusMedium = 10;
  static const double radiusLarge = 12;
  static const double buttonHeight = 48;
  static const double fieldHeight = 52;
  static const EdgeInsets fieldPadding = EdgeInsets.symmetric(
    horizontal: 14,
    vertical: 14.5,
  );
  static const EdgeInsets buttonPadding = EdgeInsets.fromLTRB(
    18,
    12.5,
    18,
    13.5,
  );
  static const double sidebarItemWidth = 223;
  static const double sidebarItemHeight = 44;
  static const double sidebarItemGap = 12;
  static const EdgeInsets sidebarItemPadding = EdgeInsets.symmetric(
    horizontal: 12,
  );
  static const double authFormMaxWidth = 420;
  static const double radiusCard = 16;
  static const double sidebarWidth = 255;
  static const double sidebarCollapsedWidth = 76;
  static const double compactButtonHeight = 40;
  static const double dialogMaxWidth = 420;
  static const double dialogWideMaxWidth = 500;
  static const double radiusDialog = 20;
  static const double iconButtonSize = 36;
  static const double toolbarControlHeight = 44;
  static const EdgeInsets toolbarFieldPadding = EdgeInsets.symmetric(
    horizontal: 14,
  );
  static const double searchFieldMaxWidth = 420;
  static const Duration pageTransitionDuration = Duration(milliseconds: 220);
  static const Curve pageTransitionCurve = Curves.easeOutCubic;
  static const Offset pageTransitionOffset = Offset(0, 0.015);

  static ThemeData get light {
    final OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(radiusLarge),
      borderSide: const BorderSide(color: AppColors.border),
    );
    return ThemeData(
      useMaterial3: true,
      fontFamily: AppTextStyles.fontFamily,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.ink,
        primary: AppColors.ink,
        onPrimary: AppColors.onInk,
        surface: AppColors.background,
        error: AppColors.error,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.ink,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        isDense: true,
        contentPadding: fieldPadding,
        hintStyle: AppTextStyles.inputHint,
        errorStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
        border: border,
        enabledBorder: border,
        focusedBorder: border.copyWith(
          borderSide: const BorderSide(color: AppColors.ink),
        ),
        errorBorder: border.copyWith(
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: border.copyWith(
          borderSide: const BorderSide(color: AppColors.error),
        ),
      ),
    );
  }
}
