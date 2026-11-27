import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/shop.dart';
import '../../data/models/shop_details.dart';
import '../../data/repositories/shops_repository.dart';
import 'shop_details_state.dart';

class ShopDetailsCubit extends Cubit<ShopDetailsState> {
  ShopDetailsCubit(this._repository, this.shopId)
    : super(const ShopDetailsState());

  final ShopsRepository _repository;
  final String? shopId;

  Future<void> load() async {
    final String? id = shopId;
    if (id == null || id.isEmpty) {
      emit(const ShopDetailsState(status: ShopDetailsStatus.notFound));
      return;
    }
    emit(
      state.copyWith(
        status: state.details == null ? ShopDetailsStatus.loading : null,
        errorMessage: () => null,
      ),
    );
    final result = await _repository.fetchShopDetails(id);
    if (isClosed) return;
    result.match(
      (failure) => emit(
        state.copyWith(
          status: state.details == null ? ShopDetailsStatus.failure : null,
          errorMessage: () => failure.message,
        ),
      ),
      (details) => emit(
        ShopDetailsState(
          status: details == null
              ? ShopDetailsStatus.notFound
              : ShopDetailsStatus.loaded,
          details: details,
          updatedAt: DateTime.now(),
          hasChanges: state.hasChanges,
        ),
      ),
    );
  }

  Future<String?> setRestricted(bool isRestricted) async {
    final ShopDetails? details = state.details;
    if (details == null || state.isSaving) return null;
    emit(state.copyWith(isSaving: true));
    final result = await _repository.setRestricted(details, isRestricted);
    if (isClosed) return null;
    return result.match(
      (failure) {
        emit(state.copyWith(isSaving: false));
        return failure.message;
      },
      (_) {
        emit(
          state.copyWith(
            isSaving: false,
            hasChanges: true,
            details: details.copyWith(
              shop: details.shop.copyWith(
                status: isRestricted
                    ? ShopStatus.restricted
                    : ShopStatus.active,
              ),
            ),
          ),
        );
        return null;
      },
    );
  }
}
