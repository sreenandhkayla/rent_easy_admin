import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/registration_date_filter.dart';
import '../../data/shop_owners_mock_data.dart';
import 'shop_owners_state.dart';

class ShopOwnersCubit extends Cubit<ShopOwnersState> {
  ShopOwnersCubit() : super(const ShopOwnersState());

  static const Duration _mockLatency = Duration(milliseconds: 700);

  Future<void> load() async {
    emit(state.copyWith(isLoading: true));
    await Future<void>.delayed(_mockLatency);
    if (isClosed) return;
    emit(
      state.copyWith(
        isLoading: false,
        owners: ShopOwnersMockData.owners(),
        totalOnPlatform: ShopOwnersMockData.totalOnPlatform,
        updatedAt: DateTime.now(),
      ),
    );
  }

  void syncOwners() =>
      emit(state.copyWith(owners: ShopOwnersMockData.owners()));

  void search(String query) => emit(state.copyWith(query: query, page: 1));

  void filterByStatus(OwnerStatusFilter filter) =>
      emit(state.copyWith(statusFilter: filter, page: 1));

  void filterByRegistrationDate(RegistrationDateFilter filter) =>
      emit(state.copyWith(dateFilter: filter, page: 1));

  void sortBy(OwnerSortField field) {
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
