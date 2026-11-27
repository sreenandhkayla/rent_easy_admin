import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/data/firestore_failures.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/resources/strings/app_strings.dart';
import '../models/platform_settings.dart';

class PlatformSettingsRemoteDataSource {
  const PlatformSettingsRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> get _document => _firestore
      .collection(PlatformSettings.collection)
      .doc(PlatformSettings.documentId);

  Future<Either<Failure, PlatformSettings>> fetch() async {
    try {
      final snapshot = await _document.get();
      return right(PlatformSettings.fromDocument(snapshot.data()));
    } on FirebaseException catch (error) {
      return left(FirestoreFailures.read(error.code));
    } catch (_) {
      return left(const DataFailure(AppStrings.recordsLoadFailed));
    }
  }

  Future<Either<Failure, Unit>> save(
    PlatformSettings settings, {
    required String updatedBy,
  }) async {
    try {
      await _document.set({
        ...settings.toFields(),
        PlatformSettings.updatedAtField: FieldValue.serverTimestamp(),
        PlatformSettings.updatedByField: updatedBy,
      }, SetOptions(merge: true));
      return right(unit);
    } on FirebaseException catch (error) {
      return left(FirestoreFailures.write(error.code));
    } catch (_) {
      return left(const DataFailure(AppStrings.recordsSaveFailed));
    }
  }
}
