import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_bar_chart.dart';
import '../../../../core/widgets/app_card.dart';

class AnalyticsTrendCard extends StatelessWidget {
  const AnalyticsTrendCard({
    super.key,
    required this.title,
    required this.note,
    required this.value,
    required this.entries,
    this.change,
    this.isPositive = true,
  });

  final String title;
  final String note;
  final String value;
  final String? change;
  final bool isPositive;
  final List<AppBarChartEntry> entries;

  @override
  Widget build(BuildContext context) {
    final String? changeText = change;
    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.cardTitle),
                    const SizedBox(height: 2),
                    Text(note, style: AppTextStyles.meta),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(value, style: AppTextStyles.statValueMedium),
                  if (changeText != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      changeText,
                      style: isPositive
                          ? AppTextStyles.metaPositive
                          : AppTextStyles.metaNegative,
                    ),
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          AppBarChart(entries: entries),
        ],
      ),
    );
  }
}
