import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/resources/strings/app_strings.dart';
import '../../../../core/utils/app_validators.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState());

  static const int _minPasswordLength = 6;

  void emailChanged() {
    if (state.emailError != null) {
      emit(state.copyWith(emailError: () => null));
    }
  }

  void passwordChanged() {
    if (state.passwordError != null) {
      emit(state.copyWith(passwordError: () => null));
    }
  }

  void submit({required String email, required String password}) {
    if (state.status == LoginStatus.submitting) return;
    final String? emailError = AppValidators.isValidEmail(email)
        ? null
        : AppStrings.invalidWorkEmail;
    final String? passwordError = password.length >= _minPasswordLength
        ? null
        : 'Password must be at least $_minPasswordLength characters.';
    if (emailError != null || passwordError != null) {
      emit(
        state.copyWith(
          status: LoginStatus.initial,
          emailError: () => emailError,
          passwordError: () => passwordError,
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        status: LoginStatus.success,
        emailError: () => null,
        passwordError: () => null,
      ),
    );
  }
}
