import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/dashboard_mock_data.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(const DashboardState());

  void load() {
    emit(
      DashboardState(
        status: DashboardStatus.loaded,
        summary: DashboardMockData.summary(DateTime.now()),
      ),
    );
  }
}
