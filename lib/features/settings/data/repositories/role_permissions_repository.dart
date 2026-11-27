import 'package:fpdart/fpdart.dart';

import '../../../../core/access/role_permissions.dart';
import '../../../../core/errors/failure.dart';
import '../datasources/role_permissions_remote_data_source.dart';

class RolePermissionsRepository {
  RolePermissionsRepository(this._dataSource);

  final RolePermissionsRemoteDataSource _dataSource;

  RolePermissions? _cached;

  Future<Either<Failure, RolePermissions>> fetch({bool refresh = false}) async {
    final RolePermissions? cached = _cached;
    if (cached != null && !refresh) return right(cached);
    final result = await _dataSource.fetch();
    return result.map((permissions) => _cached = permissions);
  }

  Future<Either<Failure, int>> save(
    RolePermissions saved,
    RolePermissions draft, {
    required String updatedBy,
  }) async {
    final result = await _dataSource.save(
      draft,
      draft.changedRoles(saved),
      updatedBy: updatedBy,
    );
    if (result.isRight()) _cached = draft;
    return result;
  }
}
