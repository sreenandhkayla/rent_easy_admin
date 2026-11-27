import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/dashboard_mock_data.dart';
import '../../data/models/dashboard_summary.dart';
import '../../data/repositories/dashboard_repository.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(this._repository) : super(const DashboardState());

  final DashboardRepository _repository;

  Future<void> load({bool refresh = false}) async {
    if (state.isLoadingCounts) return;
    final DashboardSummary summary =
        state.summary ?? DashboardMockData.summary(DateTime.now());
    emit(
      DashboardState(
        status: DashboardStatus.loaded,
        summary: summary,
        isLoadingCounts: true,
      ),
    );
    final result = await _repository.fetchCounts(refresh: refresh);
    if (isClosed) return;
    result.match(
      (failure) => emit(
        state.copyWith(
          isLoadingCounts: false,
          countsError: () => failure.message,
        ),
      ),
      (counts) => emit(
        state.copyWith(
          isLoadingCounts: false,
          countsError: () => null,
          summary: summary.withCounts(
            totalShops: counts.totalShops,
            totalShopOwners: counts.totalShopOwners,
            updatedAt: counts.fetchedAt,
          ),
        ),
      ),
    );
  }
}
