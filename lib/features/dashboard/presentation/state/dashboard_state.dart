import '../../data/models/dashboard_summary.dart';

enum DashboardStatus { loading, loaded }

class DashboardState {
  const DashboardState({
    this.status = DashboardStatus.loading,
    this.summary,
    this.isLoadingCounts = false,
    this.countsError,
  });

  final DashboardStatus status;
  final DashboardSummary? summary;
  final bool isLoadingCounts;
  final String? countsError;

  DashboardState copyWith({
    DashboardSummary? summary,
    bool? isLoadingCounts,
    String? Function()? countsError,
  }) {
    return DashboardState(
      status: status,
      summary: summary ?? this.summary,
      isLoadingCounts: isLoadingCounts ?? this.isLoadingCounts,
      countsError: countsError == null ? this.countsError : countsError(),
    );
  }
}
