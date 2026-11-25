import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/resources/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../state/account_recovery_cubit.dart';
import '../state/account_recovery_state.dart';

class AccountRecoveryForm extends StatefulWidget {
  const AccountRecoveryForm({super.key, required this.onBackToSignIn});

  final VoidCallback onBackToSignIn;

  @override
  State<AccountRecoveryForm> createState() => _AccountRecoveryFormState();
}

class _AccountRecoveryFormState extends State<AccountRecoveryForm> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit() =>
      context.read<AccountRecoveryCubit>().submit(_emailController.text);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountRecoveryCubit, AccountRecoveryState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: _BackToSignInLink(onTap: widget.onBackToSignIn),
            ),
            const SizedBox(height: 28),
            Text(AppStrings.accountRecovery, style: AppTextStyles.headingLarge),
            const SizedBox(height: 10),
            Text(
              AppStrings.accountRecoverySubtitle,
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 28),
            AppTextField(
              label: AppStrings.workEmail,
              hintText: AppStrings.workEmailHint,
              controller: _emailController,
              errorText: state.emailError,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.email],
              onChanged: (_) =>
                  context.read<AccountRecoveryCubit>().emailChanged(),
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 24),
            AppPrimaryButton(
              label: AppStrings.sendResetLink,
              isLoading: state.status == AccountRecoveryStatus.submitting,
              onPressed: _submit,
            ),
            const SizedBox(height: 20),
            Text(
              AppStrings.accountRecoveryMfaNote,
              style: AppTextStyles.bodySmall,
            ),
          ],
        );
      },
    );
  }
}

class _BackToSignInLink extends StatelessWidget {
  const _BackToSignInLink({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.chevron_left,
              size: 18,
              color: AppColors.textPrimary,
            ),
            const SizedBox(width: 4),
            Text(AppStrings.backToSignIn, style: AppTextStyles.link),
          ],
        ),
      ),
    );
  }
}
