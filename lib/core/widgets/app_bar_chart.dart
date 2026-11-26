import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppBarChartEntry {
  const AppBarChartEntry({
    required this.label,
    required this.value,
    required this.tooltip,
    this.compareValue,
    this.compareTooltip,
  });

  final String label;
  final double value;
  final String tooltip;
  final double? compareValue;
  final String? compareTooltip;
}

class AppBarChart extends StatelessWidget {
  const AppBarChart({
    super.key,
    required this.entries,
    this.plotHeight = 120,
    this.barWidth = 14,
  });

  final List<AppBarChartEntry> entries;
  final double plotHeight;
  final double barWidth;

  @override
  Widget build(BuildContext context) {
    final double peak = entries.fold(
      0,
      (top, entry) =>
          math.max(top, math.max(entry.value, entry.compareValue ?? 0)),
    );
    double heightOf(double value) =>
        peak <= 0 ? 0 : math.max(barWidth, plotHeight * value / peak);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (final AppBarChartEntry entry in entries)
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: plotHeight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (entry.compareValue case final double compare) ...[
                        _Bar(
                          height: heightOf(compare),
                          width: barWidth,
                          color: AppColors.statusGrey,
                          tooltip: entry.compareTooltip ?? entry.tooltip,
                        ),
                        const SizedBox(width: 4),
                      ],
                      _Bar(
                        height: heightOf(entry.value),
                        width: barWidth,
                        color: AppColors.ink,
                        tooltip: entry.tooltip,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(entry.label, style: AppTextStyles.meta),
              ],
            ),
          ),
      ],
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({
    required this.height,
    required this.width,
    required this.color,
    required this.tooltip,
  });

  final double height;
  final double width;
  final Color color;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(width / 2),
        ),
      ),
    );
  }
}
