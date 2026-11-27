import 'package:flutter/material.dart';

import '../../../../core/resources/strings/dashboard_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_icon_circle.dart';
import '../../../../core/widgets/app_status_dot.dart';

class DashboardMetricCard extends StatelessWidget {
  const DashboardMetricCard({
    super.key,
    required this.label,
    required this.value,
    required this.caption,
    this.icon,
    this.svgIcon,
    this.dotColor,
    this.onTap,
  });

  final String label;
  final int? value;
  final String caption;
  final IconData? icon;
  final String? svgIcon;
  final Color? dotColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (dotColor != null) ...[
                AppStatusDot(color: dotColor!),
                const SizedBox(width: 8),
              ],
              Expanded(child: Text(label, style: AppTextStyles.titleSmall)),
              const SizedBox(width: 8),
              AppIconCircle(icon: icon, svgIcon: svgIcon),
            ],
          ),
          const SizedBox(height: 14),
          Text(switch (value) {
            final int count => AppFormatters.number(count),
            null => DashboardStrings.emptyValue,
          }, style: AppTextStyles.statValueLarge),
          const Spacer(),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: Text(caption, style: AppTextStyles.bodyCaption)),
              if (onTap != null)
                const Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: AppColors.textPrimary,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
