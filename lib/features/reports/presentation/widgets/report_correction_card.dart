import 'package:flutter/material.dart';

import '../../../../core/resources/strings/reports_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_status_pill.dart';
import '../../data/models/shop_report.dart';

class ReportCorrectionCard extends StatelessWidget {
  const ReportCorrectionCard({
    super.key,
    required this.correction,
    required this.onReview,
  });

  final ReportCorrection correction;
  final VoidCallback onReview;

  @override
  Widget build(BuildContext context) {
    final bool isAwaiting =
        correction.status == CorrectionStatus.awaitingReview;
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Text(
                  ReportsStrings.correctionTitle,
                  style: AppTextStyles.cardTitle,
                ),
              ),
              const SizedBox(width: 12),
              isAwaiting
                  ? const AppStatusPill(
                      label: ReportsStrings.correctionAwaitingReview,
                      color: AppColors.pillAmberText,
                      backgroundColor: AppColors.pillAmberBackground,
                    )
                  : const AppStatusPill(
                      label: ReportsStrings.correctionReviewed,
                      color: AppColors.statusGreen,
                      backgroundColor: AppColors.pillGreenBackground,
                    ),
            ],
          ),
          const SizedBox(height: 12),
          Text(correction.summary, style: AppTextStyles.tableCell),
          const SizedBox(height: 8),
          Text(
            ReportsStrings.receivedOn(
              AppFormatters.date(correction.receivedAt),
            ),
            style: AppTextStyles.meta,
          ),
          if (isAwaiting) ...[
            const SizedBox(height: 14),
            Align(
              alignment: Alignment.centerLeft,
              child: AppPrimaryButton(
                label: ReportsStrings.reviewCorrection,
                isCompact: true,
                labelStyle: AppTextStyles.actionLabel,
                onPressed: onReview,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
