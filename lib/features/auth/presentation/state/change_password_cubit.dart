import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/data/admin_record.dart';
import '../../../../core/resources/strings/settings_strings.dart';
import '../../data/repositories/auth_repository.dart';
import 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit(this._repository) : super(const ChangePasswordState());

  final AuthRepository _repository;

  void clearErrors() {
    if (state.hasErrors && !state.isSaving) {
      emit(const ChangePasswordState());
    }
  }

  Future<bool> submit({
    required String current,
    required String newPassword,
    required String confirm,
  }) async {
    if (state.isSaving) return false;
    final ChangePasswordState errors = ChangePasswordState(
      currentError: current.isEmpty
          ? SettingsStrings.currentPasswordRequired
          : null,
      newPasswordError: newPassword.length < AdminRecord.minPasswordLength
          ? SettingsStrings.newPasswordTooShort
          : newPassword == current
          ? SettingsStrings.newPasswordSame
          : null,
      confirmError: confirm != newPassword
          ? SettingsStrings.passwordsDoNotMatch
          : null,
    );
    if (errors.hasErrors) {
      emit(errors);
      return false;
    }
    emit(const ChangePasswordState(isSaving: true));
    final result = await _repository.changePassword(
      currentPassword: current,
      newPassword: newPassword,
    );
    if (isClosed) return false;
    return result.match((failure) {
      emit(
        failure.message == SettingsStrings.currentPasswordWrong
            ? ChangePasswordState(currentError: failure.message)
            : ChangePasswordState(errorMessage: failure.message),
      );
      return false;
    }, (_) => true);
  }
}
