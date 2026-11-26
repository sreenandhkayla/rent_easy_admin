import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/admin_role.dart';
import '../../data/models/admin_staff_member.dart';
import '../../data/settings_mock_data.dart';
import 'admin_form_state.dart';

class AddAdminCubit extends Cubit<AdminFormState> {
  AddAdminCubit() : super(AdminFormState(updatedAt: DateTime.now()));

  void refresh() => emit(state.copyWith(updatedAt: DateTime.now()));

  void setName(String value) => emit(state.copyWith(name: value));

  void setEmail(String value) =>
      emit(state.copyWith(email: value, isEmailTaken: false));

  void setRole(AdminRole value) => emit(state.copyWith(role: value));

  void setActive(bool value) => emit(state.copyWith(isActive: value));

  AdminStaffMember? save() {
    final bool isTaken =
        state.isEmailValid && SettingsMockData.emailExists(state.email);
    if (!state.isNameValid || !state.isEmailValid || isTaken) {
      emit(state.copyWith(showErrors: true, isEmailTaken: isTaken));
      return null;
    }
    final AdminStaffMember member = AdminStaffMember(
      adminId: SettingsMockData.nextAdminId(),
      name: state.name.trim(),
      email: state.email.trim().toLowerCase(),
      role: state.role.label,
      isActive: state.isActive,
    );
    SettingsMockData.addStaff(member);
    return member;
  }
}
