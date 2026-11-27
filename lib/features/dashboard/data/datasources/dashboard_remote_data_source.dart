import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/data/firestore_failures.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/resources/strings/app_strings.dart';
import '../../../shop_owners/data/models/shop_owner.dart';
import '../../../shops/data/models/shop.dart';
import '../models/dashboard_counts.dart';

class DashboardRemoteDataSource {
  const DashboardRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  Future<Either<Failure, DashboardCounts>> fetchCounts() async {
    try {
      final List<AggregateQuerySnapshot> snapshots = await Future.wait([
        _firestore.collection(Shop.collection).count().get(),
        _firestore.collection(ShopOwner.collection).count().get(),
      ]);
      return right(
        DashboardCounts(
          totalShops: snapshots[0].count ?? 0,
          totalShopOwners: snapshots[1].count ?? 0,
          fetchedAt: DateTime.now(),
        ),
      );
    } on FirebaseException catch (error) {
      return left(FirestoreFailures.read(error.code));
    } catch (_) {
      return left(const DataFailure(AppStrings.recordsLoadFailed));
    }
  }
}
