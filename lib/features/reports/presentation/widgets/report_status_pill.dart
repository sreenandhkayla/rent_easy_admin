import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_status_pill.dart';
import '../../data/models/shop_report.dart';

class ReportStatusPill extends StatelessWidget {
  const ReportStatusPill({super.key, required this.status});

  final ReportStatus status;

  @override
  Widget build(BuildContext context) {
    final (Color color, Color background) = switch (status) {
      ReportStatus.pending => (
        AppColors.pillAmberText,
        AppColors.pillAmberBackground,
      ),
      ReportStatus.underReview => (
        AppColors.pillSlateText,
        AppColors.pillSlateBackground,
      ),
      ReportStatus.resolved => (
        AppColors.statusGreen,
        AppColors.pillGreenBackground,
      ),
      ReportStatus.dismissed => (AppColors.textSecondary, AppColors.iconCircle),
    };
    return AppStatusPill(
      label: status.label,
      color: color,
      backgroundColor: background,
    );
  }
}
