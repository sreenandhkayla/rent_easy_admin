import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/navigation/app_routes.dart';
import '../../../../core/resources/strings/app_strings.dart';
import '../state/account_recovery_cubit.dart';
import '../state/account_recovery_state.dart';
import '../widgets/account_recovery_form.dart';
import '../widgets/auth_split_layout.dart';

class AccountRecoveryPage extends StatelessWidget {
  const AccountRecoveryPage({super.key});

  void _backToSignIn(BuildContext context) {
    final NavigatorState navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
    } else {
      navigator.pushReplacementNamed(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AccountRecoveryCubit(),
      child: BlocListener<AccountRecoveryCubit, AccountRecoveryState>(
        listenWhen: (previous, current) =>
            previous.status != current.status &&
            current.status == AccountRecoveryStatus.success,
        listener: (context, _) => ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(content: Text(AppStrings.resetLinkPending)),
          ),
        child: AuthSplitLayout(
          child: AccountRecoveryForm(
            onBackToSignIn: () => _backToSignIn(context),
          ),
        ),
      ),
    );
  }
}
