import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/analytics_mock_data.dart';
import 'analytics_state.dart';

class AnalyticsCubit extends Cubit<AnalyticsState> {
  AnalyticsCubit() : super(const AnalyticsState());

  static const Duration _mockLatency = Duration(milliseconds: 700);

  Future<void> load() async {
    emit(state.copyWith(isLoading: true));
    await Future<void>.delayed(_mockLatency);
    if (isClosed) return;
    emit(
      state.copyWith(
        isLoading: false,
        snapshot: AnalyticsMockData.snapshot(),
        updatedAt: DateTime.now(),
      ),
    );
  }

  void selectPeriod(AnalyticsPeriod period) {
    if (period == state.period) return;
    emit(state.copyWith(range: AnalyticsRange.forPeriod(period).first));
  }

  void selectRange(AnalyticsRange range) => emit(state.copyWith(range: range));

  void setCompare(bool value) =>
      emit(state.copyWith(compareWithPreviousYear: value));
}
