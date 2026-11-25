import '../../data/models/dashboard_summary.dart';

enum DashboardStatus { loading, loaded }

class DashboardState {
  const DashboardState({this.status = DashboardStatus.loading, this.summary});

  final DashboardStatus status;
  final DashboardSummary? summary;
}
