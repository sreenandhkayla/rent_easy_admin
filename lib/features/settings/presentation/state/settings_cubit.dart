import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/access/role_permissions.dart';
import '../../../../core/enums/admin_permission.dart';
import '../../../../core/enums/admin_role.dart';
import '../../../../core/resources/strings/settings_strings.dart';
import '../../../../core/utils/app_validators.dart';
import '../../data/models/admin_search.dart';
import '../../data/models/platform_settings.dart';
import '../../data/repositories/admin_profile_repository.dart';
import '../../data/repositories/admin_staff_repository.dart';
import '../../data/repositories/platform_settings_repository.dart';
import '../../data/repositories/role_permissions_repository.dart';
import '../../data/settings_mock_data.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(
    this._profileRepository,
    this._staffRepository,
    this._rolesRepository,
    this._platformRepository, {
    SettingsTab initialTab = SettingsTab.adminProfile,
  }) : super(SettingsState(tab: initialTab));

  final AdminProfileRepository _profileRepository;
  final AdminStaffRepository _staffRepository;
  final RolePermissionsRepository _rolesRepository;
  final PlatformSettingsRepository _platformRepository;

  Timer? _staffSearchTimer;

  static const int minPasswordLength = 10;
  static const Duration _searchDebounce = Duration(milliseconds: 500);
  static const int _minPhoneDigits = 10;

  Future<void> load() async {
    emit(
      state.copyWith(
        appVersions: SettingsMockData.appVersions(),
        logs: SettingsMockData.activityLogs(),
        updatedAt: DateTime.now(),
      ),
    );
    await Future.wait([
      loadProfile(),
      loadStaff(),
      loadRoles(),
      loadPlatform(),
    ]);
  }

  Future<void> loadRoles() async {
    if (state.isSavingRoles) return;
    emit(
      state.copyWith(
        rolesStatus: state.rolePermissions == null ? RolesStatus.loading : null,
        rolesError: () => null,
      ),
    );
    final result = await _rolesRepository.fetch(refresh: true);
    if (isClosed) return;
    result.match(
      (failure) => emit(
        state.copyWith(
          rolesStatus: state.rolePermissions == null
              ? RolesStatus.failure
              : null,
          rolesError: () => failure.message,
        ),
      ),
      (permissions) => emit(
        state.copyWith(
          rolePermissions: permissions,
          roleDraft: permissions,
          rolesStatus: RolesStatus.loaded,
        ),
      ),
    );
  }

  void toggleRolePermission(AdminRole role, AdminPermission permission) {
    final RolePermissions? draft = state.roleDraft;
    if (draft == null || state.isSavingRoles) return;
    emit(state.copyWith(roleDraft: draft.toggled(role, permission)));
  }

  void discardRoleChanges() {
    final RolePermissions? saved = state.rolePermissions;
    if (saved == null || state.isSavingRoles) return;
    emit(state.copyWith(roleDraft: saved));
  }

  Future<({int? updatedAdmins, String? error})> saveRoles({
    required String updatedBy,
  }) async {
    final RolePermissions? saved = state.rolePermissions;
    final RolePermissions? draft = state.roleDraft;
    if (saved == null || draft == null || state.isSavingRoles) {
      return (updatedAdmins: null, error: null);
    }
    if (draft.rolesWithoutPages().firstOrNull case final AdminRole role) {
      return (
        updatedAdmins: null,
        error: SettingsStrings.roleNeedsPage(role.label),
      );
    }
    emit(state.copyWith(isSavingRoles: true));
    final result = await _rolesRepository.save(
      saved,
      draft,
      updatedBy: updatedBy,
    );
    if (isClosed) return (updatedAdmins: null, error: null);
    return result.match(
      (failure) {
        emit(state.copyWith(isSavingRoles: false));
        return (updatedAdmins: null, error: failure.message);
      },
      (updated) {
        emit(state.copyWith(isSavingRoles: false, rolePermissions: draft));
        loadStaff();
        return (updatedAdmins: updated, error: null);
      },
    );
  }

  Future<void> loadStaff() async {
    emit(
      state.copyWith(
        staffStatus: state.staffStatus == StaffStatus.loaded
            ? null
            : StaffStatus.loading,
        staffError: () => null,
      ),
    );
    final result = await _staffRepository.fetchStaff();
    if (isClosed) return;
    result.match(
      (failure) => emit(
        state.copyWith(
          staffStatus: state.staffStatus == StaffStatus.loaded
              ? null
              : StaffStatus.failure,
          staffError: () => failure.message,
        ),
      ),
      (staff) =>
          emit(state.copyWith(staff: staff, staffStatus: StaffStatus.loaded)),
    );
    if (!isClosed && state.isStaffSearchActive) {
      await _runStaffSearch(state.activeStaffSearch);
    }
  }

  Future<void> loadProfile() async {
    emit(
      state.copyWith(
        profileStatus: state.account == null ? ProfileStatus.loading : null,
        profileError: () => null,
      ),
    );
    final result = await _profileRepository.fetchProfile();
    if (isClosed) return;
    result.match(
      (failure) => emit(
        state.copyWith(
          profileStatus: state.account == null ? ProfileStatus.failure : null,
          profileError: () => failure.message,
        ),
      ),
      (account) => emit(
        state.copyWith(
          account: account,
          profileStatus: ProfileStatus.loaded,
          updatedAt: DateTime.now(),
        ),
      ),
    );
  }

  void selectTab(SettingsTab tab) => emit(state.copyWith(tab: tab));

  void searchStaff(String query) {
    emit(state.copyWith(staffQuery: query));
    _staffSearchTimer?.cancel();
    _staffSearchTimer = Timer(_searchDebounce, () {
      final String term = AdminSearch.normalize(query);
      final String applied = AdminSearch.isActive(term) ? term : '';
      if (applied == state.activeStaffSearch) return;
      _runStaffSearch(applied);
    });
  }

  Future<void> retryStaffSearch() => _runStaffSearch(state.activeStaffSearch);

  Future<void> _runStaffSearch(String term) async {
    if (term.isEmpty) {
      emit(
        state.copyWith(
          activeStaffSearch: '',
          staffSearchResults: () => null,
          isSearchingStaff: false,
          staffSearchError: () => null,
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        activeStaffSearch: term,
        isSearchingStaff: true,
        staffSearchError: () => null,
      ),
    );
    final result = await _staffRepository.searchStaff(term);
    if (isClosed || state.activeStaffSearch != term) return;
    result.match(
      (failure) => emit(
        state.copyWith(
          isSearchingStaff: false,
          staffSearchResults: () => null,
          staffSearchError: () => failure.message,
        ),
      ),
      (results) => emit(
        state.copyWith(
          isSearchingStaff: false,
          staffSearchResults: () => results,
        ),
      ),
    );
  }

  @override
  Future<void> close() {
    _staffSearchTimer?.cancel();
    return super.close();
  }

  void searchLogs(String query) => emit(state.copyWith(logQuery: query));

  void filterLogsByActor(String? actor) =>
      emit(state.copyWith(logActor: () => actor));

  Future<void> syncProfile() => Future.wait([loadProfile(), loadStaff()]);

  Future<void> syncStaff() => loadStaff();

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

  static bool _isValidPhone(String value) {
    final String trimmed = value.trim();
    return RegExp(r'^\+?[\d\s-]+$').hasMatch(trimmed) &&
        trimmed.replaceAll(RegExp(r'\D'), '').length >= _minPhoneDigits;
  }

  Future<void> loadPlatform() async {
    if (state.isSavingPlatform) return;
    emit(
      state.copyWith(
        platformStatus: state.platform == null ? PlatformStatus.loading : null,
        platformError: () => null,
      ),
    );
    final result = await _platformRepository.fetch();
    if (isClosed) return;
    result.match(
      (failure) => emit(
        state.copyWith(
          platformStatus: state.platform == null
              ? PlatformStatus.failure
              : null,
          platformError: () => failure.message,
        ),
      ),
      (settings) => emit(
        state.copyWith(
          platform: settings,
          platformStatus: PlatformStatus.loaded,
          platformErrors: const PlatformErrors(),
          platformVersion: state.platformVersion + 1,
        ),
      ),
    );
  }

  Future<({bool saved, String? error})> savePlatform({
    required String updatedBy,
  }) async {
    final PlatformSettings? settings = state.platform;
    if (settings == null || state.isSavingPlatform) {
      return (saved: false, error: null);
    }
    final PlatformErrors errors = PlatformErrors(
      platformName: settings.platformName.trim().isEmpty
          ? SettingsStrings.platformNameRequired
          : null,
      supportEmail: AppValidators.isValidEmail(settings.supportEmail)
          ? null
          : SettingsStrings.supportEmailInvalid,
      supportPhone: _isValidPhone(settings.supportPhone)
          ? null
          : SettingsStrings.supportPhoneRequired,
    );
    if (!errors.isEmpty) {
      emit(state.copyWith(platformErrors: errors));
      return (saved: false, error: null);
    }
    emit(state.copyWith(isSavingPlatform: true));
    final result = await _platformRepository.save(
      settings,
      updatedBy: updatedBy,
    );
    if (isClosed) return (saved: false, error: null);
    return result.match(
      (failure) {
        emit(state.copyWith(isSavingPlatform: false));
        return (saved: false, error: failure.message);
      },
      (saved) {
        emit(state.copyWith(isSavingPlatform: false, platform: saved));
        return (saved: true, error: null);
      },
    );
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
