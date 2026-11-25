import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_theme.dart';

class AppSearchField extends StatelessWidget {
  const AppSearchField({
    super.key,
    required this.hintText,
    required this.onChanged,
    this.controller,
  });

  final String hintText;
  final ValueChanged<String> onChanged;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: AppTextStyles.input,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: AppTheme.toolbarFieldPadding,
        prefixIcon: const Icon(
          Icons.search,
          size: 18,
          color: AppColors.textSecondary,
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 40),
      ),
    );
  }
}
