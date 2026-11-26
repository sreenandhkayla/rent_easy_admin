import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/navigation/app_routes.dart';
import '../state/admin_session_cubit.dart';
import '../state/admin_session_state.dart';
import '../state/auth_cubit.dart';
import '../state/auth_state.dart';
import '../widgets/auth_split_layout.dart';
import '../widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  void _openHome(BuildContext context, AdminSessionState state) {
    final route = state.account?.homeRoute;
    if (route != null) Navigator.pushReplacementNamed(context, route);
  }

  void _onAuthChanged(BuildContext context, AuthState state) {
    if (state.status != AuthStatus.success) return;
    if (state.account case final account?) {
      context.read<AdminSessionCubit>().signedIn(account);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthCubit>(),
      child: MultiBlocListener(
        listeners: [
          BlocListener<AdminSessionCubit, AdminSessionState>(
            listenWhen: (_, state) =>
                state.status == AdminSessionStatus.signedIn,
            listener: _openHome,
          ),
          BlocListener<AuthCubit, AuthState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: _onAuthChanged,
          ),
        ],
        child: AuthSplitLayout(
          child: LoginForm(
            onForgotPassword: () =>
                Navigator.of(context).pushNamed(AppRoutes.accountRecovery),
          ),
        ),
      ),
    );
  }
}
