import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/access/role_permissions.dart';
import '../../../../core/access/role_preview_cubit.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/enums/admin_permission.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../../core/resources/strings/app_strings.dart';
import '../../../../core/resources/strings/settings_strings.dart';
import '../../../../core/utils/app_messenger.dart';
import '../../../../core/widgets/admin_shell/admin_section.dart';
import '../../../../core/widgets/admin_shell/admin_shell.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_confirm_dialog.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_list_skeleton.dart';
import '../../../../core/widgets/app_refresh_button.dart';
import '../../../../core/widgets/app_segmented_tabs.dart';
import '../../../auth/presentation/state/admin_session_cubit.dart';
import '../../../auth/presentation/state/auth_cubit.dart';
import '../../../auth/presentation/widgets/admin_permission_context.dart';
import '../../data/models/admin_account.dart';
import '../../data/models/platform_settings.dart';
import '../state/platform_branding_cubit.dart';
import '../state/settings_cubit.dart';
import '../state/settings_state.dart';
// import '../widgets/account_security_card.dart';
import '../widgets/activity_logs_tab.dart';
import '../widgets/admin_staff_tab.dart';
import '../widgets/platform_settings_tab.dart';
import '../widgets/roles_permissions_tab.dart';
import '../widgets/admin_profile_card.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key, this.initialTab = SettingsTab.adminProfile});

  final SettingsTab initialTab;

  static const double _twoColumnBreakpoint = 1000;

  static const Set<SettingsTab> _builtTabs = {
    SettingsTab.adminProfile,
    SettingsTab.adminStaff,
    SettingsTab.roles,
    SettingsTab.platform,
    SettingsTab.activity,
  };

  static const Set<SettingsTab> _platformTabs = {
    SettingsTab.platform,
    SettingsTab.activity,
  };

  void _notBuilt(BuildContext context, String label) =>
      context.showAppMessage(AppStrings.sectionNotBuilt(label));

  Future<void> _logout(BuildContext context) async {
    final AuthCubit auth = context.read<AuthCubit>();
    final bool confirmed = await AppConfirmDialog.show(
      context,
      title: AppStrings.logOutTitle,
      message: AppStrings.logOutMessage,
      confirmLabel: AppStrings.logOut,
      cancelLabel: AppStrings.cancel,
    );
    if (!confirmed) return;
    await auth.signOut();
  }

  Future<void> _savePlatform(BuildContext context) async {
    final SettingsCubit cubit = context.read<SettingsCubit>();
    final String updatedBy =
        context.read<AdminSessionCubit>().state.account?.email ?? '';
    final result = await cubit.savePlatform(updatedBy: updatedBy);
    if (!context.mounted) return;
    if (result.error case final String error) {
      context.showAppMessage(error);
    } else if (result.saved) {
      if (cubit.state.platform case final PlatformSettings saved) {
        context.read<PlatformBrandingCubit>().apply(saved.platformName);
      }
      context.showAppMessage(SettingsStrings.settingsSaved);
    }
  }

  Future<void> _saveRoles(BuildContext context) async {
    final SettingsCubit cubit = context.read<SettingsCubit>();
    final String updatedBy =
        context.read<AdminSessionCubit>().state.account?.email ?? '';
    final bool confirmed = await AppConfirmDialog.show(
      context,
      title: SettingsStrings.savePermissionsTitle,
      message: SettingsStrings.savePermissionsMessage,
      confirmLabel: SettingsStrings.saveChanges,
      cancelLabel: AppStrings.cancel,
    );
    if (!confirmed || !context.mounted) return;
    final result = await cubit.saveRoles(updatedBy: updatedBy);
    if (!context.mounted) return;
    if (result.error case final String error) {
      context.showAppMessage(error);
    } else if (result.updatedAdmins case final int count) {
      context.showAppMessage(SettingsStrings.permissionsSaved(count));
    }
  }

  void _updatePassword(
    BuildContext context,
    String current,
    String newPassword,
    String confirm,
  ) {
    final bool updated = context.read<SettingsCubit>().updatePassword(
      current: current,
      newPassword: newPassword,
      confirm: confirm,
    );
    if (updated) context.showAppMessage(SettingsStrings.passwordUpdated);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SettingsCubit>(
        param1: _builtTabs.contains(initialTab)
            ? initialTab
            : SettingsTab.adminProfile,
      )..load(),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          final SettingsCubit cubit = context.read<SettingsCubit>();
          final DateTime? updatedAt = state.updatedAt;
          final bool canManagePlatform = context.canPerform(
            AdminPermission.platformSettings,
          );
          return AdminShell(
            section: AdminSection.settings,
            title: SettingsStrings.title,
            subtitle: SettingsStrings.subtitle,
            headerActions: [
              if (updatedAt != null)
                AppRefreshButton(updatedAt: updatedAt, onPressed: cubit.load),
            ],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: AppSegmentedTabs(
                    labels: SettingsStrings.tabs,
                    selectedIndex: state.tab.index,
                    onSelected: (index) {
                      final SettingsTab tab = SettingsTab.values[index];
                      if (_platformTabs.contains(tab) && !canManagePlatform) {
                        context.showAppMessage(SettingsStrings.platformDenied);
                      } else if (_builtTabs.contains(tab)) {
                        cubit.selectTab(tab);
                      } else {
                        _notBuilt(context, SettingsStrings.tabs[index]);
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16),
                if (_platformTabs.contains(state.tab) && !canManagePlatform)
                  const AppCard(
                    child: AppEmptyState(
                      icon: Icons.lock_outline_rounded,
                      title: SettingsStrings.platformDeniedTitle,
                      message: SettingsStrings.platformDenied,
                    ),
                  )
                else if (state.tab == SettingsTab.activity)
                  ActivityLogsTab(
                    entries: state.visibleLogs,
                    actors: state.logActors,
                    query: state.logQuery,
                    selectedActor: state.logActor,
                    onSearch: cubit.searchLogs,
                    onActorChanged: cubit.filterLogsByActor,
                  )
                else if (state.tab == SettingsTab.platform &&
                    state.platformStatus == PlatformStatus.failure &&
                    state.platform == null)
                  AppCard(
                    child: AppEmptyState(
                      icon: Icons.error_outline_rounded,
                      title: SettingsStrings.platformLoadFailed,
                      message:
                          state.platformError ?? AppStrings.recordsLoadFailed,
                      actionLabel: AppStrings.retry,
                      onAction: cubit.loadPlatform,
                    ),
                  )
                else if (state.tab == SettingsTab.platform &&
                    (state.platform == null || state.appVersions == null))
                  const AppListSkeleton()
                else if (state.tab == SettingsTab.platform)
                  PlatformSettingsTab(
                    key: ValueKey(state.platformVersion),
                    settings: state.platform!,
                    versions: state.appVersions!,
                    errors: state.platformErrors,
                    isSaving: state.isSavingPlatform,
                    onEdit: cubit.editPlatform,
                    onSave: () => _savePlatform(context),
                  )
                else if (state.tab == SettingsTab.roles)
                  RolesPermissionsTab(
                    adminCountOf: state.activeAdminsWith,
                    onPreview: (role) {
                      final RolePermissions? permissions = state.roleDraft;
                      if (permissions == null) return;
                      context.read<RolePreviewCubit>().start(
                        role,
                        permissions.sectionsFor(role),
                      );
                    },
                    permissions: state.roleDraft,
                    canEdit: context.select<AdminSessionCubit, bool>(
                      (session) =>
                          session.state.account?.hasAllModules ?? false,
                    ),
                    hasChanges: state.hasRoleChanges,
                    isSaving: state.isSavingRoles,
                    isLoading: state.rolesStatus == RolesStatus.loading,
                    errorMessage: state.rolesStatus == RolesStatus.failure
                        ? state.rolesError ?? AppStrings.recordsLoadFailed
                        : null,
                    onRetry: cubit.loadRoles,
                    onToggle: cubit.toggleRolePermission,
                    onDiscard: cubit.discardRoleChanges,
                    onSave: () => _saveRoles(context),
                  )
                else if (state.tab == SettingsTab.adminStaff)
                  AdminStaffTab(
                    staff: state.visibleStaff,
                    query: state.staffQuery,
                    isLoading: state.staffStatus == StaffStatus.loading,
                    isSearching: state.isSearchingStaff,
                    errorMessage: state.staffStatus == StaffStatus.failure
                        ? state.staffError ?? AppStrings.recordsLoadFailed
                        : state.staffSearchError,
                    onRetry: state.staffStatus == StaffStatus.failure
                        ? cubit.loadStaff
                        : cubit.retryStaffSearch,
                    onSearch: cubit.searchStaff,
                    onAddAdmin: () async {
                      await Navigator.of(context).pushNamed(AppRoutes.addAdmin);
                      cubit.syncStaff();
                    },
                    onManage: (member) async {
                      await Navigator.of(context)
                          .pushNamed(AppRoutes.manageAdminFor(member.adminId));
                      cubit.syncProfile();
                    },
                  )
                else
                  _ProfileTab(
                    state: state,
                    onRetry: cubit.loadProfile,
                    breakpoint: _twoColumnBreakpoint,
                    onEditProfile: () async {
                      await Navigator.of(context)
                          .pushNamed(AppRoutes.editProfile);
                      cubit.syncProfile();
                    },
                    onFieldChanged: cubit.clearPasswordErrors,
                    onUpdatePassword: (current, newPassword, confirm) =>
                        _updatePassword(context, current, newPassword, confirm),
                    onLogout: _logout,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab({
    required this.state,
    required this.onRetry,
    required this.breakpoint,
    required this.onEditProfile,
    required this.onFieldChanged,
    required this.onUpdatePassword,
    required this.onLogout,
  });

  final SettingsState state;
  final VoidCallback onRetry;
  final double breakpoint;
  final VoidCallback onEditProfile;
  final VoidCallback onFieldChanged;
  final void Function(String current, String newPassword, String confirm)
  onUpdatePassword;
  final ValueChanged<BuildContext> onLogout;

  @override
  Widget build(BuildContext context) {
    final AdminAccount? account = state.account;
    if (account == null) {
      return state.profileStatus == ProfileStatus.failure
          ? AppCard(
              child: AppEmptyState(
                icon: Icons.error_outline_rounded,
                title: SettingsStrings.profileLoadFailed,
                message: state.profileError ?? AppStrings.recordsLoadFailed,
                actionLabel: AppStrings.retry,
                onAction: onRetry,
              ),
            )
          : const Padding(
              padding: EdgeInsets.all(48),
              child: Center(child: CircularProgressIndicator()),
            );
    }
    final Widget profile = AdminProfileCard(
      account: account,
      onEditProfile: onEditProfile,
    );
    // final Widget security = AccountSecurityCard(
    //   isTwoStepEnabled: account.isTwoStepEnabled,
    //   errors: state.passwordErrors,
    //   formVersion: state.passwordFormVersion,
    //   onFieldChanged: onFieldChanged,
    //   onUpdatePassword: onUpdatePassword,
    //   onLogout: () => onLogout(context),
    // );
    // return LayoutBuilder(
    //   builder: (context, constraints) {
    //     if (constraints.maxWidth < breakpoint) {
    //       return Column(
    //         crossAxisAlignment: CrossAxisAlignment.stretch,
    //         children: [profile, const SizedBox(height: 16), security],
    //       );
    //     }
    //     return Row(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Expanded(flex: 7, child: profile),
    //         const SizedBox(width: 16),
    //         Expanded(flex: 4, child: security),
    //       ],
    //     );
    //   },
    // );
    return profile;
  }
}
