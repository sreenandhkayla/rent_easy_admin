import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/subscription_plan.dart';
import '../../../../core/enums/subscription_status.dart';
import '../../data/repositories/plans_repository.dart';
import '../../data/subscriptions_mock_data.dart';
import 'subscriptions_state.dart';

class SubscriptionsCubit extends Cubit<SubscriptionsState> {
  SubscriptionsCubit(
    this._plansRepository, {
    SubscriptionsTab initialTab = SubscriptionsTab.overview,
  }) : super(SubscriptionsState(tab: initialTab));

  final PlansRepository _plansRepository;

  void load() {
    emit(
      state.copyWith(
        overview: SubscriptionsMockData.overview(DateTime.now()),
        shopSubscriptions: SubscriptionsMockData.shopSubscriptions(),
        payments: SubscriptionsMockData.payments(),
        reconciliationSummary: SubscriptionsMockData.reconciliationSummary(),
      ),
    );
    loadPlans();
  }

  Future<void> loadPlans() async {
    emit(state.copyWith(isPlansLoading: true, plansError: () => null));
    final result = await _plansRepository.fetchPlans();
    if (isClosed) return;
    result.match(
      (failure) => emit(
        state.copyWith(
          isPlansLoading: false,
          plansError: () => failure.message,
        ),
      ),
      (plans) => emit(state.copyWith(isPlansLoading: false, plans: plans)),
    );
  }

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

  void filterPayments(PaymentFilter filter) =>
      emit(state.copyWith(paymentFilter: filter));

  void searchPayments(String query) =>
      emit(state.copyWith(paymentQuery: query));
}
