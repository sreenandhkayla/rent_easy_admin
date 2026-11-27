import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/admin_role.dart';
import '../../../../core/resources/strings/settings_strings.dart';
import '../../data/repositories/admin_staff_repository.dart';
import 'admin_form_state.dart';

class AddAdminCubit extends Cubit<AdminFormState> {
  AddAdminCubit(this._repository)
    : super(AdminFormState(updatedAt: DateTime.now()));

  final AdminStaffRepository _repository;

  void refresh() => emit(state.copyWith(updatedAt: DateTime.now()));

  void setName(String value) => emit(state.copyWith(name: value));

  void setEmail(String value) =>
      emit(state.copyWith(email: value, isEmailTaken: false));

  void setPassword(String value) => emit(state.copyWith(password: value));

  void setRole(AdminRole value) => emit(state.copyWith(role: value));

  void setActive(bool value) => emit(state.copyWith(isActive: value));

  Future<({AddedAdmin? added, String? error})> save() async {
    if (state.isSaving) return (added: null, error: null);
    if (!state.isNameValid || !state.isEmailValid || !state.isPasswordValid) {
      emit(state.copyWith(showErrors: true));
      return (added: null, error: null);
    }
    emit(state.copyWith(isSaving: true));
    final result = await _repository.addAdmin(
      name: state.name,
      email: state.email,
      password: state.password,
      role: state.role,
      isActive: state.isActive,
    );
    if (isClosed) return (added: null, error: null);
    return result.match(
      (failure) {
        final bool isTaken = failure.message == SettingsStrings.emailTaken;
        emit(
          state.copyWith(
            isSaving: false,
            showErrors: true,
            isEmailTaken: isTaken,
          ),
        );
        return (added: null, error: isTaken ? null : failure.message);
      },
      (added) {
        emit(state.copyWith(isSaving: false));
        return (added: added, error: null);
      },
    );
  }
}
