import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class PlanBenefitRow extends StatelessWidget {
  const PlanBenefitRow({
    super.key,
    required this.label,
    this.style = AppTextStyles.tableCell,
  });

  final String label;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 2),
          child: Icon(Icons.check, size: 14, color: AppColors.textPrimary),
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(label, style: style)),
      ],
    );
  }
}
