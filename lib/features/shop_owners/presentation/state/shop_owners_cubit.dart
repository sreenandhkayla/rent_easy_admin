import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/registration_date_filter.dart';
import '../../data/models/owner_list_query.dart';
import '../../data/models/owner_search.dart';
import '../../data/models/shop_owner.dart';
import '../../data/repositories/shop_owners_repository.dart';
import 'shop_owners_state.dart';

class ShopOwnersCubit extends Cubit<ShopOwnersState> {
  ShopOwnersCubit(this._repository) : super(const ShopOwnersState());

  static const Duration _searchDebounce = Duration(milliseconds: 500);

  final ShopOwnersRepository _repository;
  Timer? _searchTimer;
  int _request = 0;

  Future<void> load() async {
    _repository.clear();
    emit(state.copyWith(updatedAt: DateTime.now()));
    final totals = _repository.count(const OwnerListQuery());
    await _fetch(page: 1);
    final result = await totals;
    if (isClosed) return;
    result.match(
      (_) {},
      (total) => emit(state.copyWith(totalOnPlatform: total)),
    );
  }

  Future<void> retry() => _fetch(page: state.page);

  void search(String query) {
    emit(state.copyWith(query: query));
    _searchTimer?.cancel();
    _searchTimer = Timer(_searchDebounce, () {
      final String term = OwnerSearch.normalize(query);
      final String applied = OwnerSearch.isActive(term) ? term : '';
      if (applied == state.activeSearch) return;
      emit(
        state.copyWith(
          activeSearch: applied,
          hasCustomSearchSort: false,
          ownerIdMatches: const [],
        ),
      );
      _fetch(page: 1);
    });
  }

  void filterByStatus(OwnerStatusFilter filter) {
    if (filter == state.statusFilter) return;
    emit(state.copyWith(statusFilter: filter));
    _fetch(page: 1);
  }

  void filterByRegistrationDate(RegistrationDateFilter filter) {
    if (filter == state.dateFilter) return;
    emit(state.copyWith(dateFilter: filter));
    _fetch(page: 1);
  }

  void sortBy(OwnerSortField field) {
    final bool wasServerSorted = state.isServerSorted;
    emit(
      state.copyWith(
        sortField: field,
        isAscending: field == state.sortField ? !state.isAscending : true,
        hasCustomSearchSort: state.isSearching,
      ),
    );
    if (!state.isSearching && (state.isServerSorted || wasServerSorted)) {
      _fetch(page: 1, recount: false);
    }
  }

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
    final OwnerListQuery query = state.listQuery;
    final OwnerIdSearch? idSearch = page == 1 && state.isSearching
        ? OwnerSearch.ownerIdFor(state.activeSearch)
        : null;

    final pageResult = _repository.fetchPage(query, page);
    final countResult = recount ? _repository.count(query) : null;
    final idResult = idSearch == null
        ? null
        : _repository.findByOwnerId(idSearch);
    final rows = await pageResult;
    final total = await countResult;
    final ids = await idResult;
    if (isClosed || request != _request) return;

    final String? failure =
        rows.fold((failure) => failure.message, (_) => null) ??
        total?.fold((failure) => failure.message, (_) => null) ??
        ids?.fold((failure) => failure.message, (_) => null);
    if (failure != null) return _fail(failure);

    final List<ShopOwner>? idMatches = ids
        ?.getOrElse((_) => const [])
        .where(query.matches)
        .toList();
    emit(
      state.copyWith(
        isLoading: false,
        hasLoaded: true,
        rows: rows.getOrElse((_) => const []),
        serverTotal: total?.getOrElse((_) => 0) ?? state.serverTotal,
        ownerIdMatches: page == 1
            ? (idMatches ?? const [])
            : state.ownerIdMatches,
      ),
    );
  }

  void _fail(String message) =>
      emit(state.copyWith(isLoading: false, errorMessage: () => message));

  @override
  Future<void> close() {
    _searchTimer?.cancel();
    return super.close();
  }
}
