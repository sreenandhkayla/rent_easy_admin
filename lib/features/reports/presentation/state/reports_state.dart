import '../../../../core/resources/strings/reports_strings.dart';
import '../../data/models/shop_report.dart';

enum ReportStatusFilter {
  all(ReportsStrings.statusAll, null),
  pending(ReportsStrings.statusPending, ReportStatus.pending),
  underReview(ReportsStrings.statusUnderReview, ReportStatus.underReview),
  resolved(ReportsStrings.statusResolved, ReportStatus.resolved),
  dismissed(ReportsStrings.statusDismissed, ReportStatus.dismissed);

  const ReportStatusFilter(this.label, this.status);

  final String label;
  final ReportStatus? status;

  bool matches(ReportStatus value) => status == null || status == value;
}

enum ReportDateFilter {
  any(ReportsStrings.dateAny, null),
  last7Days(ReportsStrings.dateLast7Days, 7),
  last30Days(ReportsStrings.dateLast30Days, 30),
  last90Days(ReportsStrings.dateLast90Days, 90);

  const ReportDateFilter(this.label, this.days);

  final String label;
  final int? days;

  bool matches(DateTime submittedAt, DateTime now) {
    final int? range = days;
    if (range == null) return true;
    final DateTime today = DateTime(now.year, now.month, now.day);
    return !submittedAt.isBefore(today.subtract(Duration(days: range - 1)));
  }
}

class ReportsState {
  const ReportsState({
    this.isLoading = false,
    this.reports = const [],
    this.statusFilter = ReportStatusFilter.all,
    this.category,
    this.dateFilter = ReportDateFilter.any,
    this.query = '',
    this.updatedAt,
  });

  final bool isLoading;
  final List<ShopReport> reports;
  final ReportStatusFilter statusFilter;
  final ReportCategory? category;
  final ReportDateFilter dateFilter;
  final String query;
  final DateTime? updatedAt;

  int countFor(ReportStatusFilter filter) =>
      reports.where((item) => filter.matches(item.status)).length;

  List<ShopReport> get visibleReports {
    final String search = query.trim().toLowerCase();
    final DateTime now = updatedAt ?? DateTime.now();
    return reports
        .where(
          (item) =>
              statusFilter.matches(item.status) &&
              (category == null || item.category == category) &&
              dateFilter.matches(item.submittedAt, now) &&
              (search.isEmpty ||
                  item.reportId.toLowerCase().contains(search) ||
                  item.shopName.toLowerCase().contains(search) ||
                  item.shopId.toLowerCase().contains(search)),
        )
        .toList()
      ..sort((a, b) => b.submittedAt.compareTo(a.submittedAt));
  }

  ReportsState copyWith({
    bool? isLoading,
    List<ShopReport>? reports,
    ReportStatusFilter? statusFilter,
    ReportCategory? Function()? category,
    ReportDateFilter? dateFilter,
    String? query,
    DateTime? updatedAt,
  }) {
    return ReportsState(
      isLoading: isLoading ?? this.isLoading,
      reports: reports ?? this.reports,
      statusFilter: statusFilter ?? this.statusFilter,
      category: category == null ? this.category : category(),
      dateFilter: dateFilter ?? this.dateFilter,
      query: query ?? this.query,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
