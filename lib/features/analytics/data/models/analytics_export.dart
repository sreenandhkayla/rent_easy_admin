import '../../../../core/resources/strings/analytics_strings.dart';

enum AnalyticsExportReport {
  shopAnalytics(AnalyticsStrings.reportShopAnalytics),
  ownerAnalytics(AnalyticsStrings.reportOwnerAnalytics),
  subscriptionAnalytics(AnalyticsStrings.reportSubscriptionAnalytics),
  revenueSummary(AnalyticsStrings.reportRevenueSummary);

  const AnalyticsExportReport(this.label);

  final String label;
}

enum AnalyticsExportFormat {
  csv(AnalyticsStrings.formatCsv),
  xlsx(AnalyticsStrings.formatXlsx),
  pdf(AnalyticsStrings.formatPdf);

  const AnalyticsExportFormat(this.label);

  final String label;
}

class AnalyticsExportRequest {
  const AnalyticsExportRequest({required this.report, required this.format});

  final AnalyticsExportReport report;
  final AnalyticsExportFormat format;
}
