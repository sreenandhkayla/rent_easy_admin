import 'package:flutter/material.dart';

import '../theme/app_text_styles.dart';
import 'app_status_dot.dart';

class AppStatusPill extends StatelessWidget {
  const AppStatusPill({
    super.key,
    required this.label,
    required this.color,
    required this.backgroundColor,
  });

  final String label;
  final Color color;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppStatusDot(color: color, size: 5),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              label,
              style: AppTextStyles.pill.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
}
