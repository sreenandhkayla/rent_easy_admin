import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppProgressRow extends StatelessWidget {
  const AppProgressRow({
    super.key,
    required this.label,
    required this.trailing,
    required this.fraction,
  });

  final String label;
  final String trailing;
  final double fraction;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$label, $trailing',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: Text(label, style: AppTextStyles.labelRegular)),
              const SizedBox(width: 12),
              Text(trailing, style: AppTextStyles.meta),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: fraction.clamp(0, 1).toDouble(),
              minHeight: 6,
              color: AppColors.ink,
              backgroundColor: AppColors.iconCircle,
            ),
          ),
        ],
      ),
    );
  }
}
