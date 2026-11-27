import 'package:fpdart/fpdart.dart';

import '../../../../core/data/admin_record.dart';
import '../../../../core/data/admins_remote_data_source.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/resources/strings/settings_strings.dart';
import '../../../auth/data/datasources/auth_remote_data_source.dart';
import '../models/admin_account.dart';

class AdminProfileRepository {
  const AdminProfileRepository(this._authDataSource, this._adminsDataSource);

  final AuthRemoteDataSource _authDataSource;
  final AdminsRemoteDataSource _adminsDataSource;

  Future<Either<Failure, AdminAccount>> fetchProfile() async {
    final session = await _authDataSource.currentSignIn();
    if (session case Left(:final value)) return left(value);
    final AdminSignIn? signIn = session.getOrElse((_) => null);
    if (signIn == null) {
      return left(const AuthFailure(SettingsStrings.profileSignedOut));
    }
    final admin = await _adminsDataSource.findByEmail(signIn.email);
    if (admin case Left(:final value)) return left(value);
    final AdminRecord? record = admin.getOrElse((_) => null);
    if (record == null) {
      return left(const DataFailure(SettingsStrings.profileNotFound));
    }
    return right(
      AdminAccount(
        record: record,
        lastSignInAt: signIn.lastSignInAt,
        isTwoStepEnabled: signIn.hasSecondFactor,
      ),
    );
  }

  Future<Either<Failure, AdminAccount>> updateProfile(
    AdminAccount account, {
    required String name,
    required String mobileNumber,
  }) async {
    final String newName = name.trim();
    final String newPhone = AdminRecord.phoneDigits(mobileNumber);
    final AdminRecord current = account.record;
    final bool nameChanged = newName != current.name;
    final bool phoneChanged = newPhone != current.phone;
    if (!nameChanged && !phoneChanged) return right(account);
    final result = await _adminsDataSource.updateProfile(
      current.id,
      name: nameChanged ? newName : null,
      phone: phoneChanged ? newPhone : null,
    );
    if (result case Left(:final value)) return left(value);
    final reread = await _adminsDataSource.fetchById(current.id);
    final AdminRecord updated = reread.match(
      (_) => current.copyWith(name: newName, phone: newPhone),
      (record) => record ?? current.copyWith(name: newName, phone: newPhone),
    );
    return right(account.copyWith(record: updated));
  }
}
