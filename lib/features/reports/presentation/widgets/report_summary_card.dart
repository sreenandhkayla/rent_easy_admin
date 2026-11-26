import 'package:flutter/material.dart';

import '../../../../core/resources/images/app_images.dart';
import '../../../../core/resources/strings/reports_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_detail_field.dart';
import '../../../../core/widgets/app_notice_banner.dart';
import '../../../../core/widgets/app_responsive_grid.dart';
import '../../../../core/widgets/app_status_pill.dart';
import '../../data/models/shop_report.dart';
import 'report_status_pill.dart';

class ReportSummaryCard extends StatelessWidget {
  const ReportSummaryCard({super.key, required this.report});

  final ShopReport report;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      report.category.label,
                      style: AppTextStyles.profileName,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ReportsStrings.reportLine(
                        report.reportId,
                        AppFormatters.date(report.submittedAt),
                      ),
                      style: AppTextStyles.bodyCaption,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ReportStatusPill(status: report.status),
              ),
            ],
          ),
          const Divider(height: 36, color: AppColors.divider),
          AppResponsiveGrid(
            minItemWidth: 180,
            maxColumns: 2,
            spacing: 18,
            children: [
              AppDetailField(
                label: ReportsStrings.reportingShop,
                value: report.shopName,
              ),
              _ReportedPartyField(report: report),
              AppDetailField(
                label: ReportsStrings.reason,
                value: report.reason,
              ),
              AppDetailField(
                label: ReportsStrings.assignedAdmin,
                value: report.assignedAdmin ?? ReportsStrings.unassigned,
              ),
            ],
          ),
          const SizedBox(height: 22),
          const Text(
            ReportsStrings.description,
            style: AppTextStyles.titleSmall,
          ),
          const SizedBox(height: 8),
          Text(report.description, style: AppTextStyles.tableCell),
          const SizedBox(height: 20),
          const Text(
            ReportsStrings.supportingInformation,
            style: AppTextStyles.titleSmall,
          ),
          const SizedBox(height: 8),
          Text(report.supportingInformation, style: AppTextStyles.bodySmall),
          if (report.status.isClosed && report.decisionNote != null) ...[
            const SizedBox(height: 20),
            AppNoticeBanner(
              tone: AppNoticeTone.success,
              svgIcon: AppImages.rightMarkIcon,
              title: ReportsStrings.recordedDecision,
              message: report.decisionNote,
            ),
          ],
        ],
      ),
    );
  }
}

class _ReportedPartyField extends StatelessWidget {
  const _ReportedPartyField({required this.report});

  final ShopReport report;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          ReportsStrings.reportedParty,
          style: AppTextStyles.bodyCaption,
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 10,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(report.reportedParty, style: AppTextStyles.detailValue),
            if (report.isPartyMasked)
              const AppStatusPill(
                label: ReportsStrings.masked,
                color: AppColors.textSecondary,
                backgroundColor: AppColors.iconCircle,
                showDot: false,
              ),
          ],
        ),
      ],
    );
  }
}
