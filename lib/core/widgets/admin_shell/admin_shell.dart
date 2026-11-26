import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/auth/presentation/state/admin_session_cubit.dart';
import '../../../features/auth/presentation/state/auth_cubit.dart';
import '../../../features/auth/presentation/state/auth_state.dart';
import '../../access/role_preview_cubit.dart';
import '../../data/admin_record.dart';
import '../../di/injection.dart';
import '../../utils/app_messenger.dart';
import '../../enums/admin_permission.dart';
import '../../enums/admin_role.dart';

import '../../navigation/app_routes.dart';
import '../../resources/strings/app_strings.dart';
import '../../theme/app_colors.dart';
import '../app_confirm_dialog.dart';
import '../app_permission_denied.dart';
import 'admin_content_transition.dart';
import 'admin_navigation.dart';
import 'admin_preview_banner.dart';
import 'admin_section.dart';
import 'admin_sidebar.dart';
import 'admin_top_bar.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({
    super.key,
    required this.section,
    required this.title,
    required this.subtitle,
    this.breadcrumb,
    this.isSectionRoot = true,
    required this.child,
    this.headerActions = const [],
    this.badgeCounts = AdminBadgeCounts.sample,
  });

  final AdminSection section;
  final String title;
  final String subtitle;
  final Widget? breadcrumb;
  final bool isSectionRoot;
  final Widget child;
  final List<Widget> headerActions;
  final Map<AdminSection, int> badgeCounts;

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  static const double _autoCollapseBreakpoint = 1000;

  static bool? _isCollapsedByUser;

  void _select(AdminSection section) {
    if (section == widget.section && !widget.isSectionRoot) {
      returnToSection(context, section);
      return;
    }
    openAdminSection(context, section, current: widget.section);
  }

  Future<void> _confirmLogout(BuildContext context) async {
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

  void _onAuthChanged(BuildContext context, AuthState state) {
    if (state.status == AuthStatus.signedOut) {
      context.read<AdminSessionCubit>().signedOut();
      return;
    }
    if (state.errorMessage case final message?) {
      context.showAppMessage(message);
    }
  }

  Widget _content(AdminRole? previewRole) {
    final AdminPermission? permission = widget.section.permission;
    if (previewRole == null ||
        permission == null ||
        permission.isGranted(previewRole)) {
      return widget.child;
    }
    final RolePreviewCubit preview = context.read<RolePreviewCubit>();
    return AppPermissionDenied(
      roleLabel: previewRole.label,
      accessSummary: widget.section.accessSummary,
      onBackToDashboard: () =>
          Navigator.of(context)
              .pushNamedAndRemoveUntil(AppRoutes.dashboard, (_) => false),
      onExitPreview: preview.exit,
    );
  }

  @override
  Widget build(BuildContext context) {
    final AdminRole? previewRole = context.watch<RolePreviewCubit>().state;
    return BlocProvider<AuthCubit>(
      create: (_) => getIt<AuthCubit>(),
      child: BlocListener<AuthCubit, AuthState>(
        listener: _onAuthChanged,
        child: _buildScaffold(previewRole),
      ),
    );
  }

  Widget _buildScaffold(AdminRole? previewRole) {
    final AdminRecord? account = context
        .select<AdminSessionCubit, AdminRecord?>(
          (session) => session.state.account,
        );
    final String profileName = account?.name ?? AdminProfile.current.name;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.contentBackground,
        body: LayoutBuilder(
          builder: (context, constraints) {
            final bool isCollapsed =
                _isCollapsedByUser ??
                constraints.maxWidth < _autoCollapseBreakpoint;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AdminSidebar(
                  sections: account?.accessibleSections ?? AdminSection.values,
                  selected: widget.section,
                  isCollapsed: isCollapsed,
                  badgeCounts: widget.badgeCounts,
                  onToggleCollapsed: () =>
                      setState(() => _isCollapsedByUser = !isCollapsed),
                  onSelect: _select,
                  onLogout: () => _confirmLogout(context),
                  profileName: profileName,
                  profileRole:
                      previewRole?.label ??
                      account?.role.label ??
                      AdminProfile.current.role,
                ),
                Expanded(
                  child: SafeArea(
                    left: false,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (previewRole != null) ...[
                            AdminPreviewBanner(
                              roleLabel: previewRole.label,
                              onExit: context.read<RolePreviewCubit>().exit,
                            ),
                            const SizedBox(height: 20),
                          ],
                          AdminTopBar(
                            title: widget.title,
                            subtitle: widget.subtitle,
                            profileName: profileName,
                            breadcrumb: widget.breadcrumb,
                            actions: widget.headerActions,
                            hasUnreadNotifications: true,
                            onNotifications: () =>
                                _select(AdminSection.notifications),
                          ),
                          const SizedBox(height: 24),
                          AdminContentTransition(child: _content(previewRole)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
