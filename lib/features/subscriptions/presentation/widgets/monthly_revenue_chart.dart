import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/resources/strings/subscriptions_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../data/models/subscription_overview.dart';

class MonthlyRevenueChart extends StatelessWidget {
  const MonthlyRevenueChart({super.key, required this.months});

  static const double _plotHeight = 96;
  static const double _barWidth = 14;

  final List<MonthlyRevenue> months;

  @override
  Widget build(BuildContext context) {
    final int peak = months.fold(0, (top, m) => math.max(top, m.amount));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                SubscriptionsStrings.monthlyRevenue,
                style: AppTextStyles.labelRegular,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              SubscriptionsStrings.monthlyRevenueNote,
              style: AppTextStyles.meta,
            ),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (final MonthlyRevenue month in months)
              Expanded(
                child: Tooltip(
                  message: SubscriptionsStrings.barTooltip(
                    month.month,
                    AppFormatters.rupees(month.amount),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppFormatters.rupeesLakh(month.amount),
                        style: AppTextStyles.meta,
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: _barWidth,
                        height: peak == 0
                            ? 0
                            : _plotHeight * month.amount / peak,
                        decoration: BoxDecoration(
                          color: AppColors.ink,
                          borderRadius: BorderRadius.circular(_barWidth / 2),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppFormatters.monthShort(month.month),
                        style: AppTextStyles.meta,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
