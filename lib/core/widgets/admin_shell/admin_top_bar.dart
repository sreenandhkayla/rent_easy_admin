import 'package:flutter/material.dart';

import '../../resources/strings/app_strings.dart';
import '../../theme/app_text_styles.dart';
import '../app_icon_circle_button.dart';
import '../app_initials_avatar.dart';
import 'admin_section.dart';

class AdminTopBar extends StatelessWidget {
  const AdminTopBar({
    super.key,
    required this.title,
    required this.subtitle,
    this.breadcrumb,
    required this.onNotifications,
    this.actions = const [],
    this.hasUnreadNotifications = false,
  });

  final String title;
  final String subtitle;
  final Widget? breadcrumb;
  final List<Widget> actions;
  final VoidCallback onNotifications;
  final bool hasUnreadNotifications;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.start,
      spacing: 16,
      runSpacing: 16,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (breadcrumb != null) ...[
              breadcrumb!,
              const SizedBox(height: 10),
            ],
            Text(title, style: AppTextStyles.pageTitle),
            const SizedBox(height: 6),
            Text(subtitle, style: AppTextStyles.bodyCaption),
          ],
        ),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ...actions,
            AppIconCircleButton(
              icon: Icons.notifications_none_outlined,
              tooltip: AppStrings.navNotifications,
              showDot: hasUnreadNotifications,
              onPressed: onNotifications,
            ),
            Tooltip(
              message: AdminProfile.current.name,
              child: AppInitialsAvatar(name: AdminProfile.current.name),
            ),
          ],
        ),
      ],
    );
  }
}
