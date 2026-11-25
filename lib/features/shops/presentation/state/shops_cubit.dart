import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/registration_date_filter.dart';
import '../../data/shops_mock_data.dart';
import 'shops_state.dart';

class ShopsCubit extends Cubit<ShopsState> {
  ShopsCubit({String initialQuery = ''})
    : super(ShopsState(query: initialQuery));

  static const Duration _mockLatency = Duration(milliseconds: 700);

  Future<void> load() async {
    emit(state.copyWith(isLoading: true));
    await Future<void>.delayed(_mockLatency);
    if (isClosed) return;
    emit(
      state.copyWith(
        isLoading: false,
        shops: ShopsMockData.shops(),
        totalOnPlatform: ShopsMockData.totalOnPlatform,
        updatedAt: DateTime.now(),
      ),
    );
  }

  void syncShops() => emit(state.copyWith(shops: ShopsMockData.shops()));

  void search(String query) => emit(state.copyWith(query: query, page: 1));

  void filterBySubscription(SubscriptionFilter filter) =>
      emit(state.copyWith(subscriptionFilter: filter, page: 1));

  void filterByPlan(PlanFilter filter) =>
      emit(state.copyWith(planFilter: filter, page: 1));

  void filterByStatus(ShopStatusFilter filter) =>
      emit(state.copyWith(statusFilter: filter, page: 1));

  void filterByRegistrationDate(RegistrationDateFilter filter) =>
      emit(state.copyWith(dateFilter: filter, page: 1));

  void sortBy(ShopSortField field) {
    emit(
      state.copyWith(
        sortField: field,
        isAscending: field == state.sortField ? !state.isAscending : true,
        page: 1,
      ),
    );
  }

  void goToPage(int page) {
    if (page < 1 || page > state.pageCount) return;
    emit(state.copyWith(page: page));
  }
}
