import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';

import '../errors/failure.dart';
import '../resources/strings/app_strings.dart';
import '../resources/strings/settings_strings.dart';
import 'admin_record.dart';
import 'firestore_failures.dart';

class AdminsRemoteDataSource {
  const AdminsRemoteDataSource(this._firestore);

  static const String _collection = 'admin';

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _admins =>
      _firestore.collection(_collection);

  Query<Map<String, dynamic>> _byEmail(String email) => _admins
      .where(
        AdminRecord.emailField,
        isEqualTo: AdminRecord.normalizeEmail(email),
      )
      .limit(1);

  Future<Either<Failure, AdminRecord?>> findByEmail(String email) =>
      _read(() async {
        final snapshot = await _byEmail(email).get();
        final document = snapshot.docs.firstOrNull;
        return document == null
            ? null
            : AdminRecord.fromDocument(document.data(), document.id);
      });

  Future<Either<Failure, bool>> hasAnyAdmin() => _read(() async {
    final snapshot = await _admins.limit(1).get();
    return snapshot.docs.isNotEmpty;
  });

  Future<Either<Failure, String>> createAdmin(AdminRecord admin) async {
    final existing = await findByEmail(admin.email);
    if (existing case Left(:final value)) return left(value);
    if (existing.getOrElse((_) => null) != null) {
      return left(const DataFailure(SettingsStrings.emailTaken));
    }

    final reference = _admins.doc();
    final result = await _write(
      () => reference.set({
        ...admin.toFields(),
        AdminRecord.createdAtField: FieldValue.serverTimestamp(),
        AdminRecord.updatedAtField: FieldValue.serverTimestamp(),
      }),
    );
    return result.map((_) => reference.id);
  }

  Future<Either<Failure, T>> _read<T>(Future<T> Function() action) async {
    try {
      return right(await action());
    } on FirebaseException catch (error) {
      return left(FirestoreFailures.read(error.code));
    } catch (_) {
      return left(const DataFailure(AppStrings.recordsLoadFailed));
    }
  }

  Future<Either<Failure, Unit>> _write(Future<void> Function() action) async {
    try {
      await action();
      return right(unit);
    } on FirebaseException catch (error) {
      return left(FirestoreFailures.write(error.code));
    } catch (_) {
      return left(const DataFailure(AppStrings.recordsSaveFailed));
    }
  }
}
