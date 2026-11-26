import 'package:flutter/material.dart';

import '../../../../core/resources/strings/notifications_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_detail_field.dart';
import '../../../../core/widgets/app_responsive_grid.dart';
import '../../data/models/admin_notification.dart';

class NotificationMessageCard extends StatelessWidget {
  const NotificationMessageCard({super.key, required this.notification});

  final AdminNotification notification;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            NotificationsStrings.message,
            style: AppTextStyles.cardTitle,
          ),
          const SizedBox(height: 14),
          AppResponsiveGrid(
            minItemWidth: 180,
            maxColumns: 2,
            spacing: 18,
            children: [
              AppDetailField(
                label: NotificationsStrings.type,
                value: notification.type.label,
              ),
              AppDetailField(
                label: NotificationsStrings.audience,
                value: notification.audience.label,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.contentBackground,
              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notification.title, style: AppTextStyles.titleSmall),
                const SizedBox(height: 8),
                Text(notification.message, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
