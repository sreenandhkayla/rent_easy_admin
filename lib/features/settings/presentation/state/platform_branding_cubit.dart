import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/platform_settings_repository.dart';

class PlatformBrandingCubit extends Cubit<String?> {
  PlatformBrandingCubit(this._repository) : super(null);

  final PlatformSettingsRepository _repository;

  Future<void> load() async {
    final result = await _repository.fetch();
    if (isClosed) return;
    result.match((_) {}, (settings) => apply(settings.platformName));
  }

  void apply(String platformName) {
    final String name = platformName.trim();
    emit(name.isEmpty ? null : name);
  }
}
