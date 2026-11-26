import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppProgressRow extends StatelessWidget {
  const AppProgressRow({
    super.key,
    required this.label,
    required this.trailing,
    required this.fraction,
    this.labelStyle = AppTextStyles.labelRegular,
    this.trailingStyle = AppTextStyles.meta,
    this.barHeight = 6,
  });

  final String label;
  final String trailing;
  final double fraction;
  final TextStyle labelStyle;
  final TextStyle trailingStyle;
  final double barHeight;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$label, $trailing',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: Text(label, style: labelStyle)),
              const SizedBox(width: 12),
              Text(trailing, style: trailingStyle),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(barHeight),
            child: LinearProgressIndicator(
              value: fraction.clamp(0, 1).toDouble(),
              minHeight: barHeight,
              color: AppColors.ink,
              backgroundColor: AppColors.iconCircle,
            ),
          ),
        ],
      ),
    );
  }
}
