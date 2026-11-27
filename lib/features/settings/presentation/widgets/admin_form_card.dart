import 'package:flutter/material.dart';

import '../../../../core/resources/strings/settings_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_radio_card.dart';
import '../../../../core/widgets/app_secondary_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_toggle_row.dart';
import '../../../../core/enums/admin_role.dart';
import '../state/admin_form_state.dart';

class AdminFormCard extends StatefulWidget {
  const AdminFormCard({
    super.key,
    required this.state,
    required this.onNameChanged,
    this.onEmailChanged,
    this.onPasswordChanged,
    required this.onRoleChanged,
    required this.onActiveChanged,
    required this.onCancel,
    required this.onSave,
    required this.saveLabel,
    this.formError,
  });

  final AdminFormState state;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String>? onEmailChanged;
  final ValueChanged<String>? onPasswordChanged;
  final ValueChanged<AdminRole> onRoleChanged;
  final ValueChanged<bool> onActiveChanged;
  final VoidCallback onCancel;
  final VoidCallback onSave;
  final String saveLabel;
  final String? formError;

  @override
  State<AdminFormCard> createState() => _AdminFormCardState();
}

class _AdminFormCardState extends State<AdminFormCard> {
  static const double _stackBreakpoint = 520;

  late final TextEditingController _name = TextEditingController(
    text: widget.state.name,
  );
  late final TextEditingController _email = TextEditingController(
    text: widget.state.email,
  );

  late final TextEditingController _password = TextEditingController(
    text: widget.state.password,
  );

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  String? get _emailError {
    final AdminFormState state = widget.state;
    if (state.showEmailInvalid) return SettingsStrings.emailInvalid;
    if (state.isEmailTaken) return SettingsStrings.emailTaken;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final AdminFormState state = widget.state;
    final String? formError = widget.formError;
    final Widget name = AppTextField(
      controller: _name,
      label: SettingsStrings.fullNameLabel,
      hintText: SettingsStrings.fullNameHint,
      textInputAction: TextInputAction.next,
      errorText: state.showNameError ? SettingsStrings.nameRequired : null,
      onChanged: widget.onNameChanged,
    );
    final Widget email = AppTextField(
      controller: _email,
      label: SettingsStrings.workEmailLabel,
      hintText: SettingsStrings.workEmailHint,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      readOnly: widget.onEmailChanged == null,
      helperText: widget.onEmailChanged == null
          ? SettingsStrings.emailLocked
          : null,
      errorText: _emailError,
      onChanged: widget.onEmailChanged,
    );
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < _stackBreakpoint) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [name, const SizedBox(height: 20), email],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: name),
                  const SizedBox(width: 16),
                  Expanded(child: email),
                ],
              );
            },
          ),
          if (widget.onPasswordChanged case final onPasswordChanged?) ...[
            const SizedBox(height: 20),
            AppTextField(
              controller: _password,
              label: SettingsStrings.passwordLabel,
              hintText: SettingsStrings.passwordHint,
              obscureText: true,
              textInputAction: TextInputAction.next,
              helperText: SettingsStrings.passwordHelper,
              errorText: state.showPasswordError
                  ? SettingsStrings.passwordTooShort
                  : null,
              onChanged: onPasswordChanged,
            ),
          ],
          const SizedBox(height: 22),
          const Text(SettingsStrings.roleLabel, style: AppTextStyles.label),
          const SizedBox(height: 12),
          for (final AdminRole role in AdminRole.values) ...[
            AppRadioCard(
              title: role.label,
              subtitle: role.description,
              isSelected: state.role == role,
              onTap: () => widget.onRoleChanged(role),
            ),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 14),
          AppToggleRow(
            title: SettingsStrings.accountActive,
            subtitle: SettingsStrings.accountActiveNote,
            value: state.isActive,
            onChanged: widget.onActiveChanged,
          ),
          if (formError != null) ...[
            const SizedBox(height: 10),
            Text(formError, style: AppTextStyles.fieldError),
          ],
          const Divider(height: 40, color: AppColors.divider),
          Wrap(
            alignment: WrapAlignment.end,
            spacing: 10,
            runSpacing: 10,
            children: [
              AppSecondaryButton(
                label: SettingsStrings.cancel,
                onPressed: state.isSaving ? null : widget.onCancel,
              ),
              AppPrimaryButton(
                label: widget.saveLabel,
                isCompact: true,
                isLoading: state.isSaving,
                onPressed: widget.onSave,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
