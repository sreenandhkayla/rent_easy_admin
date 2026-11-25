enum AccountRecoveryStatus { initial, submitting, success }

class AccountRecoveryState {
  const AccountRecoveryState({
    this.status = AccountRecoveryStatus.initial,
    this.emailError,
  });

  final AccountRecoveryStatus status;
  final String? emailError;
}
