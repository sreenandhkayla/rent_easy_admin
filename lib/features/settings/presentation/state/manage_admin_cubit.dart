import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/admin_role.dart';
import '../../../../core/resources/strings/settings_strings.dart';
import '../../data/models/admin_staff_member.dart';
import '../../data/repositories/admin_staff_repository.dart';
import 'admin_form_state.dart';
import 'manage_admin_state.dart';

class ManageAdminCubit extends Cubit<ManageAdminState> {
  ManageAdminCubit(this._repository, this.adminId)
    : super(const ManageAdminState());

  final AdminStaffRepository _repository;
  final String? adminId;

  Future<void> load() async {
    final String? id = adminId;
    if (id == null || id.isEmpty) {
      emit(const ManageAdminState(status: ManageAdminStatus.notFound));
      return;
    }
    emit(const ManageAdminState());
    final result = await _repository.fetchContext();
    if (isClosed) return;
    result.match(
      (failure) => emit(
        ManageAdminState(
          status: ManageAdminStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (context) {
        final AdminStaffMember? member = context.staff
            .where((item) => item.adminId == id)
            .firstOrNull;
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
              role: member.adminRole,
              isActive: member.isActive,
            ),
            isSelf: context.actor?.adminId == member.adminId,
            isLastSuperAdmin: AdminStaffRepository.isLastActiveSuperAdmin(
              context.staff,
              member.adminId,
            ),
            isActorSuperAdmin: context.actor?.isSuperAdmin ?? false,
          ),
        );
      },
    );
  }

  void _editForm(AdminFormState Function(AdminFormState form) change) {
    final AdminFormState? form = state.form;
    if (form == null || form.isSaving) return;
    emit(state.copyWith(form: change(form), formError: () => null));
  }

  void setName(String value) => _editForm((f) => f.copyWith(name: value));

  void setRole(AdminRole value) => _editForm((f) => f.copyWith(role: value));

  void setActive(bool value) => _editForm((f) => f.copyWith(isActive: value));

  String? _ruleError(AdminStaffMember member, AdminFormState form) {
    final bool touchesSuperAdmin =
        form.role != member.adminRole &&
        (member.isSuperAdmin || form.role == AdminRole.superAdmin);
    if (!state.canChangeSuperAdmin ||
        (touchesSuperAdmin && !state.isActorSuperAdmin)) {
      return SettingsStrings.superAdminOnly;
    }
    if (state.isSelf && !form.isActive) {
      return SettingsStrings.cannotDeactivateSelf;
    }
    if (state.isLastSuperAdmin &&
        (form.role != AdminRole.superAdmin || !form.isActive)) {
      return SettingsStrings.lastSuperAdmin;
    }
    return null;
  }

  Future<({AdminStaffMember? saved, String? error})> save() async {
    final AdminStaffMember? member = state.member;
    final AdminFormState? form = state.form;
    if (member == null || form == null || state.isBusy) {
      return (saved: null, error: null);
    }
    if (!form.isNameValid) {
      emit(state.copyWith(form: form.copyWith(showErrors: true)));
      return (saved: null, error: null);
    }
    final String? ruleError = _ruleError(member, form);
    if (ruleError != null) {
      emit(state.copyWith(formError: () => ruleError));
      return (saved: null, error: null);
    }
    emit(state.copyWith(form: form.copyWith(isSaving: true)));
    final result = await _repository.updateAdmin(
      member,
      name: form.name,
      role: form.role,
      isActive: form.isActive,
    );
    if (isClosed) return (saved: null, error: null);
    return result.match(
      (failure) {
        emit(state.copyWith(form: form.copyWith(isSaving: false)));
        return (saved: null, error: failure.message);
      },
      (saved) {
        emit(
          state.copyWith(member: saved, form: form.copyWith(isSaving: false)),
        );
        return (saved: saved, error: null);
      },
    );
  }

  Future<String?> remove() async {
    final AdminStaffMember? member = state.member;
    if (member == null || !state.canRemove || state.isBusy) {
      return SettingsStrings.superAdminOnly;
    }
    emit(state.copyWith(isRemoving: true));
    final result = await _repository.removeAdmin(member);
    if (isClosed) return null;
    return result.match((failure) {
      emit(state.copyWith(isRemoving: false));
      return failure.message;
    }, (_) => null);
  }
}
