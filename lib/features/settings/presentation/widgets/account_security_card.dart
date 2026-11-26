import 'package:flutter/material.dart';

import '../../../../core/resources/strings/app_strings.dart';
import '../../../../core/resources/strings/settings_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_secondary_button.dart';
import '../../../../core/widgets/app_status_pill.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../state/settings_state.dart';

class AccountSecurityCard extends StatelessWidget {
  const AccountSecurityCard({
    super.key,
    required this.isTwoStepEnabled,
    required this.errors,
    required this.formVersion,
    required this.onFieldChanged,
    required this.onUpdatePassword,
    required this.onLogout,
  });

  final bool isTwoStepEnabled;
  final PasswordErrors errors;
  final int formVersion;
  final VoidCallback onFieldChanged;
  final void Function(String current, String newPassword, String confirm)
  onUpdatePassword;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            SettingsStrings.accountSecurity,
            style: AppTextStyles.cardTitle,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      SettingsStrings.twoStepVerification,
                      style: AppTextStyles.titleSmall,
                    ),
                    SizedBox(height: 2),
                    Text(
                      SettingsStrings.twoStepNote,
                      style: AppTextStyles.meta,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              isTwoStepEnabled
                  ? const AppStatusPill(
                      label: SettingsStrings.on,
                      color: AppColors.statusGreen,
                      backgroundColor: AppColors.pillGreenBackground,
                    )
                  : const AppStatusPill(
                      label: SettingsStrings.off,
                      color: AppColors.textSecondary,
                      backgroundColor: AppColors.iconCircle,
                    ),
            ],
          ),
          const Divider(height: 32, color: AppColors.divider),
          const Text(
            SettingsStrings.changePassword,
            style: AppTextStyles.titleSmall,
          ),
          const SizedBox(height: 14),
          _PasswordForm(
            key: ValueKey(formVersion),
            errors: errors,
            onFieldChanged: onFieldChanged,
            onSubmit: onUpdatePassword,
          ),
          const SizedBox(height: 10),
          AppSecondaryButton(
            label: AppStrings.logOut,
            icon: Icons.logout,
            isDestructive: true,
            isExpanded: true,
            labelStyle: AppTextStyles.actionLabel,
            onPressed: onLogout,
          ),
        ],
      ),
    );
  }
}

class _PasswordForm extends StatefulWidget {
  const _PasswordForm({
    super.key,
    required this.errors,
    required this.onFieldChanged,
    required this.onSubmit,
  });

  final PasswordErrors errors;
  final VoidCallback onFieldChanged;
  final void Function(String current, String newPassword, String confirm)
  onSubmit;

  @override
  State<_PasswordForm> createState() => _PasswordFormState();
}

class _PasswordFormState extends State<_PasswordForm> {
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

  void _submit() => widget.onSubmit(_current.text, _new.text, _confirm.text);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          label: SettingsStrings.currentPassword,
          controller: _current,
          obscureText: true,
          autofillHints: const [AutofillHints.password],
          textInputAction: TextInputAction.next,
          errorText: widget.errors.current,
          onChanged: (_) => widget.onFieldChanged(),
        ),
        const SizedBox(height: 16),
        AppTextField(
          label: SettingsStrings.newPassword,
          controller: _new,
          obscureText: true,
          autofillHints: const [AutofillHints.newPassword],
          textInputAction: TextInputAction.next,
          helperText: SettingsStrings.newPasswordHelper,
          errorText: widget.errors.newPassword,
          onChanged: (_) => widget.onFieldChanged(),
        ),
        const SizedBox(height: 16),
        AppTextField(
          label: SettingsStrings.confirmNewPassword,
          controller: _confirm,
          obscureText: true,
          autofillHints: const [AutofillHints.newPassword],
          textInputAction: TextInputAction.done,
          errorText: widget.errors.confirm,
          onChanged: (_) => widget.onFieldChanged(),
          onSubmitted: (_) => _submit(),
        ),
        const SizedBox(height: 16),
        AppPrimaryButton(
          label: SettingsStrings.updatePassword,
          isCompact: true,
          labelStyle: AppTextStyles.actionLabel,
          onPressed: _submit,
        ),
      ],
    );
  }
}
