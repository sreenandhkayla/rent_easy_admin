enum LoginStatus { initial, submitting, success }

class LoginState {
  const LoginState({
    this.status = LoginStatus.initial,
    this.emailError,
    this.passwordError,
  });

  final LoginStatus status;
  final String? emailError;
  final String? passwordError;

  LoginState copyWith({
    LoginStatus? status,
    String? Function()? emailError,
    String? Function()? passwordError,
  }) {
    return LoginState(
      status: status ?? this.status,
      emailError: emailError != null ? emailError() : this.emailError,
      passwordError: passwordError != null
          ? passwordError()
          : this.passwordError,
    );
  }
}
