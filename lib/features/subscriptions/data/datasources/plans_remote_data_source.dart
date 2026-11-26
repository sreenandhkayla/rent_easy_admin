import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/data/firestore_failures.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/resources/strings/app_strings.dart';
import '../models/plan_definition.dart';

class PlansRemoteDataSource {
  const PlansRemoteDataSource(this._firestore, this._auth);

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  CollectionReference<Map<String, dynamic>> get _plans =>
      _firestore.collection(PlanDefinition.collection);

  String? get _adminUid => _auth.currentUser?.uid;

  Future<Either<Failure, List<PlanDefinition>>> fetchPlans() => _read(() async {
    final snapshot = await _plans.orderBy(PlanDefinition.createdAtField).get();
    return [
      for (final document in snapshot.docs)
        PlanDefinition.fromDocument(document.id, document.data()),
    ];
  });

  Future<Either<Failure, PlanDefinition?>> fetchPlan(String id) =>
      _read(() async {
        final document = await _plans.doc(id).get();
        final Map<String, dynamic>? data = document.data();
        return data == null
            ? null
            : PlanDefinition.fromDocument(document.id, data);
      });

  Future<Either<Failure, String>> createPlan(PlanDefinition plan) =>
      _write(() async {
        final reference = _plans.doc();
        await reference.set({
          ...plan.toFields(),
          PlanDefinition.createdAtField: FieldValue.serverTimestamp(),
          PlanDefinition.updatedAtField: FieldValue.serverTimestamp(),
          PlanDefinition.archivedAtField: plan.isArchived
              ? FieldValue.serverTimestamp()
              : null,
          PlanDefinition.createdByField: _adminUid,
          PlanDefinition.updatedByField: _adminUid,
        });
        return reference.id;
      });

  Future<Either<Failure, Unit>> updatePlan(
    PlanDefinition plan, {
    required PlanStatus previousStatus,
  }) => _write(() async {
    await _plans.doc(plan.id).update({
      ...plan.toFields(),
      PlanDefinition.updatedAtField: FieldValue.serverTimestamp(),
      PlanDefinition.updatedByField: _adminUid,
      if (plan.status != previousStatus)
        PlanDefinition.archivedAtField: plan.isArchived
            ? FieldValue.serverTimestamp()
            : null,
    });
    return unit;
  });

  Future<Either<Failure, Unit>> archivePlan(String id) => _write(() async {
    await _plans.doc(id).update({
      PlanDefinition.statusField: PlanStatus.archived.name,
      PlanDefinition.archivedAtField: FieldValue.serverTimestamp(),
      PlanDefinition.updatedAtField: FieldValue.serverTimestamp(),
      PlanDefinition.updatedByField: _adminUid,
    });
    return unit;
  });

  Future<Either<Failure, T>> _read<T>(Future<T> Function() action) async {
    try {
      return right(await action());
    } on FirebaseException catch (error) {
      return left(FirestoreFailures.read(error.code));
    } catch (_) {
      return left(const DataFailure(AppStrings.recordsLoadFailed));
    }
  }

  Future<Either<Failure, T>> _write<T>(Future<T> Function() action) async {
    try {
      return right(await action());
    } on FirebaseException catch (error) {
      return left(FirestoreFailures.write(error.code));
    } catch (_) {
      return left(const DataFailure(AppStrings.recordsSaveFailed));
    }
  }
}
