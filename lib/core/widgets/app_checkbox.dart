import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppCheckbox extends StatelessWidget {
  const AppCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.semanticLabel,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final ValueChanged<bool>? handler = onChanged;
    return SizedBox.square(
      dimension: 20,
      child: Checkbox(
        value: value,
        onChanged: handler == null
            ? null
            : (checked) => handler(checked ?? false),
        semanticLabel: semanticLabel,
        activeColor: AppColors.ink,
        checkColor: AppColors.onInk,
        side: const BorderSide(color: AppColors.checkboxBorder),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
