import 'package:flutter/material.dart';

import '../theme/app_text_styles.dart';
import 'app_card.dart';
import 'app_status_dot.dart';

class AppStatCard extends StatelessWidget {
  const AppStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.caption,
    this.dotColor,
  });

  final String label;
  final String value;
  final String caption;
  final Color? dotColor;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (dotColor != null) ...[
                AppStatusDot(color: dotColor!),
                const SizedBox(width: 8),
              ],
              Expanded(child: Text(label, style: AppTextStyles.labelRegular)),
            ],
          ),
          const SizedBox(height: 10),
          Text(value, style: AppTextStyles.statValueMedium),
          const Spacer(),
          const SizedBox(height: 8),
          Text(caption, style: AppTextStyles.meta),
        ],
      ),
    );
  }
}
