import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/resources/strings/app_strings.dart';
import '../../../../core/resources/strings/settings_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_dialog_frame.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_secondary_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../state/change_password_cubit.dart';
import '../state/change_password_state.dart';

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});

  static Future<bool> show(BuildContext context) async {
    final bool? changed = await showDialog<bool>(
      context: context,
      barrierColor: AppColors.scrim,
      builder: (_) => BlocProvider(
        create: (_) => getIt<ChangePasswordCubit>(),
        child: const ChangePasswordDialog(),
      ),
    );
    return changed ?? false;
  }

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final TextEditingController _current = TextEditingController();
  final TextEditingController _new = TextEditingController();
  final TextEditingController _confirm = TextEditingController();

  @override
  void dispose() {
    _current.dispose();
    _new.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final bool changed = await context.read<ChangePasswordCubit>().submit(
      current: _current.text,
      newPassword: _new.text,
      confirm: _confirm.text,
    );
    if (changed && mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
      builder: (context, state) {
        final ChangePasswordCubit cubit = context.read<ChangePasswordCubit>();
        void close() {
          if (!state.isSaving) Navigator.of(context).pop(false);
        }

        return AppDialogFrame(
          title: SettingsStrings.changePassword,
          onClose: close,
          body: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  SettingsStrings.changePasswordMessage,
                  style: AppTextStyles.bodySmall,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: SettingsStrings.currentPassword,
                  controller: _current,
                  obscureText: true,
                  autofillHints: const [AutofillHints.password],
                  textInputAction: TextInputAction.next,
                  errorText: state.currentError,
                  onChanged: (_) => cubit.clearErrors(),
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: SettingsStrings.newPassword,
                  controller: _new,
                  obscureText: true,
                  autofillHints: const [AutofillHints.newPassword],
                  textInputAction: TextInputAction.next,
                  helperText: SettingsStrings.newPasswordHelper,
                  errorText: state.newPasswordError,
                  onChanged: (_) => cubit.clearErrors(),
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: SettingsStrings.confirmNewPassword,
                  controller: _confirm,
                  obscureText: true,
                  autofillHints: const [AutofillHints.newPassword],
                  textInputAction: TextInputAction.done,
                  errorText: state.confirmError,
                  onChanged: (_) => cubit.clearErrors(),
                  onSubmitted: (_) => _submit(),
                ),
                if (state.errorMessage case final String message) ...[
                  const SizedBox(height: 12),
                  Text(message, style: AppTextStyles.fieldError),
                ],
              ],
            ),
          ),
          actions: [
            AppSecondaryButton(
              label: AppStrings.cancel,
              onPressed: state.isSaving ? null : close,
            ),
            AppPrimaryButton(
              label: SettingsStrings.updatePassword,
              isCompact: true,
              isLoading: state.isSaving,
              onPressed: _submit,
            ),
          ],
        );
      },
    );
  }
}
