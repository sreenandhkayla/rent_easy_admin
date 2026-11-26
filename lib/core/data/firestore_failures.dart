import '../errors/failure.dart';
import '../resources/strings/app_strings.dart';

abstract final class FirestoreFailures {
  static DataFailure read(String code) => DataFailure(switch (code) {
    'permission-denied' || 'unauthenticated' => AppStrings.recordsAccessDenied,
    'unavailable' || 'deadline-exceeded' => AppStrings.checkConnection,
    _ => AppStrings.recordsLoadFailed,
  });

  static DataFailure write(String code) => DataFailure(switch (code) {
    'permission-denied' || 'unauthenticated' => AppStrings.recordsWriteDenied,
    'not-found' => AppStrings.recordNotFound,
    'unavailable' || 'deadline-exceeded' => AppStrings.checkConnection,
    _ => AppStrings.recordsSaveFailed,
  });
}
