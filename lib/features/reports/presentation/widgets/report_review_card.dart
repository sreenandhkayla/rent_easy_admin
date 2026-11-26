import 'package:flutter/material.dart';

import '../../../../core/resources/images/app_images.dart';
import '../../../../core/resources/strings/reports_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_checkbox_row.dart';
import '../../../../core/widgets/app_dropdown.dart';
import '../../../../core/widgets/app_labeled_field.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_secondary_button.dart';
import '../../data/models/shop_report.dart';

class ReportReviewCard extends StatelessWidget {
  const ReportReviewCard({
    super.key,
    required this.report,
    required this.admins,
    required this.notifyShop,
    required this.onAssign,
    required this.onAssignCorrection,
    required this.onNotifyChanged,
    required this.onRequestClarification,
    required this.onResolve,
    required this.onDismiss,
  });

  final ShopReport report;
  final List<String> admins;
  final bool notifyShop;
  final ValueChanged<String?> onAssign;
  final ValueChanged<String?> onAssignCorrection;
  final ValueChanged<bool> onNotifyChanged;
  final VoidCallback onRequestClarification;
  final VoidCallback onResolve;
  final VoidCallback onDismiss;

  Widget _assignment(String? value, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppLabeledField(
          label: ReportsStrings.assignTo,
          child: AppDropdown<String?>(
            value: value,
            items: [null, ...admins],
            labelOf: (admin) => admin ?? ReportsStrings.unassigned,
            onChanged: onChanged,
            isExpanded: true,
          ),
        ),
        const SizedBox(height: 10),
        AppCheckboxRow(
          label: ReportsStrings.notifyShop,
          value: notifyShop,
          onChanged: onNotifyChanged,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isClosed = report.status.isClosed;
    final ReportCorrection? correction = report.correction;
    final bool hasOpenCorrection =
        correction != null &&
        correction.status == CorrectionStatus.awaitingReview;
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            ReportsStrings.reviewTitle,
            style: AppTextStyles.cardTitle,
          ),
          const SizedBox(height: 14),
          if (isClosed && hasOpenCorrection) ...[
            _assignment(correction.assignedAdmin, onAssignCorrection),
            const SizedBox(height: 10),
            const Text(
              ReportsStrings.closedCorrectionNote,
              style: AppTextStyles.meta,
            ),
          ] else if (isClosed)
            Text(
              report.status == ReportStatus.dismissed
                  ? ReportsStrings.closedDismissedNote
                  : ReportsStrings.closedResolvedNote,
              style: AppTextStyles.bodySmall,
            )
          else ...[
            _assignment(report.assignedAdmin, onAssign),
            const SizedBox(height: 12),
            AppSecondaryButton(
              label: ReportsStrings.requestClarification,
              svgIcon: AppImages.mailIcon,
              iconColor: AppColors.textPrimary,
              isExpanded: true,
              labelStyle: AppTextStyles.actionLabel,
              onPressed: onRequestClarification,
            ),
            const SizedBox(height: 10),
            AppPrimaryButton(
              label: ReportsStrings.resolveWithDecision,
              icon: Icons.check,
              isCompact: true,
              labelStyle: AppTextStyles.actionLabel,
              onPressed: onResolve,
            ),
            const SizedBox(height: 10),
            AppSecondaryButton(
              label: ReportsStrings.dismissReport,
              isDestructive: true,
              isExpanded: true,
              labelStyle: AppTextStyles.actionLabel,
              onPressed: onDismiss,
            ),
          ],
        ],
      ),
    );
  }
}
