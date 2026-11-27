import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/access/role_permissions.dart';
import '../../../../core/data/admin_record.dart';
import '../../../../core/data/firestore_failures.dart';
import '../../../../core/enums/admin_role.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/resources/strings/app_strings.dart';

class RolePermissionsRemoteDataSource {
  const RolePermissionsRemoteDataSource(this._firestore);

  static const int _batchLimit = 450;

  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> get _document => _firestore
      .collection(RolePermissions.collection)
      .doc(RolePermissions.documentId);

  CollectionReference<Map<String, dynamic>> get _admins =>
      _firestore.collection(AdminRecord.collection);

  Future<Either<Failure, RolePermissions>> fetch() async {
    try {
      final snapshot = await _document.get();
      return right(RolePermissions.fromDocument(snapshot.data()));
    } on FirebaseException catch (error) {
      return left(FirestoreFailures.read(error.code));
    } catch (_) {
      return left(const DataFailure(AppStrings.recordsLoadFailed));
    }
  }

  Future<Either<Failure, int>> save(
    RolePermissions permissions,
    Set<AdminRole> changedRoles, {
    required String updatedBy,
  }) async {
    try {
      final List<QueryDocumentSnapshot<Map<String, dynamic>>> admins =
          changedRoles.isEmpty
          ? const []
          : (await _admins
                    .where(
                      AdminRecord.roleField,
                      whereIn: [for (final role in changedRoles) role.name],
                    )
                    .get())
                .docs;
      final List<void Function(WriteBatch batch)> writes = [
        (batch) => batch.set(_document, {
          ...permissions.toFields(),
          RolePermissions.updatedAtField: FieldValue.serverTimestamp(),
          RolePermissions.updatedByField: updatedBy,
        }, SetOptions(merge: true)),
        for (final document in admins)
          (batch) => batch.update(document.reference, {
            AdminRecord.permissionsField: permissions.permissionListFor(
              AdminRecord.roleFromKey(document.data()[AdminRecord.roleField]),
            ),
            AdminRecord.permissionsVersionField:
                AdminRecord.currentPermissionsVersion,
            AdminRecord.updatedAtField: FieldValue.serverTimestamp(),
          }),
      ];
      for (int start = 0; start < writes.length; start += _batchLimit) {
        final WriteBatch batch = _firestore.batch();
        for (final write in writes.skip(start).take(_batchLimit)) {
          write(batch);
        }
        await batch.commit();
      }
      return right(admins.length);
    } on FirebaseException catch (error) {
      return left(FirestoreFailures.write(error.code));
    } catch (_) {
      return left(const DataFailure(AppStrings.recordsSaveFailed));
    }
  }
}
