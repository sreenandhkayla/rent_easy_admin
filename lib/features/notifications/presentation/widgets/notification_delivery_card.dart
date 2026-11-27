import 'package:flutter/material.dart';

import '../../../../core/resources/strings/notifications_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_progress_row.dart';
import '../../data/models/admin_notification.dart';

class NotificationDeliveryCard extends StatelessWidget {
  const NotificationDeliveryCard({super.key, required this.notification});

  final AdminNotification notification;

  String get _statusNote => switch (notification.status) {
    NotificationStatus.draft => NotificationsStrings.draftNote,
    NotificationStatus.queued => NotificationsStrings.queuedNote,
    NotificationStatus.sending => NotificationsStrings.sendingNote,
    NotificationStatus.sent => NotificationsStrings.sentNote,
    NotificationStatus.failed => NotificationsStrings.failedNote,
  };

  static String _time(DateTime? at) => at == null
      ? NotificationsStrings.emptyValue
      : AppFormatters.timestamp(at);

  @override
  Widget build(BuildContext context) {
    final double? share = notification.deliveredShare;
    final String? error = notification.errorMessage;
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
          _InfoLine(
            label: NotificationsStrings.createdBy,
            value: notification.createdByName.isEmpty
                ? NotificationsStrings.emptyValue
                : notification.createdByName,
          ),
          _InfoLine(
            label: NotificationsStrings.createdAt,
            value: _time(notification.createdAt),
          ),
          if (notification.queuedAt != null)
            _InfoLine(
              label: NotificationsStrings.queuedAt,
              value: _time(notification.queuedAt),
            ),
          if (notification.sentAt != null)
            _InfoLine(
              label: NotificationsStrings.sentAt,
              value: _time(notification.sentAt),
            ),
          if (notification.devices case final int devices)
            _InfoLine(
              label: NotificationsStrings.devicesTargeted,
              value: AppFormatters.number(devices),
            ),
          if (notification.ownersWithoutDevices case final int owners
              when owners > 0)
            _InfoLine(
              label: NotificationsStrings.ownersWithoutDevices,
              value: AppFormatters.number(owners),
            ),
          const SizedBox(height: 10),
          Text(_statusNote, style: AppTextStyles.meta),
          if (error != null) ...[
            const SizedBox(height: 8),
            Text(error, style: AppTextStyles.fieldError),
          ],
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(child: Text(label, style: AppTextStyles.bodySmall)),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              style: AppTextStyles.titleSmall,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
