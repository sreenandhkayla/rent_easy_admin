import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_status_pill.dart';
import '../../data/models/admin_notification.dart';

class NotificationStatusPill extends StatelessWidget {
  const NotificationStatusPill({super.key, required this.status});

  final NotificationStatus status;

  @override
  Widget build(BuildContext context) {
    final (Color color, Color background) = switch (status) {
      NotificationStatus.sent => (
        AppColors.statusGreen,
        AppColors.pillGreenBackground,
      ),
      NotificationStatus.queued || NotificationStatus.sending => (
        AppColors.pillAmberText,
        AppColors.pillAmberBackground,
      ),
      NotificationStatus.failed => (
        AppColors.pillRedText,
        AppColors.pillRedBackground,
      ),
      NotificationStatus.draft => (
        AppColors.textSecondary,
        AppColors.iconCircle,
      ),
    };
    return AppStatusPill(
      label: status.label,
      color: color,
      backgroundColor: background,
    );
  }
}
