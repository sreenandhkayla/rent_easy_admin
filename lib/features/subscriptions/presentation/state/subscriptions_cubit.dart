import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/subscription_plan.dart';
import '../../../../core/enums/subscription_status.dart';
import '../../data/subscriptions_mock_data.dart';
import 'subscriptions_state.dart';

class SubscriptionsCubit extends Cubit<SubscriptionsState> {
  SubscriptionsCubit({SubscriptionsTab initialTab = SubscriptionsTab.overview})
    : super(SubscriptionsState(tab: initialTab));

  void load() => emit(
    state.copyWith(
      overview: SubscriptionsMockData.overview(DateTime.now()),
      shopSubscriptions: SubscriptionsMockData.shopSubscriptions(),
    ),
  );

  void syncShopSubscriptions() => emit(
    state.copyWith(
      shopSubscriptions: SubscriptionsMockData.shopSubscriptions(),
    ),
  );

  void selectTab(SubscriptionsTab tab) => emit(state.copyWith(tab: tab));

  void filterByStatus(SubscriptionFilter filter) =>
      emit(state.copyWith(statusFilter: filter));

  void filterByPlan(PlanFilter filter) =>
      emit(state.copyWith(planFilter: filter));

  void filterByExpiry(ExpiryFilter filter) =>
      emit(state.copyWith(expiryFilter: filter));

  void search(String query) => emit(state.copyWith(query: query));
}
