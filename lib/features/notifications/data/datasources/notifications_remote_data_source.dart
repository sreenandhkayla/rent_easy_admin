import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/data/firestore_failures.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/resources/strings/app_strings.dart';
import '../../../../core/resources/strings/notifications_strings.dart';
import '../../../shop_owners/data/models/shop_owner.dart';
import '../../../shops/data/models/shop.dart';
import '../models/admin_notification.dart';

class NotificationsRemoteDataSource {
  const NotificationsRemoteDataSource(this._firestore, this._auth);

  static const int listLimit = 100;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  CollectionReference<Map<String, dynamic>> get _notifications =>
      _firestore.collection(AdminNotification.collection);

  Query<Map<String, dynamic>> _byStatus(NotificationStatus? status) =>
      status == null
      ? _notifications
      : _notifications.where(
          AdminNotification.statusField,
          isEqualTo: status.name,
        );

  Future<Either<Failure, List<AdminNotification>>> fetchList(
    NotificationStatus? status,
  ) => _read(() async {
    final snapshot = await _byStatus(status)
        .orderBy(AdminNotification.createdAtField, descending: true)
        .limit(listLimit)
        .get();
    return [
      for (final document in snapshot.docs)
        AdminNotification.fromDocument(document.id, document.data()),
    ];
  });

  Future<Either<Failure, int>> count(NotificationStatus? status) =>
      _read(() async {
        final snapshot = await _byStatus(status).count().get();
        return snapshot.count ?? 0;
      });

  Future<Either<Failure, AdminNotification?>> fetch(String id) =>
      _read(() async {
        final document = await _notifications.doc(id).get();
        final Map<String, dynamic>? data = document.data();
        if (!document.exists || data == null) return null;
        return AdminNotification.fromDocument(document.id, data);
      });

  Future<Either<Failure, AudienceReach>> fetchReach(
    NotificationAudience audience,
  ) => _read(() async {
    final CollectionReference<Map<String, dynamic>> shops = _firestore
        .collection(Shop.collection);
    return switch (audience) {
      NotificationAudience.allOwners => AudienceReach(
        owners:
            (await _firestore.collection(ShopOwner.collection).count().get())
                .count,
      ),
      NotificationAudience.subscribedShops => AudienceReach(
        shops:
            (await shops
                    .where(
                      Shop.subscriptionStatusField,
                      isEqualTo: Shop.statusActive,
                    )
                    .count()
                    .get())
                .count,
      ),
      NotificationAudience.expiredSubscriptionShops => AudienceReach(
        shops:
            (await shops
                    .where(
                      Shop.subscriptionStatusField,
                      isEqualTo: Shop.statusExpired,
                    )
                    .count()
                    .get())
                .count,
      ),
    };
  });

  Future<Either<Failure, String>> save(
    NotificationDraft draft, {
    required NotificationAuthor author,
    required bool queue,
    String? existingId,
  }) async {
    final String? uid = _auth.currentUser?.uid;
    if (uid == null) {
      return left(const AuthFailure(NotificationsStrings.signedOut));
    }
    final DocumentReference<Map<String, dynamic>> reference = existingId == null
        ? _notifications.doc()
        : _notifications.doc(existingId);
    try {
      await _firestore.runTransaction((transaction) async {
        if (existingId != null) {
          final snapshot = await transaction.get(reference);
          final Object? status = snapshot
              .data()?[AdminNotification.statusField];
          if (!snapshot.exists || status != NotificationStatus.draft.name) {
            throw const _NotADraft();
          }
        }
        transaction.set(reference, {
          ...draft.toFields(),
          AdminNotification.statusField: queue
              ? NotificationStatus.queued.name
              : NotificationStatus.draft.name,
          AdminNotification.updatedAtField: FieldValue.serverTimestamp(),
          if (existingId == null) ...{
            AdminNotification.createdAtField: FieldValue.serverTimestamp(),
            AdminNotification.createdByUidField: uid,
            AdminNotification.createdByNameField: author.name,
            AdminNotification.createdByEmailField: author.email,
          },
          if (queue) ...{
            AdminNotification.queuedAtField: FieldValue.serverTimestamp(),
            AdminNotification.queuedByUidField: uid,
          },
        }, SetOptions(merge: true));
      });
      return right(reference.id);
    } on _NotADraft {
      return left(const DataFailure(NotificationsStrings.noLongerDraft));
    } on FirebaseException catch (error) {
      return left(FirestoreFailures.write(error.code));
    } catch (_) {
      return left(const DataFailure(AppStrings.recordsSaveFailed));
    }
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
}

class _NotADraft implements Exception {
  const _NotADraft();
}
