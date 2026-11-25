import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/navigation/app_routes.dart';
import '../state/login_cubit.dart';
import '../state/login_state.dart';
import '../widgets/auth_split_layout.dart';
import '../widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(),
      child: BlocListener<LoginCubit, LoginState>(
        listenWhen: (previous, current) =>
            previous.status != current.status &&
            current.status == LoginStatus.success,
        listener: (context, _) =>
            Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard),
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
