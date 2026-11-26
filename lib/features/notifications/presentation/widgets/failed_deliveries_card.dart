import 'package:flutter/material.dart';

import '../../../../core/resources/strings/notifications_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../data/models/admin_notification.dart';

class FailedDeliveriesCard extends StatelessWidget {
  const FailedDeliveriesCard({super.key, required this.failures});

  final List<DeliveryFailure> failures;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 18, 16, 14),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              runSpacing: 4,
              children: [
                Text(
                  NotificationsStrings.failedDeliveries,
                  style: AppTextStyles.cardTitle,
                ),
                Text(
                  NotificationsStrings.failedDeliveriesNote,
                  style: AppTextStyles.meta,
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),
          if (failures.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 28),
              child: Text(
                NotificationsStrings.noFailedDeliveries,
                style: AppTextStyles.bodySmall,
                textAlign: TextAlign.center,
              ),
            ),
          for (int i = 0; i < failures.length; i++)
            _FailureRow(
              failure: failures[i],
              showDivider: i < failures.length - 1,
            ),
        ],
      ),
    );
  }
}

class _FailureRow extends StatelessWidget {
  const _FailureRow({required this.failure, required this.showDivider});

  final DeliveryFailure failure;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(bottom: BorderSide(color: AppColors.divider))
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Text(failure.shopName, style: AppTextStyles.titleSmall),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Text(failure.reason, style: AppTextStyles.bodySmall),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Text(
              AppFormatters.timestamp(failure.at),
              style: AppTextStyles.tableCell,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
