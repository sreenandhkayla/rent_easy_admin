import 'package:flutter/material.dart';

import '../theme/app_text_styles.dart';

class AppDetailField extends StatelessWidget {
  const AppDetailField({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.bodyCaption),
        const SizedBox(height: 6),
        Text(value, style: AppTextStyles.detailValue),
      ],
    );
  }
}
