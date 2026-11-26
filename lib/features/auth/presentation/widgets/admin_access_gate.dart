import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/navigation/app_routes.dart';
import '../../../../core/resources/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/admin_shell/admin_section.dart';
import '../../../../core/widgets/admin_shell/admin_shell.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../state/admin_session_cubit.dart';
import '../state/admin_session_state.dart';

class AdminAccessGate extends StatelessWidget {
  const AdminAccessGate({
    super.key,
    required this.section,
    required this.child,
  });

  final AdminSection section;
  final Widget child;

  bool _allowed(AdminSessionState state) =>
      state.account?.canAccess(section) ?? false;

  void _onBack(BuildContext context, bool didPop) {
    if (didPop) return;
    final route = ModalRoute.of(context);
    if (route == null || !route.isFirst) return;
    final home = context.read<AdminSessionCubit>().state.account?.homeRoute;
    if (home == null || home == route.settings.name) return;
    Navigator.of(context).pushReplacementNamed(home);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope<Object?>(
      onPopInvokedWithResult: (didPop, _) => _onBack(context, didPop),
      child: _buildGate(context),
    );
  }

  Widget _buildGate(BuildContext context) {
    return BlocBuilder<AdminSessionCubit, AdminSessionState>(
      buildWhen: (previous, current) =>
          previous.status != current.status ||
          _allowed(previous) != _allowed(current),
      builder: (context, state) => switch (state.status) {
        AdminSessionStatus.loading => const _GateScaffold(
          child: Center(child: CircularProgressIndicator()),
        ),
        AdminSessionStatus.failure => _GateScaffold(
          child: AppEmptyState(
            icon: Icons.error_outline_rounded,
            title: AppStrings.sessionCheckFailed,
            message: state.errorMessage ?? AppStrings.recordsLoadFailed,
            actionLabel: AppStrings.retry,
            onAction: context.read<AdminSessionCubit>().restore,
          ),
        ),
        AdminSessionStatus.signedOut => const _LoginRedirect(),
        AdminSessionStatus.signedIn when _allowed(state) => child,
        AdminSessionStatus.signedIn => AdminShell(
          section: section,
          title: section.label,
          subtitle: section.accessSummary,
          child: const AppEmptyState(
            icon: Icons.lock_outline_rounded,
            title: AppStrings.noModuleAccessTitle,
            message: AppStrings.noModuleAccessMessage,
          ),
        ),
      },
    );
  }
}

class _GateScaffold extends StatelessWidget {
  const _GateScaffold({required this.child});

  static const double _maxWidth = 480;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.contentBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _maxWidth),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginRedirect extends StatefulWidget {
  const _LoginRedirect();

  @override
  State<_LoginRedirect> createState() => _LoginRedirectState();
}

class _LoginRedirectState extends State<_LoginRedirect> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !(ModalRoute.of(context)?.isCurrent ?? false)) return;
      Navigator.of(context)
          .pushNamedAndRemoveUntil(AppRoutes.login, (_) => false);
    });
  }

  @override
  Widget build(BuildContext context) =>
      const Scaffold(backgroundColor: AppColors.contentBackground);
}
