import 'package:fpdart/fpdart.dart';

import '../../../../core/data/admin_record.dart';
import '../../../../core/data/admins_remote_data_source.dart';
import '../../../../core/enums/admin_role.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/resources/strings/app_strings.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepository {
  const AuthRepository(this._dataSource, this._adminsDataSource);

  final AuthRemoteDataSource _dataSource;
  final AdminsRemoteDataSource _adminsDataSource;

  Future<Either<Failure, Unit>> signOut() async {
    final result = await _dataSource.signOut();
    return result.mapLeft((_) => const AuthFailure(AppStrings.logoutFailed));
  }

  Future<Either<Failure, Unit>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) => _dataSource.changePassword(
    currentPassword: currentPassword,
    newPassword: newPassword,
  );

  Future<Either<Failure, AdminRecord>> signIn({
    required String email,
    required String password,
  }) async {
    final signedIn = await _dataSource.signIn(email: email, password: password);
    if (signedIn case Left(:final value)) return left(value);

    final account = await _currentAccount();
    final resolved = switch (account) {
      Right(value: final admin?) => right<Failure, AdminRecord>(admin),
      Right() => left<Failure, AdminRecord>(
        const AuthFailure(AppStrings.loginFailed),
      ),
      Left(:final value) => left<Failure, AdminRecord>(value),
    };
    if (resolved.isLeft()) {
      await _dataSource.signOut();
    } else if (resolved case Right(:final value) when value.id.isNotEmpty) {
      await _adminsDataSource.recordSignIn(value.id);
    }
    return resolved;
  }

  Future<Either<Failure, AdminRecord?>> restoreSession() async {
    final account = await _currentAccount();
    if (account case Left(value: AuthFailure())) {
      await _dataSource.signOut();
      return right(null);
    }
    return account;
  }

  Future<Either<Failure, AdminRecord?>> _currentAccount() async {
    final session = await _dataSource.restoreSession();
    if (session case Left(:final value)) return left(value);
    final user = session.getOrElse((_) => null);
    if (user == null) return right(null);

    final existing = await _adminsDataSource.findByEmail(user.email);
    if (existing case Left(:final value)) {
      return value is DataFailure &&
              value.message == AppStrings.recordsAccessDenied
          ? left(const AuthFailure(AppStrings.loginAdminRecordDenied))
          : left(value);
    }
    if (existing.getOrElse((_) => null) case final admin?) {
      if (!admin.isActive) {
        return left(const AuthFailure(AppStrings.loginAccountDisabled));
      }
      return admin.homeRoute == null
          ? left(const AuthFailure(AppStrings.loginNoAccess))
          : right(admin);
    }

    final isAdmin = await _dataSource.isCurrentUserAdmin();
    if (isAdmin case Left(:final value)) return left(value);
    if (!isAdmin.getOrElse((_) => false)) {
      return left(const AuthFailure(AppStrings.loginNoAccess));
    }
    return _claimFirstAdmin(user.email, user.displayName);
  }

  Future<Either<Failure, AdminRecord?>> _claimFirstAdmin(
    String email,
    String? displayName,
  ) async {
    final hasAdmins = await _adminsDataSource.hasAnyAdmin();
    if (hasAdmins case Left(:final value)) return left(value);
    if (hasAdmins.getOrElse((_) => true)) {
      return left(const AuthFailure(AppStrings.loginNoAccess));
    }

    final owner = AdminRecord(
      name: displayName ?? email.split('@').first,
      email: AdminRecord.normalizeEmail(email),
      role: AdminRole.superAdmin,
      phone: '',
      createdAt: DateTime.now(),
    );
    final created = await _adminsDataSource.createAdmin(owner);
    return created.map((id) => owner.copyWith(id: id));
  }
}
