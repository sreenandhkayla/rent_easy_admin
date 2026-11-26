import 'package:flutter/material.dart';

import '../theme/app_text_styles.dart';

class AppLabeledField extends StatelessWidget {
  const AppLabeledField({super.key, required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: AppTextStyles.label),
        const SizedBox(height: 10),
        child,
      ],
    );
  }
}
