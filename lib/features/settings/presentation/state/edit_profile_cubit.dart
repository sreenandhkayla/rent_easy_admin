import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/admin_account.dart';
import '../../data/repositories/admin_profile_repository.dart';
import 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit(this._repository) : super(const EditProfileState());

  final AdminProfileRepository _repository;

  Future<void> load() async {
    if (state.isSaving) return;
    emit(
      state.copyWith(
        status: state.account == null ? EditProfileStatus.loading : null,
        errorMessage: () => null,
      ),
    );
    final result = await _repository.fetchProfile();
    if (isClosed) return;
    result.match(
      (failure) => emit(
        state.copyWith(
          status: state.account == null ? EditProfileStatus.failure : null,
          errorMessage: () => failure.message,
        ),
      ),
      (account) => emit(
        EditProfileState(
          status: EditProfileStatus.loaded,
          account: account,
          name: account.name,
          mobileNumber: account.mobileNumber,
          updatedAt: DateTime.now(),
        ),
      ),
    );
  }

  void setName(String value) => emit(state.copyWith(name: value));

  void setMobileNumber(String value) =>
      emit(state.copyWith(mobileNumber: value));

  Future<({AdminAccount? saved, String? error})> save() async {
    final AdminAccount? account = state.account;
    if (account == null || state.isSaving) return (saved: null, error: null);
    if (!state.isNameValid || !state.isMobileValid) {
      emit(state.copyWith(showErrors: true));
      return (saved: null, error: null);
    }
    emit(state.copyWith(isSaving: true));
    final result = await _repository.updateProfile(
      account,
      name: state.name,
      mobileNumber: state.mobileNumber,
    );
    if (isClosed) return (saved: null, error: null);
    return result.match(
      (failure) {
        emit(state.copyWith(isSaving: false));
        return (saved: null, error: failure.message);
      },
      (saved) {
        emit(state.copyWith(isSaving: false, account: saved));
        return (saved: saved, error: null);
      },
    );
  }
}
