import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppTimelineEntry {
  const AppTimelineEntry({
    required this.title,
    required this.subtitle,
    this.detail,
    this.isHighlighted = false,
    this.dotColor,
  });

  final String title;
  final String subtitle;
  final String? detail;
  final bool isHighlighted;
  final Color? dotColor;

  Color? get fillColor => dotColor ?? (isHighlighted ? AppColors.ink : null);
}

class AppActivityTimeline extends StatelessWidget {
  const AppActivityTimeline({super.key, required this.entries});

  final List<AppTimelineEntry> entries;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < entries.length; i++)
          _TimelineRow(entry: entries[i], isLast: i == entries.length - 1),
      ],
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.entry, required this.isLast});

  final AppTimelineEntry entry;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final String? detail = entry.detail;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 10,
            child: Column(
              children: [
                const SizedBox(height: 4),
                Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: entry.fillColor,
                    border: Border.all(
                      color: entry.fillColor ?? AppColors.statusGrey,
                      width: 1.5,
                    ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: AppColors.divider,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(entry.title, style: AppTextStyles.titleSmall),
                  const SizedBox(height: 2),
                  Text(entry.subtitle, style: AppTextStyles.meta),
                  if (detail != null) ...[
                    const SizedBox(height: 2),
                    Text(detail, style: AppTextStyles.meta),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
