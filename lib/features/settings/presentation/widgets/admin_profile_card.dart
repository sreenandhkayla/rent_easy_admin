import 'package:flutter/material.dart';

import '../../../../core/resources/images/app_images.dart';
import '../../../../core/resources/strings/settings_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_detail_field.dart';
import '../../../../core/widgets/app_initials_avatar.dart';
import '../../../../core/widgets/app_responsive_grid.dart';
import '../../../../core/widgets/app_secondary_button.dart';
import '../../data/models/admin_account.dart';

class AdminProfileCard extends StatelessWidget {
  const AdminProfileCard({
    super.key,
    required this.account,
    required this.onEditProfile,
  });

  final AdminAccount account;
  final VoidCallback onEditProfile;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppInitialsAvatar(
                    name: account.name,
                    size: 56,
                    initialsStyle: AppTextStyles.avatarInitialsLarge,
                  ),
                  const SizedBox(width: 14),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(account.name, style: AppTextStyles.profileName),
                        const SizedBox(height: 2),
                        Text(
                          SettingsStrings.roleAndEmail(
                            account.role,
                            account.email,
                          ),
                          style: AppTextStyles.bodyCaption,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              AppSecondaryButton(
                label: SettingsStrings.editProfile,
                svgIcon: AppImages.editProfileIcon,
                iconColor: AppColors.textPrimary,
                onPressed: onEditProfile,
              ),
            ],
          ),
          const Divider(height: 36, color: AppColors.divider),
          AppResponsiveGrid(
            minItemWidth: 200,
            maxColumns: 2,
            spacing: 18,
            children: [
              AppDetailField(
                label: SettingsStrings.fullName,
                value: account.name,
              ),
              AppDetailField(
                label: SettingsStrings.workEmail,
                value: account.email,
              ),
              AppDetailField(
                label: SettingsStrings.mobileNumber,
                value: account.mobileNumber,
              ),
              AppDetailField(label: SettingsStrings.role, value: account.role),
              AppDetailField(
                label: SettingsStrings.lastSignIn,
                value: SettingsStrings.signInLine(
                  AppFormatters.timestamp(account.lastSignInAt),
                  account.lastSignInPlace,
                ),
              ),
              AppDetailField(
                label: SettingsStrings.adminId,
                value: account.adminId,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
