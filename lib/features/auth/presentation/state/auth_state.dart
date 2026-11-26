import '../../../../core/data/admin_record.dart';

enum AuthStatus { initial, loading, success, signedOut, failure }

class AuthState {
  const AuthState({
    this.status = AuthStatus.initial,
    this.errorMessage,
    this.emailError,
    this.passwordError,
    this.account,
  });

  final AuthStatus status;
  final String? errorMessage;
  final String? emailError;
  final String? passwordError;
  final AdminRecord? account;

  bool get isLoading => status == AuthStatus.loading;
}
