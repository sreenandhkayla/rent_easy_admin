import '../../data/models/admin_account.dart';

enum EditProfileStatus { loading, loaded, failure }

class EditProfileState {
  const EditProfileState({
    this.status = EditProfileStatus.loading,
    this.account,
    this.name = '',
    this.mobileNumber = '',
    this.updatedAt,
    this.errorMessage,
    this.showErrors = false,
    this.isSaving = false,
  });

  final EditProfileStatus status;
  final AdminAccount? account;
  final String name;
  final String mobileNumber;
  final DateTime? updatedAt;
  final String? errorMessage;
  final bool showErrors;
  final bool isSaving;

  bool get isNameValid => name.trim().isNotEmpty;

  bool get isMobileValid => AdminAccount.isValidMobile(mobileNumber);

  bool get showNameError => showErrors && !isNameValid;

  bool get showMobileError => showErrors && !isMobileValid;

  EditProfileState copyWith({
    EditProfileStatus? status,
    AdminAccount? account,
    String? name,
    String? mobileNumber,
    DateTime? updatedAt,
    String? Function()? errorMessage,
    bool? showErrors,
    bool? isSaving,
  }) {
    return EditProfileState(
      status: status ?? this.status,
      account: account ?? this.account,
      name: name ?? this.name,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      updatedAt: updatedAt ?? this.updatedAt,
      errorMessage: errorMessage == null ? this.errorMessage : errorMessage(),
      showErrors: showErrors ?? this.showErrors,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}
