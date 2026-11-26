import '../../data/models/shop_report.dart';

enum ReportDetailsStatus { loading, loaded, notFound }

class ReportDetailsState {
  const ReportDetailsState({
    this.status = ReportDetailsStatus.loading,
    this.report,
    this.updatedAt,
    this.notifyShop = true,
  });

  final ReportDetailsStatus status;
  final ShopReport? report;
  final DateTime? updatedAt;
  final bool notifyShop;

  ReportDetailsState copyWith({
    ReportDetailsStatus? status,
    ShopReport? report,
    DateTime? updatedAt,
    bool? notifyShop,
  }) {
    return ReportDetailsState(
      status: status ?? this.status,
      report: report ?? this.report,
      updatedAt: updatedAt ?? this.updatedAt,
      notifyShop: notifyShop ?? this.notifyShop,
    );
  }
}
