import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/resources/strings/app_strings.dart';
import '../../../../core/utils/app_validators.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repository) : super(const AuthState());

  final AuthRepository _repository;

  void emailChanged() => _clearFieldErrors();

  void passwordChanged() => _clearFieldErrors();

  void _clearFieldErrors() {
    if (state.emailError != null ||
        state.passwordError != null ||
        state.errorMessage != null) {
      emit(const AuthState());
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    if (state.isLoading) return;

    final trimmedEmail = email.trim();
    final String? emailError = AppValidators.isValidEmail(trimmedEmail)
        ? null
        : AppStrings.invalidWorkEmail;
    final String? passwordError = password.isEmpty
        ? AppStrings.enterPassword
        : null;
    if (emailError != null || passwordError != null) {
      emit(
        AuthState(
          status: AuthStatus.failure,
          emailError: emailError,
          passwordError: passwordError,
        ),
      );
      return;
    }

    emit(const AuthState(status: AuthStatus.loading));
    final result = await _repository.signIn(
      email: trimmedEmail,
      password: password,
    );
    if (isClosed) return;

    result.match(
      (failure) => emit(
        AuthState(status: AuthStatus.failure, errorMessage: failure.message),
      ),
      (account) =>
          emit(AuthState(status: AuthStatus.success, account: account)),
    );
  }

  Future<void> signOut() async {
    if (state.isLoading) return;

    emit(const AuthState(status: AuthStatus.loading));
    final result = await _repository.signOut();
    if (isClosed) return;

    result.match(
      (failure) => _fail(failure.message),
      (_) => emit(const AuthState(status: AuthStatus.signedOut)),
    );
  }

  void _fail(String message) =>
      emit(AuthState(status: AuthStatus.failure, errorMessage: message));
}
