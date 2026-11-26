import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/admin_role.dart';
import '../../../../core/resources/strings/settings_strings.dart';
import '../../data/models/admin_staff_member.dart';
import '../../data/settings_mock_data.dart';
import 'admin_form_state.dart';
import 'manage_admin_state.dart';

class ManageAdminCubit extends Cubit<ManageAdminState> {
  ManageAdminCubit(this.adminId) : super(const ManageAdminState());

  final String? adminId;

  static AdminRole _roleOf(String label) => AdminRole.values.firstWhere(
    (role) => role.label == label,
    orElse: () => AdminRole.supportAdmin,
  );

  void load() {
    final String? id = adminId;
    final AdminStaffMember? member = id == null
        ? null
        : SettingsMockData.staffMember(id);
    if (member == null) {
      emit(const ManageAdminState(status: ManageAdminStatus.notFound));
      return;
    }
    emit(
      ManageAdminState(
        status: ManageAdminStatus.loaded,
        member: member,
        form: AdminFormState(
          updatedAt: DateTime.now(),
          name: member.name,
          email: member.email,
          role: _roleOf(member.role),
          isActive: member.isActive,
        ),
        isSelf: member.adminId == SettingsMockData.currentAdmin().adminId,
        isLastSuperAdmin: SettingsMockData.isLastActiveSuperAdmin(
          member.adminId,
          AdminRole.superAdmin.label,
        ),
      ),
    );
  }

  void _editForm(AdminFormState Function(AdminFormState form) change) {
    final AdminFormState? form = state.form;
    if (form == null) return;
    emit(state.copyWith(form: change(form), formError: () => null));
  }

  void setName(String value) => _editForm((f) => f.copyWith(name: value));

  void setEmail(String value) =>
      _editForm((f) => f.copyWith(email: value, isEmailTaken: false));

  void setRole(AdminRole value) => _editForm((f) => f.copyWith(role: value));

  void setActive(bool value) => _editForm((f) => f.copyWith(isActive: value));

  AdminStaffMember? save() {
    final AdminStaffMember? member = state.member;
    final AdminFormState? form = state.form;
    if (member == null || form == null) return null;
    final bool isTaken =
        form.isEmailValid &&
        SettingsMockData.emailExists(form.email, exceptAdminId: member.adminId);
    final bool losesLastSuperAdmin =
        state.isLastSuperAdmin &&
        (form.role != AdminRole.superAdmin || !form.isActive);
    if (!form.isNameValid || !form.isEmailValid || isTaken) {
      emit(
        state.copyWith(
          form: form.copyWith(showErrors: true, isEmailTaken: isTaken),
        ),
      );
      return null;
    }
    if (losesLastSuperAdmin) {
      emit(state.copyWith(formError: () => SettingsStrings.lastSuperAdmin));
      return null;
    }
    final AdminStaffMember updated = member.copyWith(
      name: form.name.trim(),
      email: form.email.trim().toLowerCase(),
      role: form.role.label,
      isActive: form.isActive,
    );
    SettingsMockData.updateStaff(updated);
    return updated;
  }

  bool remove() {
    final AdminStaffMember? member = state.member;
    if (member == null || !state.canRemove) return false;
    SettingsMockData.removeStaff(member.adminId);
    return true;
  }
}
