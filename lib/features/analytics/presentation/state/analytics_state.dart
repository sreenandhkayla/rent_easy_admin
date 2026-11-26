import '../../../../core/resources/strings/analytics_strings.dart';
import '../../data/models/analytics_snapshot.dart';

enum AnalyticsPeriod {
  monthly(AnalyticsStrings.monthly),
  yearly(AnalyticsStrings.yearly);

  const AnalyticsPeriod(this.label);

  final String label;
}

enum AnalyticsRange {
  last6Months(AnalyticsStrings.last6Months, AnalyticsPeriod.monthly, 6),
  last12Months(AnalyticsStrings.last12Months, AnalyticsPeriod.monthly, 12),
  last3Years(AnalyticsStrings.last3Years, AnalyticsPeriod.yearly, 3),
  last5Years(AnalyticsStrings.last5Years, AnalyticsPeriod.yearly, 5);

  const AnalyticsRange(this.label, this.period, this.count);

  final String label;
  final AnalyticsPeriod period;
  final int count;

  static List<AnalyticsRange> forPeriod(AnalyticsPeriod period) =>
      values.where((range) => range.period == period).toList();
}

class AnalyticsChange {
  const AnalyticsChange({required this.fraction, required this.comparison});

  final double fraction;
  final String comparison;
}

class AnalyticsState {
  const AnalyticsState({
    this.isLoading = false,
    this.snapshot,
    this.range = AnalyticsRange.last6Months,
    this.compareWithPreviousYear = false,
    this.updatedAt,
  });

  final bool isLoading;
  final AnalyticsSnapshot? snapshot;
  final AnalyticsRange range;
  final bool compareWithPreviousYear;
  final DateTime? updatedAt;

  AnalyticsPeriod get period => range.period;

  bool get canCompare => period == AnalyticsPeriod.monthly;

  bool get isComparing => canCompare && compareWithPreviousYear;

  List<AnalyticsPoint> pointsFor(AnalyticsMetric metric) {
    final AnalyticsSnapshot? data = snapshot;
    if (data == null) return const [];
    final List<AnalyticsPoint> all =
        (period == AnalyticsPeriod.monthly
            ? data.monthly
            : data.yearly)[metric] ??
        const [];
    return all.length <= range.count
        ? all
        : all.sublist(all.length - range.count);
  }

  AnalyticsChange? changeFor(AnalyticsMetric metric) {
    final List<AnalyticsPoint> points = pointsFor(metric);
    if (points.isEmpty) return null;
    final AnalyticsPoint latest = points.last;
    if (isComparing) {
      final int? previous = latest.previousYear;
      if (previous == null || previous == 0) return null;
      return AnalyticsChange(
        fraction: latest.value / previous - 1,
        comparison: AnalyticsStrings.sameMonthLastYear(latest.period),
      );
    }
    if (points.length < 2 || points[points.length - 2].value == 0) return null;
    return AnalyticsChange(
      fraction: latest.value / points[points.length - 2].value - 1,
      comparison: period == AnalyticsPeriod.monthly
          ? AnalyticsStrings.previousMonth
          : AnalyticsStrings.previousYear,
    );
  }

  AnalyticsState copyWith({
    bool? isLoading,
    AnalyticsSnapshot? snapshot,
    AnalyticsRange? range,
    bool? compareWithPreviousYear,
    DateTime? updatedAt,
  }) {
    return AnalyticsState(
      isLoading: isLoading ?? this.isLoading,
      snapshot: snapshot ?? this.snapshot,
      range: range ?? this.range,
      compareWithPreviousYear:
          compareWithPreviousYear ?? this.compareWithPreviousYear,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
