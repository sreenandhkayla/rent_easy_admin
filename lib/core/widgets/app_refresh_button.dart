import 'package:flutter/material.dart';

import '../resources/images/app_images.dart';
import '../resources/strings/app_strings.dart';
import 'app_secondary_button.dart';

class AppRefreshButton extends StatelessWidget {
  const AppRefreshButton({
    super.key,
    required this.updatedAt,
    required this.onPressed,
  });

  final DateTime updatedAt;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: AppStrings.refresh,
      child: AppSecondaryButton(
        svgIcon: AppImages.refreshIcon,
        label: AppStrings.updatedAt(updatedAt),
        onPressed: onPressed,
      ),
    );
  }
}
