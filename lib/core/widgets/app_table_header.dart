import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppTableHeader extends StatelessWidget {
  const AppTableHeader({
    super.key,
    required this.child,
    this.showTopBorder = true,
  });

  final Widget child;
  final bool showTopBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.tableHeaderBackground,
        border: Border(
          top: showTopBorder
              ? const BorderSide(color: AppColors.tableHeaderBorder)
              : BorderSide.none,
          bottom: const BorderSide(color: AppColors.tableHeaderBorder),
        ),
      ),
      child: child,
    );
  }
}
