import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/access/role_preview_cubit.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../../core/resources/strings/app_strings.dart';
import '../../../../core/resources/strings/settings_strings.dart';
import '../../../../core/utils/app_messenger.dart';
import '../../../../core/widgets/admin_shell/admin_section.dart';
import '../../../../core/widgets/admin_shell/admin_shell.dart';
import '../../../../core/widgets/app_confirm_dialog.dart';
import '../../../../core/widgets/app_refresh_button.dart';
import '../../../../core/widgets/app_segmented_tabs.dart';
import '../../data/models/admin_account.dart';
import '../state/settings_cubit.dart';
import '../state/settings_state.dart';
import '../widgets/account_security_card.dart';
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

  void _notBuilt(BuildContext context, String label) =>
      context.showAppMessage(AppStrings.sectionNotBuilt(label));

  Future<void> _logout(BuildContext context) async {
    final NavigatorState navigator = Navigator.of(context);
    final bool confirmed = await AppConfirmDialog.show(
      context,
      title: AppStrings.logOutTitle,
      message: AppStrings.logOutMessage,
      confirmLabel: AppStrings.logOut,
      cancelLabel: AppStrings.cancel,
    );
    if (!confirmed) return;
    navigator.pushNamedAndRemoveUntil(AppRoutes.login, (_) => false);
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
      create: (_) => SettingsCubit(
        initialTab: _builtTabs.contains(initialTab)
            ? initialTab
            : SettingsTab.adminProfile,
      )..load(),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          final SettingsCubit cubit = context.read<SettingsCubit>();
          final DateTime? updatedAt = state.updatedAt;
          final AdminAccount? account = state.account;
          return AdminShell(
            section: AdminSection.settings,
            title: SettingsStrings.title,
            subtitle: SettingsStrings.subtitle,
            headerActions: [
              if (updatedAt != null)
                AppRefreshButton(updatedAt: updatedAt, onPressed: cubit.load),
            ],
            child: account == null
                ? const Padding(
                    padding: EdgeInsets.all(48),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: AppSegmentedTabs(
                          labels: SettingsStrings.tabs,
                          selectedIndex: state.tab.index,
                          onSelected: (index) {
                            final SettingsTab tab = SettingsTab.values[index];
                            if (_builtTabs.contains(tab)) {
                              cubit.selectTab(tab);
                            } else {
                              _notBuilt(context, SettingsStrings.tabs[index]);
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (state.tab == SettingsTab.activity)
                        ActivityLogsTab(
                          entries: state.visibleLogs,
                          actors: state.logActors,
                          query: state.logQuery,
                          selectedActor: state.logActor,
                          onSearch: cubit.searchLogs,
                          onActorChanged: cubit.filterLogsByActor,
                        )
                      else if (state.tab == SettingsTab.platform &&
                          state.platform != null &&
                          state.appVersions != null)
                        PlatformSettingsTab(
                          settings: state.platform!,
                          versions: state.appVersions!,
                          errors: state.platformErrors,
                          onEdit: cubit.editPlatform,
                          onSave: () {
                            if (cubit.savePlatform()) {
                              context.showAppMessage(
                                SettingsStrings.settingsSaved,
                              );
                            }
                          },
                        )
                      else if (state.tab == SettingsTab.roles)
                        RolesPermissionsTab(
                          adminCountOf: state.activeAdminsWith,
                          onPreview: context.read<RolePreviewCubit>().start,
                        )
                      else if (state.tab == SettingsTab.adminStaff)
                        AdminStaffTab(
                          staff: state.visibleStaff,
                          query: state.staffQuery,
                          onSearch: cubit.searchStaff,
                          onAddAdmin: () async {
                            await Navigator.of(context)
                                .pushNamed(AppRoutes.addAdmin);
                            cubit.syncStaff();
                          },
                          onManage: (member) async {
                            await Navigator.of(context).pushNamed(
                              AppRoutes.manageAdminFor(member.adminId),
                            );
                            cubit.syncProfile();
                          },
                        )
                      else
                        _ProfileTab(
                          account: account,
                          state: state,
                          breakpoint: _twoColumnBreakpoint,
                          onEditProfile: () async {
                            await Navigator.of(context)
                                .pushNamed(AppRoutes.editProfile);
                            cubit.syncProfile();
                          },
                          onFieldChanged: cubit.clearPasswordErrors,
                          onUpdatePassword: (current, newPassword, confirm) =>
                              _updatePassword(
                                context,
                                current,
                                newPassword,
                                confirm,
                              ),
                          onLogout: () => _logout(context),
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
    required this.account,
    required this.state,
    required this.breakpoint,
    required this.onEditProfile,
    required this.onFieldChanged,
    required this.onUpdatePassword,
    required this.onLogout,
  });

  final AdminAccount account;
  final SettingsState state;
  final double breakpoint;
  final VoidCallback onEditProfile;
  final VoidCallback onFieldChanged;
  final void Function(String current, String newPassword, String confirm)
  onUpdatePassword;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final Widget profile = AdminProfileCard(
      account: account,
      onEditProfile: onEditProfile,
    );
    final Widget security = AccountSecurityCard(
      isTwoStepEnabled: account.isTwoStepEnabled,
      errors: state.passwordErrors,
      formVersion: state.passwordFormVersion,
      onFieldChanged: onFieldChanged,
      onUpdatePassword: onUpdatePassword,
      onLogout: onLogout,
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < breakpoint) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [profile, const SizedBox(height: 16), security],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 7, child: profile),
            const SizedBox(width: 16),
            Expanded(flex: 4, child: security),
          ],
        );
      },
    );
  }
}
