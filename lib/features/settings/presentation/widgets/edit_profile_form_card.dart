import 'package:flutter/material.dart';

import '../../../../core/resources/strings/settings_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_detail_field.dart';
import '../../../../core/widgets/app_initials_avatar.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_responsive_grid.dart';
import '../../../../core/widgets/app_secondary_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../state/edit_profile_state.dart';

class EditProfileFormCard extends StatefulWidget {
  const EditProfileFormCard({
    super.key,
    required this.state,
    required this.onNameChanged,
    required this.onMobileChanged,
    required this.onCancel,
    required this.onSave,
  });

  final EditProfileState state;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onMobileChanged;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  @override
  State<EditProfileFormCard> createState() => _EditProfileFormCardState();
}

class _EditProfileFormCardState extends State<EditProfileFormCard> {
  static const double _stackBreakpoint = 520;

  late final TextEditingController _name = TextEditingController(
    text: widget.state.name,
  );
  late final TextEditingController _mobile = TextEditingController(
    text: widget.state.mobileNumber,
  );

  @override
  void dispose() {
    _name.dispose();
    _mobile.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final EditProfileState state = widget.state;
    final String displayName = state.name.trim().isEmpty
        ? state.account.name
        : state.name.trim();
    final Widget name = AppTextField(
      label: SettingsStrings.fullNameLabel,
      hintText: SettingsStrings.fullNameHint,
      controller: _name,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.name],
      errorText: state.showNameError ? SettingsStrings.nameRequired : null,
      onChanged: widget.onNameChanged,
    );
    final Widget mobile = AppTextField(
      label: SettingsStrings.mobileNumberLabel,
      hintText: SettingsStrings.mobileNumberHint,
      controller: _mobile,
      keyboardType: TextInputType.phone,
      autofillHints: const [AutofillHints.telephoneNumber],
      errorText: state.showMobileError ? SettingsStrings.mobileInvalid : null,
      onChanged: widget.onMobileChanged,
    );
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              AppInitialsAvatar(
                name: displayName,
                size: 56,
                initialsStyle: AppTextStyles.avatarInitialsLarge,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(displayName, style: AppTextStyles.profileName),
                    const SizedBox(height: 2),
                    Text(
                      SettingsStrings.roleAndEmail(
                        state.account.role,
                        state.account.email,
                      ),
                      style: AppTextStyles.bodyCaption,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 36, color: AppColors.divider),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < _stackBreakpoint) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [name, const SizedBox(height: 20), mobile],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: name),
                  const SizedBox(width: 16),
                  Expanded(child: mobile),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          const Text(
            SettingsStrings.managedBySuperAdmin,
            style: AppTextStyles.titleSmall,
          ),
          const SizedBox(height: 14),
          AppResponsiveGrid(
            minItemWidth: 160,
            maxColumns: 3,
            spacing: 18,
            children: [
              AppDetailField(
                label: SettingsStrings.workEmail,
                value: state.account.email,
              ),
              AppDetailField(
                label: SettingsStrings.role,
                value: state.account.role,
              ),
              AppDetailField(
                label: SettingsStrings.adminId,
                value: state.account.adminId,
              ),
            ],
          ),
          const Divider(height: 40, color: AppColors.divider),
          Wrap(
            alignment: WrapAlignment.end,
            spacing: 10,
            runSpacing: 10,
            children: [
              AppSecondaryButton(
                label: SettingsStrings.cancel,
                onPressed: widget.onCancel,
              ),
              AppPrimaryButton(
                label: SettingsStrings.saveChanges,
                isCompact: true,
                onPressed: widget.onSave,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
