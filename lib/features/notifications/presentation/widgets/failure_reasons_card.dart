import 'package:flutter/material.dart';

import '../../../../core/resources/strings/notifications_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../data/models/admin_notification.dart';

class FailureReasonsCard extends StatelessWidget {
  const FailureReasonsCard({super.key, required this.reasons});

  final List<FailureReasonCount> reasons;

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
                  NotificationsStrings.failureReasons,
                  style: AppTextStyles.cardTitle,
                ),
                Text(
                  NotificationsStrings.failureReasonsNote,
                  style: AppTextStyles.meta,
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),
          if (reasons.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 28),
              child: Text(
                NotificationsStrings.noFailedDeliveries,
                style: AppTextStyles.bodySmall,
                textAlign: TextAlign.center,
              ),
            ),
          for (int i = 0; i < reasons.length; i++)
            _ReasonRow(reason: reasons[i], showDivider: i < reasons.length - 1),
        ],
      ),
    );
  }
}

class _ReasonRow extends StatelessWidget {
  const _ReasonRow({required this.reason, required this.showDivider});

  final FailureReasonCount reason;
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
          Expanded(child: Text(reason.reason, style: AppTextStyles.bodySmall)),
          const SizedBox(width: 12),
          Text(
            NotificationsStrings.devicesCount(
              AppFormatters.number(reason.count),
            ),
            style: AppTextStyles.titleSmall,
          ),
        ],
      ),
    );
  }
}
