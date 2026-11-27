import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';

import '../errors/failure.dart';
import '../resources/strings/app_strings.dart';
import '../resources/strings/settings_strings.dart';
import 'admin_record.dart';
import 'firestore_failures.dart';
import 'prefix_search.dart';

class AdminsRemoteDataSource {
  const AdminsRemoteDataSource(this._firestore);

  static const int _searchLimit = 50;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _admins =>
      _firestore.collection(AdminRecord.collection);

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

  Future<Either<Failure, List<AdminRecord>>> searchByPrefix(
    String field,
    List<String> prefixes, {
    int limit = _searchLimit,
  }) => _read(() async {
    final snapshot = await _admins
        .where(PrefixSearch.startsWithAny(field, prefixes))
        .limit(limit)
        .get();
    return [
      for (final document in snapshot.docs)
        AdminRecord.fromDocument(document.data(), document.id),
    ];
  });

  Future<Either<Failure, AdminRecord?>> fetchById(String id) => _read(() async {
    final document = await _admins.doc(id).get();
    final Map<String, dynamic>? data = document.data();
    if (!document.exists || data == null) return null;
    return AdminRecord.fromDocument(data, document.id);
  });

  Future<Either<Failure, Unit>> updateProfile(
    String id, {
    String? name,
    String? phone,
  }) => _write(
    () => _admins.doc(id).update({
      AdminRecord.nameField: ?name,
      AdminRecord.phoneField: ?phone,
      AdminRecord.updatedAtField: FieldValue.serverTimestamp(),
    }),
  );

  Future<Either<Failure, List<AdminRecord>>> fetchAll() => _read(() async {
    final snapshot = await _admins.get();
    return [
      for (final document in snapshot.docs)
        AdminRecord.fromDocument(document.data(), document.id),
    ]..sort(AdminRecord.oldestFirst);
  });

  Future<Either<Failure, Unit>> updateAdmin(
    String id,
    Map<String, Object?> fields,
  ) => _write(
    () => _admins.doc(id).update({
      ...fields,
      AdminRecord.updatedAtField: FieldValue.serverTimestamp(),
    }),
  );

  Future<Either<Failure, Unit>> deleteAdmin(String id) =>
      _write(() => _admins.doc(id).delete());

  Future<Either<Failure, Unit>> recordSignIn(String id) => _write(
    () => _admins.doc(id).update({
      AdminRecord.lastSignInAtField: FieldValue.serverTimestamp(),
    }),
  );

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
