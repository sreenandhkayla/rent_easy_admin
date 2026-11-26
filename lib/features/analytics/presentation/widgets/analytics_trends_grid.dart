import 'package:flutter/material.dart';

import '../../../../core/resources/strings/analytics_strings.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/widgets/app_bar_chart.dart';
import '../../../../core/widgets/app_responsive_grid.dart';
import '../../data/models/analytics_snapshot.dart';
import '../state/analytics_state.dart';
import 'analytics_trend_card.dart';

class AnalyticsTrendsGrid extends StatelessWidget {
  const AnalyticsTrendsGrid({super.key, required this.state});

  final AnalyticsState state;

  String _period(DateTime date) => state.period == AnalyticsPeriod.monthly
      ? AppFormatters.monthShort(date)
      : '${date.year}';

  String _fullPeriod(DateTime date) => state.period == AnalyticsPeriod.monthly
      ? '${AppFormatters.monthShort(date)} ${date.year}'
      : '${date.year}';

  String _value(AnalyticsMetric metric, int value) =>
      metric == AnalyticsMetric.verifiedRevenue
      ? AppFormatters.rupeesLakh(value, decimals: 2)
      : AppFormatters.number(value);

  Widget _card(AnalyticsMetric metric, String title, String note) {
    final List<AnalyticsPoint> points = state.pointsFor(metric);
    final AnalyticsChange? change = state.changeFor(metric);
    return AnalyticsTrendCard(
      title: title,
      note: note,
      value: points.isEmpty ? '—' : _value(metric, points.last.value),
      change: change == null
          ? null
          : AnalyticsStrings.change(change.fraction, change.comparison),
      isPositive: (change?.fraction ?? 0) >= 0,
      entries: [
        for (final AnalyticsPoint point in points)
          AppBarChartEntry(
            label: _period(point.period),
            value: point.value.toDouble(),
            tooltip: AnalyticsStrings.barTooltip(
              _fullPeriod(point.period),
              _value(metric, point.value),
            ),
            compareValue: state.isComparing
                ? point.previousYear?.toDouble()
                : null,
            compareTooltip: point.previousYear == null
                ? null
                : AnalyticsStrings.compareTooltip(
                    _period(point.period),
                    _value(metric, point.previousYear!),
                  ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppResponsiveGrid(
      minItemWidth: 360,
      maxColumns: 2,
      children: [
        _card(
          AnalyticsMetric.shopRegistrations,
          AnalyticsStrings.shopRegistrations,
          AnalyticsStrings.shopRegistrationsNote,
        ),
        _card(
          AnalyticsMetric.ownerRegistrations,
          AnalyticsStrings.ownerRegistrations,
          AnalyticsStrings.ownerRegistrationsNote,
        ),
        _card(
          AnalyticsMetric.activeSubscriptions,
          AnalyticsStrings.activeSubscriptionGrowth,
          AnalyticsStrings.activeSubscriptionNote,
        ),
        _card(
          AnalyticsMetric.verifiedRevenue,
          AnalyticsStrings.verifiedRevenue,
          AnalyticsStrings.verifiedRevenueNote,
        ),
      ],
    );
  }
}
