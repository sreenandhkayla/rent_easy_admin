import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/registration_date_filter.dart';
import '../../../../core/enums/subscription_status.dart';
import '../../data/models/shop.dart';
import '../../data/models/shop_list_query.dart';
import '../../data/models/shop_search.dart';
import '../../data/repositories/shops_repository.dart';
import 'shops_state.dart';

class ShopsCubit extends Cubit<ShopsState> {
  ShopsCubit(this._repository, {String initialQuery = ''})
    : super(
        ShopsState(
          query: initialQuery,
          activeSearch: ShopSearch.isActive(initialQuery)
              ? ShopSearch.normalize(initialQuery)
              : '',
        ),
      );

  static const Duration _searchDebounce = Duration(milliseconds: 500);

  final ShopsRepository _repository;
  Timer? _searchTimer;
  int _request = 0;

  Future<void> load() async {
    _repository.clear();
    emit(state.copyWith(updatedAt: DateTime.now()));
    final totals = _repository.count(
      ShopListQuery(today: state.listQuery.today),
    );
    final plans = _repository.fetchPlans();
    await _fetch(page: 1);
    final totalResult = await totals;
    final planResult = await plans;
    if (isClosed) return;
    emit(
      state.copyWith(
        totalOnPlatform: totalResult.getOrElse((_) => state.totalOnPlatform),
        plans: planResult.getOrElse((_) => state.plans),
      ),
    );
  }

  Future<void> retry() => _fetch(page: state.page);

  void search(String query) {
    emit(state.copyWith(query: query));
    _searchTimer?.cancel();
    _searchTimer = Timer(_searchDebounce, () {
      final String term = ShopSearch.normalize(query);
      final String applied = ShopSearch.isActive(term) ? term : '';
      if (applied == state.activeSearch) return;
      emit(state.copyWith(activeSearch: applied, searchMatches: const []));
      _fetch(page: 1);
    });
  }

  void filterBySubscription(SubscriptionFilter filter) {
    if (filter == state.subscriptionFilter) return;
    emit(state.copyWith(subscriptionFilter: filter));
    _fetch(page: 1);
  }

  void filterByPlan(String? planId) {
    if (planId == state.planId) return;
    emit(state.copyWith(planId: () => planId));
    _fetch(page: 1);
  }

  void filterByStatus(ShopStatusFilter filter) {
    if (filter == state.statusFilter) return;
    emit(state.copyWith(statusFilter: filter));
    _fetch(page: 1);
  }

  void filterByRegistrationDate(RegistrationDateFilter filter) {
    if (filter == state.dateFilter) return;
    emit(state.copyWith(dateFilter: filter));
    _fetch(page: 1);
  }

  void sortBy(ShopSortField field) => emit(
    state.copyWith(
      sortField: () => field,
      isAscending: field == state.sortField ? !state.isAscending : true,
    ),
  );

  void goToPage(int page) {
    if (page < 1 || page > state.pageCount || page == state.page) return;
    _fetch(page: page, recount: false);
  }

  void setPageSize(int size) {
    if (size == state.pageSize) return;
    emit(state.copyWith(pageSize: size));
    _fetch(page: 1, recount: false);
  }

  Future<void> _fetch({required int page, bool recount = true}) async {
    final int request = ++_request;
    emit(state.copyWith(isLoading: true, page: page, errorMessage: () => null));
    final ShopListQuery query = state.listQuery;
    final bool lookUpMatches = page == 1 && state.isSearching;

    final pageResult = _repository.fetchPage(query, page);
    final countResult = recount ? _repository.count(query) : null;
    final matchResult = lookUpMatches
        ? _repository.findSearchMatches(state.activeSearch, query.today)
        : null;
    final rows = await pageResult;
    final total = await countResult;
    final matches = await matchResult;
    if (isClosed || request != _request) return;

    final String? failure =
        rows.fold((failure) => failure.message, (_) => null) ??
        total?.fold((failure) => failure.message, (_) => null) ??
        matches?.fold((failure) => failure.message, (_) => null);
    if (failure != null) {
      emit(state.copyWith(isLoading: false, errorMessage: () => failure));
      return;
    }

    final List<Shop>? filteredMatches = matches
        ?.getOrElse((_) => const [])
        .where(query.matches)
        .toList();
    emit(
      state.copyWith(
        isLoading: false,
        hasLoaded: true,
        rows: rows.getOrElse((_) => const []),
        serverTotal: total?.getOrElse((_) => 0) ?? state.serverTotal,
        searchMatches: page == 1
            ? (filteredMatches ?? const [])
            : state.searchMatches,
      ),
    );
  }

  @override
  Future<void> close() {
    _searchTimer?.cancel();
    return super.close();
  }
}
