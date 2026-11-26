import 'package:flutter/material.dart';

import '../../../../core/resources/strings/notifications_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_progress_row.dart';
import '../../../../core/widgets/app_secondary_button.dart';
import '../../data/models/admin_notification.dart';

class NotificationDeliveryCard extends StatelessWidget {
  const NotificationDeliveryCard({
    super.key,
    required this.notification,
    required this.onCancelScheduled,
  });

  final AdminNotification notification;
  final VoidCallback onCancelScheduled;

  @override
  Widget build(BuildContext context) {
    final double? share = notification.deliveredShare;
    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            NotificationsStrings.deliveryStatus,
            style: AppTextStyles.cardTitle,
          ),
          const SizedBox(height: 14),
          AppProgressRow(
            label: NotificationsStrings.delivered,
            trailing: share == null
                ? NotificationsStrings.notSentYet
                : NotificationsStrings.deliveredShare(
                    AppFormatters.percent(share),
                  ),
            fraction: share ?? 0,
            labelStyle: AppTextStyles.bodySmall,
            trailingStyle: AppTextStyles.titleSmall,
            barHeight: 8,
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Flexible(
                child: Text(
                  NotificationsStrings.createdBy,
                  style: AppTextStyles.bodySmall,
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  notification.createdBy,
                  style: AppTextStyles.titleSmall,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            NotificationsStrings.deliveryNote,
            style: AppTextStyles.meta,
          ),
          if (notification.status == NotificationStatus.scheduled) ...[
            const SizedBox(height: 14),
            AppSecondaryButton(
              label: NotificationsStrings.cancelScheduledSend,
              isDestructive: true,
              isExpanded: true,
              labelStyle: AppTextStyles.actionLabel,
              onPressed: onCancelScheduled,
            ),
          ],
        ],
      ),
    );
  }
}
