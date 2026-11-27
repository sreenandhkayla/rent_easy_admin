import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/resources/strings/app_strings.dart';
import '../../../../core/resources/strings/settings_strings.dart';

typedef AdminSignIn = ({
  String email,
  DateTime? lastSignInAt,
  bool hasSecondFactor,
});

class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._auth);

  static const String _adminClaim = 'admin';
  static const String _provisioningApp = 'adminProvisioning';

  final FirebaseAuth _auth;

  static AuthFailure failureForCode(String code) => AuthFailure(switch (code) {
    'invalid-credential' ||
    'wrong-password' ||
    'user-not-found' ||
    'INVALID_LOGIN_CREDENTIALS' => AppStrings.loginFailed,
    'invalid-email' => AppStrings.invalidWorkEmail,
    'user-disabled' => AppStrings.loginAccountDisabled,
    'too-many-requests' => AppStrings.loginTooManyAttempts,
    'network-request-failed' => AppStrings.checkConnection,
    'second-factor-required' ||
    'multi-factor-auth-required' => AppStrings.loginSecondFactorRequired,
    _ => AppStrings.loginUnavailable,
  });

  Future<Either<Failure, Unit>> signIn({
    required String email,
    required String password,
  }) => _guard(() async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
    return unit;
  });

  Future<Either<Failure, ({String email, String? displayName})?>>
  restoreSession() => _guard(() async {
    final user = await _auth.authStateChanges().first;
    final email = user?.email;
    return email == null
        ? null
        : (email: email, displayName: user?.displayName);
  });

  Future<Either<Failure, AdminSignIn?>> currentSignIn() => _guard(() async {
    final user = await _auth.authStateChanges().first;
    final email = user?.email;
    if (user == null || email == null) return null;
    bool hasSecondFactor = false;
    try {
      hasSecondFactor =
          (await user.multiFactor.getEnrolledFactors()).isNotEmpty;
    } catch (_) {
      hasSecondFactor = false;
    }
    return (
      email: email,
      lastSignInAt: user.metadata.lastSignInTime,
      hasSecondFactor: hasSecondFactor,
    );
  });

  Future<Either<Failure, bool>> createLogin(
    String email,
    String password,
  ) async {
    FirebaseAuth? auth;
    try {
      final FirebaseApp app =
          Firebase.apps.any((app) => app.name == _provisioningApp)
          ? Firebase.app(_provisioningApp)
          : await Firebase.initializeApp(
              name: _provisioningApp,
              options: Firebase.app().options,
            );
      auth = FirebaseAuth.instanceFor(app: app);
      try {
        await auth.setPersistence(Persistence.NONE);
      } catch (_) {}
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return right(true);
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') return right(false);
      return left(
        AuthFailure(switch (error.code) {
          'invalid-email' => SettingsStrings.emailInvalid,
          'weak-password' => SettingsStrings.passwordTooShort,
          'network-request-failed' => AppStrings.checkConnection,
          _ => SettingsStrings.adminLoginFailed,
        }),
      );
    } catch (_) {
      return left(const AuthFailure(SettingsStrings.adminLoginFailed));
    } finally {
      try {
        await auth?.signOut();
      } catch (_) {}
    }
  }

  Future<Either<Failure, Unit>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final User? user = _auth.currentUser;
      final String? email = user?.email;
      if (user == null || email == null) {
        return left(const AuthFailure(SettingsStrings.profileSignedOut));
      }
      await user.reauthenticateWithCredential(
        EmailAuthProvider.credential(email: email, password: currentPassword),
      );
      await user.updatePassword(newPassword);
      return right(unit);
    } on FirebaseAuthException catch (error) {
      return left(
        AuthFailure(switch (error.code) {
          'wrong-password' ||
          'invalid-credential' ||
          'INVALID_LOGIN_CREDENTIALS' => SettingsStrings.currentPasswordWrong,
          'weak-password' => SettingsStrings.newPasswordTooShort,
          'requires-recent-login' => SettingsStrings.passwordRecentLogin,
          'too-many-requests' => AppStrings.loginTooManyAttempts,
          'network-request-failed' => AppStrings.checkConnection,
          _ => SettingsStrings.passwordChangeFailed,
        }),
      );
    } catch (_) {
      return left(const AuthFailure(SettingsStrings.passwordChangeFailed));
    }
  }

  Future<Either<Failure, bool>> isCurrentUserAdmin({
    bool forceRefresh = false,
  }) => _guard(() async {
    final token = await _auth.currentUser?.getIdTokenResult(forceRefresh);
    return token?.claims?[_adminClaim] == true;
  });

  Future<Either<Failure, Unit>> signOut() => _guard(() async {
    await _auth.signOut();
    return unit;
  });

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() action) async {
    try {
      return right(await action());
    } on FirebaseAuthException catch (error) {
      return left(failureForCode(error.code));
    } catch (_) {
      return left(const AuthFailure(AppStrings.loginUnavailable));
    }
  }
}
