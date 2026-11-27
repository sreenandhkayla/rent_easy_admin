import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/resources/images/app_images.dart';
import '../../../../core/resources/strings/app_strings.dart';
import '../../../../core/resources/strings/notifications_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_secondary_button.dart';
import '../../../../core/widgets/app_table_header.dart';
import '../../data/models/admin_notification.dart';
import 'notification_status_pill.dart';

class NotificationsTable extends StatelessWidget {
  const NotificationsTable({
    super.key,
    required this.rows,
    required this.onView,
    required this.onEdit,
    this.isLoading = false,
  });

  static const double _minTableWidth = 960;
  static const double _progressHeight = 2;

  final List<AdminNotification> rows;
  final ValueChanged<AdminNotification> onView;
  final ValueChanged<AdminNotification> onEdit;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: math.max(constraints.maxWidth, _minTableWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _HeaderRow(),
                SizedBox(
                  height: _progressHeight,
                  child: isLoading
                      ? const LinearProgressIndicator(
                          minHeight: _progressHeight,
                        )
                      : null,
                ),
                if (rows.isEmpty && !isLoading)
                  const AppEmptyState(
                    svgIcon: AppImages.notificationIcon,
                    title: NotificationsStrings.noNotificationsTitle,
                    message: NotificationsStrings.noNotificationsMessage,
                  ),
                for (int i = 0; i < rows.length; i++)
                  _NotificationRow(
                    item: rows[i],
                    showDivider: i < rows.length - 1,
                    onView: () => onView(rows[i]),
                    onEdit: () => onEdit(rows[i]),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Columns {
  static const int notification = 25;
  static const int type = 15;
  static const int audience = 14;
  static const int date = 13;
  static const int status = 11;
  static const int delivered = 9;
  static const double action = 72;
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow();

  @override
  Widget build(BuildContext context) {
    Widget cell(String label, int flex, {bool end = false}) => Expanded(
      flex: flex,
      child: Padding(
        padding: EdgeInsets.only(right: end ? 24 : 12),
        child: Text(
          label,
          style: AppTextStyles.tableHeader,
          textAlign: end ? TextAlign.end : TextAlign.start,
        ),
      ),
    );
    return AppTableHeader(
      showTopBorder: false,
      child: Row(
        children: [
          cell(NotificationsStrings.notification, _Columns.notification),
          cell(NotificationsStrings.type, _Columns.type),
          cell(NotificationsStrings.audience, _Columns.audience),
          cell(NotificationsStrings.date, _Columns.date),
          cell(NotificationsStrings.status, _Columns.status),
          cell(NotificationsStrings.delivered, _Columns.delivered, end: true),
          const SizedBox(width: _Columns.action),
        ],
      ),
    );
  }
}

class _NotificationRow extends StatelessWidget {
  const _NotificationRow({
    required this.item,
    required this.showDivider,
    required this.onView,
    required this.onEdit,
  });

  final AdminNotification item;
  final bool showDivider;
  final VoidCallback onView;
  final VoidCallback onEdit;

  String get _date {
    final DateTime? at = item.sentAt ?? item.queuedAt ?? item.createdAt;
    return at == null
        ? NotificationsStrings.emptyValue
        : AppFormatters.timestamp(at);
  }

  String get _delivered {
    final int? delivered = item.delivered;
    final int? devices = item.devices;
    if (delivered == null || devices == null) {
      return NotificationsStrings.emptyValue;
    }
    return NotificationsStrings.deliveredOf(
      AppFormatters.number(delivered),
      AppFormatters.number(devices),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget text(String value, int flex, {bool end = false}) => Expanded(
      flex: flex,
      child: Padding(
        padding: EdgeInsets.only(right: end ? 24 : 12),
        child: Text(
          value,
          style: AppTextStyles.tableCell,
          textAlign: end ? TextAlign.end : TextAlign.start,
        ),
      ),
    );
    final bool isDraft = item.status == NotificationStatus.draft;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(bottom: BorderSide(color: AppColors.divider))
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            flex: _Columns.notification,
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, style: AppTextStyles.titleSmall),
                  const SizedBox(height: 2),
                  if (item.createdByName.isNotEmpty)
                    Text(item.createdByName, style: AppTextStyles.meta),
                ],
              ),
            ),
          ),
          text(item.type.label, _Columns.type),
          text(item.audience.label, _Columns.audience),
          text(_date, _Columns.date),
          Expanded(
            flex: _Columns.status,
            child: Align(
              alignment: Alignment.centerLeft,
              child: NotificationStatusPill(status: item.status),
            ),
          ),
          text(_delivered, _Columns.delivered, end: true),
          SizedBox(
            width: _Columns.action,
            child: Align(
              alignment: Alignment.centerRight,
              child: AppSecondaryButton(
                label: isDraft ? NotificationsStrings.edit : AppStrings.view,
                onPressed: isDraft ? onEdit : onView,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
