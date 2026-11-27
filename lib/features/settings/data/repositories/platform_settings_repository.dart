import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure.dart';
import '../datasources/platform_settings_remote_data_source.dart';
import '../models/platform_settings.dart';

class PlatformSettingsRepository {
  const PlatformSettingsRepository(this._dataSource);

  final PlatformSettingsRemoteDataSource _dataSource;

  Future<Either<Failure, PlatformSettings>> fetch() => _dataSource.fetch();

  Future<Either<Failure, PlatformSettings>> save(
    PlatformSettings settings, {
    required String updatedBy,
  }) async {
    final result = await _dataSource.save(settings, updatedBy: updatedBy);
    if (result case Left(:final value)) return left(value);
    final reread = await _dataSource.fetch();
    return right(reread.getOrElse((_) => settings));
  }
}
