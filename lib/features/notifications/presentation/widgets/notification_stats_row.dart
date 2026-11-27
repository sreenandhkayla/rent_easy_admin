import 'package:flutter/material.dart';

import '../../../../core/resources/strings/notifications_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_responsive_grid.dart';
import '../../../../core/widgets/app_stat_card.dart';
import '../../data/models/admin_notification.dart';
import 'notification_status_pill.dart';

class NotificationStatsRow extends StatelessWidget {
  const NotificationStatsRow({super.key, required this.notification});

  final AdminNotification notification;

  String _count(int? value) => value == null
      ? NotificationsStrings.emptyValue
      : AppFormatters.number(value);

  @override
  Widget build(BuildContext context) {
    final double? share = notification.deliveredShare;
    final DateTime? sentAt = notification.sentAt;
    return AppResponsiveGrid(
      minItemWidth: 200,
      children: [
        AppStatCard(
          label: NotificationsStrings.uniqueRecipients,
          value: _count(notification.recipients),
          caption: notification.audience.label,
        ),
        AppStatCard(
          label: NotificationsStrings.delivered,
          value: _count(notification.delivered ?? 0),
          caption: share == null
              ? NotificationsStrings.notSentYet
              : NotificationsStrings.deliveredShare(
                  AppFormatters.percent(share),
                ),
          dotColor: AppColors.statusGreen,
        ),
        AppStatCard(
          label: NotificationsStrings.failed,
          value: _count(notification.failed ?? 0),
          caption: NotificationsStrings.failedCaption,
          dotColor: AppColors.statusRed,
        ),
        AppCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                NotificationsStrings.status,
                style: AppTextStyles.labelRegular,
              ),
              const SizedBox(height: 10),
              NotificationStatusPill(status: notification.status),
              const Spacer(),
              const SizedBox(height: 8),
              Text(
                sentAt == null
                    ? NotificationsStrings.notSentYet
                    : AppFormatters.timestamp(sentAt),
                style: AppTextStyles.meta,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
