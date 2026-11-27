class ChangePasswordState {
  const ChangePasswordState({
    this.currentError,
    this.newPasswordError,
    this.confirmError,
    this.errorMessage,
    this.isSaving = false,
  });

  final String? currentError;
  final String? newPasswordError;
  final String? confirmError;
  final String? errorMessage;
  final bool isSaving;

  bool get hasErrors =>
      currentError != null ||
      newPasswordError != null ||
      confirmError != null ||
      errorMessage != null;
}
