import 'package:flutter/material.dart';

import '../../../../core/resources/strings/analytics_strings.dart';
import '../../../../core/resources/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_dialog_frame.dart';
import '../../../../core/widgets/app_dropdown.dart';
import '../../../../core/widgets/app_labeled_field.dart';
import '../../../../core/widgets/app_notice_banner.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_secondary_button.dart';
import '../../data/models/analytics_export.dart';

class ExportReportDialog extends StatefulWidget {
  const ExportReportDialog({super.key});

  static Future<AnalyticsExportRequest?> show(BuildContext context) {
    return showDialog<AnalyticsExportRequest>(
      context: context,
      barrierColor: AppColors.scrim,
      builder: (_) => const ExportReportDialog(),
    );
  }

  @override
  State<ExportReportDialog> createState() => _ExportReportDialogState();
}

class _ExportReportDialogState extends State<ExportReportDialog> {
  static const double _stackBreakpoint = 320;

  AnalyticsExportReport _report = AnalyticsExportReport.shopAnalytics;
  AnalyticsExportFormat _format = AnalyticsExportFormat.csv;

  @override
  Widget build(BuildContext context) {
    final NavigatorState navigator = Navigator.of(context);
    final Widget report = AppLabeledField(
      label: AnalyticsStrings.exportReportLabel,
      child: AppDropdown<AnalyticsExportReport>(
        value: _report,
        items: AnalyticsExportReport.values,
        labelOf: (item) => item.label,
        onChanged: (item) => setState(() => _report = item),
        isExpanded: true,
      ),
    );
    final Widget format = AppLabeledField(
      label: AnalyticsStrings.exportFormatLabel,
      child: AppDropdown<AnalyticsExportFormat>(
        value: _format,
        items: AnalyticsExportFormat.values,
        labelOf: (item) => item.label,
        onChanged: (item) => setState(() => _format = item),
        isExpanded: true,
      ),
    );
    return AppDialogFrame(
      title: AnalyticsStrings.exportReport,
      onClose: navigator.pop,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            AnalyticsStrings.exportMessage,
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 16),
          const AppNoticeBanner(
            tone: AppNoticeTone.info,
            icon: Icons.warning_amber_rounded,
            message: AnalyticsStrings.exportNotice,
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < _stackBreakpoint) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [report, const SizedBox(height: 14), format],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: report),
                  const SizedBox(width: 12),
                  Expanded(child: format),
                ],
              );
            },
          ),
        ],
      ),
      actions: [
        AppSecondaryButton(label: AppStrings.cancel, onPressed: navigator.pop),
        AppPrimaryButton(
          label: AnalyticsStrings.prepareExport,
          isCompact: true,
          onPressed: () => navigator.pop(
            AnalyticsExportRequest(report: _report, format: _format),
          ),
        ),
      ],
    );
  }
}
