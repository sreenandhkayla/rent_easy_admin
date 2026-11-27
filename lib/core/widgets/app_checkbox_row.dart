import 'package:flutter/material.dart';

import '../theme/app_text_styles.dart';
import 'app_checkbox.dart';

class AppCheckboxRow extends StatelessWidget {
  const AppCheckboxRow({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final ValueChanged<bool>? handler = onChanged;
    return InkWell(
      onTap: handler == null ? null : () => handler(!value),
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppCheckbox(value: value, onChanged: onChanged),
            const SizedBox(width: 10),
            Flexible(child: Text(label, style: AppTextStyles.tableCell)),
          ],
        ),
      ),
    );
  }
}
