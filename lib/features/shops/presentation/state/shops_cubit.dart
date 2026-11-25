import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/registration_date_filter.dart';
import '../../../../core/enums/subscription_plan.dart';
import '../../../../core/enums/subscription_status.dart';
import '../../data/models/shop.dart';
import '../../data/shops_mock_data.dart';
import 'shops_state.dart';

class ShopsCubit extends Cubit<ShopsState> {
  ShopsCubit({
    String initialQuery = '',
    Future<List<Shop>> Function()? fetchShops,
  }) : _fetchShops = fetchShops ?? _fetchMockShops,
       super(ShopsState(query: initialQuery));

  static const Duration _mockLatency = Duration(milliseconds: 700);

  final Future<List<Shop>> Function() _fetchShops;

  static Future<List<Shop>> _fetchMockShops() async {
    await Future<void>.delayed(_mockLatency);
    return ShopsMockData.shops();
  }

  Future<void> load() async {
    emit(state.copyWith(isLoading: true, hasError: false));
    try {
      final List<Shop> shops = await _fetchShops();
      if (isClosed) return;
      emit(
        state.copyWith(
          isLoading: false,
          shops: shops,
          totalOnPlatform: ShopsMockData.totalOnPlatform,
          updatedAt: DateTime.now(),
        ),
      );
    } catch (_) {
      if (isClosed) return;
      emit(state.copyWith(isLoading: false, hasError: true));
    }
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
