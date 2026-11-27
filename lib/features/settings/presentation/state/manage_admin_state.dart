import '../../data/models/admin_staff_member.dart';
import 'admin_form_state.dart';

enum ManageAdminStatus { loading, loaded, notFound, failure }

class ManageAdminState {
  const ManageAdminState({
    this.status = ManageAdminStatus.loading,
    this.member,
    this.form,
    this.formError,
    this.errorMessage,
    this.isSelf = false,
    this.isLastSuperAdmin = false,
    this.isActorSuperAdmin = false,
    this.isRemoving = false,
  });

  final ManageAdminStatus status;
  final AdminStaffMember? member;
  final AdminFormState? form;
  final String? formError;
  final String? errorMessage;
  final bool isSelf;
  final bool isLastSuperAdmin;
  final bool isActorSuperAdmin;
  final bool isRemoving;

  bool get canChangeSuperAdmin =>
      isActorSuperAdmin || member?.isSuperAdmin != true;

  bool get canRemove => !isSelf && !isLastSuperAdmin && canChangeSuperAdmin;

  bool get isBusy => isRemoving || (form?.isSaving ?? false);

  ManageAdminState copyWith({
    AdminStaffMember? member,
    AdminFormState? form,
    String? Function()? formError,
    bool? isRemoving,
  }) {
    return ManageAdminState(
      status: status,
      member: member ?? this.member,
      form: form ?? this.form,
      formError: formError == null ? this.formError : formError(),
      errorMessage: errorMessage,
      isSelf: isSelf,
      isLastSuperAdmin: isLastSuperAdmin,
      isActorSuperAdmin: isActorSuperAdmin,
      isRemoving: isRemoving ?? this.isRemoving,
    );
  }
}
