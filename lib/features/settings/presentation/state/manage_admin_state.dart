import '../../data/models/admin_staff_member.dart';
import 'admin_form_state.dart';

enum ManageAdminStatus { loading, loaded, notFound }

class ManageAdminState {
  const ManageAdminState({
    this.status = ManageAdminStatus.loading,
    this.member,
    this.form,
    this.formError,
    this.isSelf = false,
    this.isLastSuperAdmin = false,
  });

  final ManageAdminStatus status;
  final AdminStaffMember? member;
  final AdminFormState? form;
  final String? formError;
  final bool isSelf;
  final bool isLastSuperAdmin;

  bool get canRemove => !isSelf && !isLastSuperAdmin;

  ManageAdminState copyWith({
    AdminFormState? form,
    String? Function()? formError,
  }) {
    return ManageAdminState(
      status: status,
      member: member,
      form: form ?? this.form,
      formError: formError == null ? this.formError : formError(),
      isSelf: isSelf,
      isLastSuperAdmin: isLastSuperAdmin,
    );
  }
}
