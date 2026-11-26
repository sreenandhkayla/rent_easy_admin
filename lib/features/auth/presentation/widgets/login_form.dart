import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/resources/strings/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../state/auth_cubit.dart';
import '../state/auth_state.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key, required this.onForgotPassword});

  final VoidCallback onForgotPassword;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    context.read<AuthCubit>().signIn(
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final AuthCubit cubit = context.read<AuthCubit>();
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return AutofillGroup(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(AppStrings.signIn, style: AppTextStyles.headingLarge),
              const SizedBox(height: 10),
              Text(AppStrings.signInSubtitle, style: AppTextStyles.bodyMedium),
              const SizedBox(height: 28),
              AppTextField(
                label: AppStrings.workEmail,
                hintText: AppStrings.workEmailHint,
                controller: _emailController,
                errorText: state.emailError,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                onChanged: (_) => cubit.emailChanged(),
              ),
              const SizedBox(height: 20),
              AppTextField(
                label: AppStrings.password,
                hintText: AppStrings.passwordHint,
                controller: _passwordController,
                errorText: state.passwordError,
                obscureText: true,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.password],
                onChanged: (_) => cubit.passwordChanged(),
                onSubmitted: (_) => _submit(),
                // trailingLabel: _ForgotPasswordLink(
                //   onTap: widget.onForgotPassword,
                // ),
              ),
              const SizedBox(height: 24),
              AppPrimaryButton(
                label: AppStrings.continueLabel,
                isLoading: state.isLoading,
                onPressed: _submit,
              ),
              if (state.errorMessage case final String message) ...[
                const SizedBox(height: 20),
                Text(message, style: AppTextStyles.fieldError),
              ],
            ],
          ),
        );
      },
    );
  }
}

// class _ForgotPasswordLink extends StatelessWidget {
//   const _ForgotPasswordLink({required this.onTap});
//
//   final VoidCallback onTap;
//
//   @override
//   Widget build(BuildContext context) {
//     return MouseRegion(
//       cursor: SystemMouseCursors.click,
//       child: GestureDetector(
//         onTap: onTap,
//         child: Text(AppStrings.forgotPassword, style: AppTextStyles.link),
//       ),
//     );
//   }
// }
