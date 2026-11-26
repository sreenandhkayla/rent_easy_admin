import '../../utils/app_formatters.dart';

class AnalyticsStrings {
  AnalyticsStrings._();

  static const String title = 'Analytics & Reports';
  static const String subtitle = 'Aggregate platform performance';

  static const String monthly = 'Monthly';
  static const String yearly = 'Yearly';
  static const String last6Months = 'Last 6 months';
  static const String last12Months = 'Last 12 months';
  static const String last3Years = 'Last 3 years';
  static const String last5Years = 'Last 5 years';
  static const String compareWithPreviousYear = 'Compare with previous year';
  static const String exportReport = 'Export aggregate report';

  static const String exportMessage =
      'Choose the report and format. Exports contain aggregate figures only.';
  static const String exportNotice =
      'Customer, item and rental records are never included. Prototype: no '
      'file is generated.';
  static const String exportReportLabel = 'Report';
  static const String exportFormatLabel = 'Format';
  static const String prepareExport = 'Prepare export';
  static const String reportShopAnalytics = 'Shop analytics';
  static const String reportOwnerAnalytics = 'Owner analytics';
  static const String reportSubscriptionAnalytics = 'Subscription analytics';
  static const String reportRevenueSummary = 'Revenue summary';
  static const String formatCsv = 'CSV';
  static const String formatXlsx = 'XLSX';
  static const String formatPdf = 'PDF';

  static String exportPrepared(String report, String format) =>
      '$report ($format) export prepared. No file is generated in the '
      'prototype.';

  static const String totalItems = 'Total Items';
  static const String totalItemsCaption = 'Aggregate only · no item list';
  static const String totalRentals = 'Total Rentals';
  static const String totalRentalsCaption =
      'Aggregate only · no transaction list';
  static const String totalCustomers = 'Total Customers';
  static const String totalCustomersCaption =
      'Aggregate only · no customer list';

  static const String shopRegistrations = 'Shop registrations';
  static const String shopRegistrationsNote = 'New shops incl. branches';
  static const String ownerRegistrations = 'Owner registrations';
  static const String ownerRegistrationsNote = 'New owner accounts';
  static const String activeSubscriptionGrowth = 'Active subscription growth';
  static const String activeSubscriptionNote = 'Shops with active entitlement';
  static const String verifiedRevenue = 'Verified subscription revenue';
  static const String verifiedRevenueNote = '₹ lakh · verified payments only';

  static const String planDistribution = 'Plan distribution';
  static const String shopStatus = 'Shop status';
  static const String shopActive = 'Active (rental in last 30 days)';
  static const String shopInactive = 'Inactive';
  static const String shopRestricted = 'Restricted by admin';
  static const String shopStatusNote =
      'Active = at least one rental recorded in the last 30 days.';
  static const String renewals = 'Renewals';
  static const String expiries = 'Expiries';
  static const String expiringSoon = 'Expiring soon';
  static const String paymentSuccessRate = 'Payment success rate';
  static const String failedPayments = 'Failed payments';
  static const String multiShopOwners = 'Owners with multiple shops';

  static const String footnote =
      'All analytics are aggregate prototype sample data. Exports never '
      'include customer, item or rental records.';

  static String subscriptionsAndOwners(DateTime month) =>
      'Subscriptions & owners · ${AppFormatters.monthShort(month)}';

  static String countAndShare(String count, String share) => '$count · $share';

  static String change(double fraction, String comparison) =>
      '${fraction >= 0 ? '+' : ''}${(fraction * 100).toStringAsFixed(1)}% '
      'vs $comparison';

  static const String previousMonth = 'previous month';
  static const String previousYear = 'previous year';

  static String sameMonthLastYear(DateTime month) =>
      '${AppFormatters.monthShort(month)} ${month.year - 1}';

  static String barTooltip(String period, String value) => '$period · $value';

  static String compareTooltip(String period, String value) =>
      'Previous year · $period · $value';
}
