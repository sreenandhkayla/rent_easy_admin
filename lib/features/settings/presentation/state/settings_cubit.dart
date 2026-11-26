import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/resources/strings/settings_strings.dart';
import '../../../../core/utils/app_validators.dart';
import '../../data/models/platform_settings.dart';
import '../../data/settings_mock_data.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({SettingsTab initialTab = SettingsTab.adminProfile})
    : super(SettingsState(tab: initialTab));

  static const int minPasswordLength = 10;

  void load() => emit(
    state.copyWith(
      account: SettingsMockData.currentAdmin(),
      staff: SettingsMockData.staff(),
      platform: SettingsMockData.platformSettings(),
      appVersions: SettingsMockData.appVersions(),
      logs: SettingsMockData.activityLogs(),
      platformErrors: const PlatformErrors(),
      updatedAt: DateTime.now(),
    ),
  );

  void selectTab(SettingsTab tab) => emit(state.copyWith(tab: tab));

  void searchStaff(String query) => emit(state.copyWith(staffQuery: query));

  void searchLogs(String query) => emit(state.copyWith(logQuery: query));

  void filterLogsByActor(String? actor) =>
      emit(state.copyWith(logActor: () => actor));

  void syncProfile() => emit(
    state.copyWith(
      account: SettingsMockData.currentAdmin(),
      staff: SettingsMockData.staff(),
    ),
  );

  void syncStaff() => emit(state.copyWith(staff: SettingsMockData.staff()));

  void editPlatform(PlatformSettings Function(PlatformSettings) change) {
    final PlatformSettings? current = state.platform;
    if (current == null) return;
    emit(
      state.copyWith(
        platform: change(current),
        platformErrors: const PlatformErrors(),
      ),
    );
  }

  static bool _isHttpsUrl(String value) {
    final Uri? uri = Uri.tryParse(value.trim());
    return uri != null && uri.scheme == 'https' && uri.host.isNotEmpty;
  }

  bool savePlatform() {
    final PlatformSettings? settings = state.platform;
    if (settings == null) return false;
    final PlatformErrors errors = PlatformErrors(
      platformName: settings.platformName.trim().isEmpty
          ? SettingsStrings.platformNameRequired
          : null,
      supportEmail: AppValidators.isValidEmail(settings.supportEmail)
          ? null
          : SettingsStrings.supportEmailInvalid,
      supportPhone: settings.supportPhone.trim().isEmpty
          ? SettingsStrings.supportPhoneRequired
          : null,
      termsUrl: _isHttpsUrl(settings.termsUrl)
          ? null
          : SettingsStrings.urlInvalid,
      privacyUrl: _isHttpsUrl(settings.privacyUrl)
          ? null
          : SettingsStrings.urlInvalid,
    );
    if (!errors.isEmpty) {
      emit(state.copyWith(platformErrors: errors));
      return false;
    }
    SettingsMockData.savePlatformSettings(settings);
    return true;
  }

  void clearPasswordErrors() {
    if (state.passwordErrors.isEmpty) return;
    emit(state.copyWith(passwordErrors: const PasswordErrors()));
  }

  bool updatePassword({
    required String current,
    required String newPassword,
    required String confirm,
  }) {
    final PasswordErrors errors = PasswordErrors(
      current: current.isEmpty ? SettingsStrings.currentPasswordRequired : null,
      newPassword: newPassword.length < minPasswordLength
          ? SettingsStrings.newPasswordTooShort
          : newPassword == current
          ? SettingsStrings.newPasswordSame
          : null,
      confirm: confirm != newPassword
          ? SettingsStrings.passwordsDoNotMatch
          : null,
    );
    if (!errors.isEmpty) {
      emit(state.copyWith(passwordErrors: errors));
      return false;
    }
    emit(
      state.copyWith(
        passwordErrors: const PasswordErrors(),
        passwordFormVersion: state.passwordFormVersion + 1,
      ),
    );
    return true;
  }
}
