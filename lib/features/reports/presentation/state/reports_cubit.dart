import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/shop_report.dart';
import '../../data/reports_mock_data.dart';
import 'reports_state.dart';

class ReportsCubit extends Cubit<ReportsState> {
  ReportsCubit({ReportStatusFilter initialFilter = ReportStatusFilter.all})
    : super(ReportsState(statusFilter: initialFilter));

  static const Duration _mockLatency = Duration(milliseconds: 700);

  Future<void> load() async {
    emit(state.copyWith(isLoading: true));
    await Future<void>.delayed(_mockLatency);
    if (isClosed) return;
    emit(
      state.copyWith(
        isLoading: false,
        reports: ReportsMockData.reports(),
        updatedAt: DateTime.now(),
      ),
    );
  }

  void syncReports() =>
      emit(state.copyWith(reports: ReportsMockData.reports()));

  void filterByStatus(ReportStatusFilter filter) =>
      emit(state.copyWith(statusFilter: filter));

  void filterByCategory(ReportCategory? category) =>
      emit(state.copyWith(category: () => category));

  void filterByDate(ReportDateFilter filter) =>
      emit(state.copyWith(dateFilter: filter));

  void search(String query) => emit(state.copyWith(query: query));
}
