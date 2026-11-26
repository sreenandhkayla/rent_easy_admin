import 'package:flutter/material.dart';

import '../../../../core/resources/strings/analytics_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_checkbox_row.dart';
import '../../../../core/widgets/app_dropdown.dart';
import '../../../../core/widgets/app_secondary_button.dart';
import '../../../../core/widgets/app_segmented_tabs.dart';
import '../state/analytics_state.dart';

class AnalyticsToolbar extends StatelessWidget {
  const AnalyticsToolbar({
    super.key,
    required this.state,
    required this.onPeriodChanged,
    required this.onRangeChanged,
    required this.onCompareChanged,
    required this.onExport,
  });

  final AnalyticsState state;
  final ValueChanged<AnalyticsPeriod> onPeriodChanged;
  final ValueChanged<AnalyticsRange> onRangeChanged;
  final ValueChanged<bool> onCompareChanged;
  final VoidCallback onExport;

  static const double _rangeMinWidth = 108;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 12,
      runSpacing: 12,
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            AppSegmentedTabs(
              labels: [for (final p in AnalyticsPeriod.values) p.label],
              selectedIndex: state.period.index,
              onSelected: (index) =>
                  onPeriodChanged(AnalyticsPeriod.values[index]),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: _rangeMinWidth),
              child: AppDropdown<AnalyticsRange>(
                value: state.range,
                items: AnalyticsRange.forPeriod(state.period),
                labelOf: (range) => range.label,
                onChanged: onRangeChanged,
              ),
            ),
            const SizedBox(width: 2),
            AppCheckboxRow(
              label: AnalyticsStrings.compareWithPreviousYear,
              value: state.isComparing,
              onChanged: state.canCompare ? onCompareChanged : null,
            ),
          ],
        ),
        AppSecondaryButton(
          label: AnalyticsStrings.exportReport,
          icon: Icons.file_download_outlined,
          iconColor: AppColors.textPrimary,
          onPressed: onExport,
        ),
      ],
    );
  }
}
