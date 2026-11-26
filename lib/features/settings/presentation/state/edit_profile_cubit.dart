import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/admin_account.dart';
import '../../data/settings_mock_data.dart';
import 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit() : super(_initial());

  static EditProfileState _initial() {
    final AdminAccount account = SettingsMockData.currentAdmin();
    return EditProfileState(
      account: account,
      name: account.name,
      mobileNumber: account.mobileNumber,
      updatedAt: DateTime.now(),
    );
  }

  void refresh() => emit(state.copyWith(updatedAt: DateTime.now()));

  void setName(String value) => emit(state.copyWith(name: value));

  void setMobileNumber(String value) =>
      emit(state.copyWith(mobileNumber: value));

  bool save() {
    if (!state.isNameValid || !state.isMobileValid) {
      emit(state.copyWith(showErrors: true));
      return false;
    }
    SettingsMockData.updateCurrentAdmin(
      name: state.name.trim(),
      mobileNumber: state.mobileNumber.trim(),
    );
    return true;
  }
}
