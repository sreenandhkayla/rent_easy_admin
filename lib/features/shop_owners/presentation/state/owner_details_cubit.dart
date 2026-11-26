import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/owner_details.dart';
import '../../data/models/shop_owner.dart';
import '../../data/repositories/shop_owners_repository.dart';
import 'owner_details_state.dart';

class OwnerDetailsCubit extends Cubit<OwnerDetailsState> {
  OwnerDetailsCubit(this._repository, this.ownerId)
    : super(const OwnerDetailsState());

  final ShopOwnersRepository _repository;
  final String? ownerId;

  Future<void> load() async {
    final String? id = ownerId;
    if (id == null || id.isEmpty) {
      emit(const OwnerDetailsState(status: OwnerDetailsStatus.notFound));
      return;
    }
    emit(
      state.copyWith(
        status: state.details == null ? OwnerDetailsStatus.loading : null,
        errorMessage: () => null,
      ),
    );
    final result = await _repository.fetchOwnerDetails(id);
    if (isClosed) return;
    result.match(
      (failure) => emit(
        state.copyWith(
          status: state.details == null ? OwnerDetailsStatus.failure : null,
          errorMessage: () => failure.message,
        ),
      ),
      (details) => emit(
        OwnerDetailsState(
          status: details == null
              ? OwnerDetailsStatus.notFound
              : OwnerDetailsStatus.loaded,
          details: details,
          updatedAt: DateTime.now(),
          hasChanges: state.hasChanges,
        ),
      ),
    );
  }

  Future<String?> setRestricted(bool isRestricted) async {
    final OwnerDetails? details = state.details;
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
              owner: details.owner.copyWith(
                status: isRestricted
                    ? OwnerStatus.restricted
                    : OwnerStatus.active,
              ),
            ),
          ),
        );
        return null;
      },
    );
  }
}
