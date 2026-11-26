import '../../../../core/utils/app_validators.dart';
import '../../../../core/enums/admin_role.dart';

class AdminFormState {
  const AdminFormState({
    required this.updatedAt,
    this.name = '',
    this.email = '',
    this.role = AdminRole.supportAdmin,
    this.isActive = true,
    this.showErrors = false,
    this.isEmailTaken = false,
  });

  final DateTime updatedAt;
  final String name;
  final String email;
  final AdminRole role;
  final bool isActive;
  final bool showErrors;
  final bool isEmailTaken;

  bool get isNameValid => name.trim().isNotEmpty;

  bool get isEmailValid => AppValidators.isValidEmail(email);

  bool get showNameError => showErrors && !isNameValid;

  bool get showEmailInvalid => showErrors && !isEmailValid;

  AdminFormState copyWith({
    DateTime? updatedAt,
    String? name,
    String? email,
    AdminRole? role,
    bool? isActive,
    bool? showErrors,
    bool? isEmailTaken,
  }) {
    return AdminFormState(
      updatedAt: updatedAt ?? this.updatedAt,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      showErrors: showErrors ?? this.showErrors,
      isEmailTaken: isEmailTaken ?? this.isEmailTaken,
    );
  }
}
