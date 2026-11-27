import '../../../../core/data/admin_record.dart';
import '../../../../core/utils/app_validators.dart';
import '../../../../core/enums/admin_role.dart';

class AdminFormState {
  const AdminFormState({
    required this.updatedAt,
    this.name = '',
    this.email = '',
    this.password = '',
    this.role = AdminRole.supportAdmin,
    this.isActive = true,
    this.showErrors = false,
    this.isEmailTaken = false,
    this.isSaving = false,
  });

  final DateTime updatedAt;
  final String name;
  final String email;
  final String password;
  final AdminRole role;
  final bool isActive;
  final bool showErrors;
  final bool isEmailTaken;
  final bool isSaving;

  bool get isNameValid => name.trim().isNotEmpty;

  bool get isEmailValid => AppValidators.isValidEmail(email);

  bool get isPasswordValid => password.length >= AdminRecord.minPasswordLength;

  bool get showNameError => showErrors && !isNameValid;

  bool get showPasswordError => showErrors && !isPasswordValid;

  bool get showEmailInvalid => showErrors && !isEmailValid;

  AdminFormState copyWith({
    DateTime? updatedAt,
    String? name,
    String? email,
    String? password,
    AdminRole? role,
    bool? isActive,
    bool? showErrors,
    bool? isEmailTaken,
    bool? isSaving,
  }) {
    return AdminFormState(
      updatedAt: updatedAt ?? this.updatedAt,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      showErrors: showErrors ?? this.showErrors,
      isEmailTaken: isEmailTaken ?? this.isEmailTaken,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}
