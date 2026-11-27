import 'package:flutter/material.dart';

import '../../../../core/access/role_permissions.dart';
import '../../../../core/enums/admin_permission.dart';
import '../../../../core/enums/admin_role.dart';
import '../../../../core/resources/strings/app_strings.dart';
import '../../../../core/resources/strings/settings_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_list_skeleton.dart';
import '../../../../core/widgets/app_responsive_grid.dart';
import '../../../../core/widgets/app_secondary_button.dart';
import '../../../../core/widgets/app_status_pill.dart';
import 'permissions_matrix_card.dart';

class RolesPermissionsTab extends StatelessWidget {
  const RolesPermissionsTab({
    super.key,
    required this.adminCountOf,
    required this.onPreview,
    required this.permissions,
    required this.canEdit,
    required this.hasChanges,
    required this.isSaving,
    required this.onToggle,
    required this.onSave,
    required this.onDiscard,
    required this.onRetry,
    this.isLoading = false,
    this.errorMessage,
  });

  final int Function(AdminRole role) adminCountOf;
  final ValueChanged<AdminRole> onPreview;
  final RolePermissions? permissions;
  final bool canEdit;
  final bool hasChanges;
  final bool isSaving;
  final void Function(AdminRole role, AdminPermission permission) onToggle;
  final VoidCallback onSave;
  final VoidCallback onDiscard;
  final VoidCallback onRetry;
  final bool isLoading;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final RolePermissions? permissions = this.permissions;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppResponsiveGrid(
          minItemWidth: 260,
          maxColumns: 3,
          children: [
            for (final AdminRole role in AdminRole.values)
              _RoleCard(
                role: role,
                adminCount: adminCountOf(role),
                onPreview: () => onPreview(role),
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (errorMessage case final String message)
          AppCard(
            child: AppEmptyState(
              icon: Icons.error_outline_rounded,
              title: SettingsStrings.rolesLoadFailed,
              message: message,
              actionLabel: AppStrings.retry,
              onAction: onRetry,
            ),
          )
        else if (isLoading || permissions == null)
          const AppListSkeleton()
        else
          PermissionsMatrixCard(
            permissions: permissions,
            canEdit: canEdit,
            hasChanges: hasChanges,
            isSaving: isSaving,
            onToggle: onToggle,
            onSave: onSave,
            onDiscard: onDiscard,
          ),
      ],
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.role,
    required this.adminCount,
    required this.onPreview,
  });

  final AdminRole role;
  final int adminCount;
  final VoidCallback onPreview;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Text(role.label, style: AppTextStyles.cardTitle)),
              const SizedBox(width: 12),
              AppStatusPill(
                label: SettingsStrings.adminCount(adminCount),
                color: AppColors.textSecondary,
                backgroundColor: AppColors.iconCircle,
                showDot: false,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(role.description, style: AppTextStyles.bodySmall),
          const Spacer(),
          const SizedBox(height: 12),
          AppSecondaryButton(
            label: SettingsStrings.previewConsoleAs(role.label),
            icon: Icons.visibility_outlined,
            iconColor: AppColors.textPrimary,
            isExpanded: true,
            onPressed: onPreview,
          ),
        ],
      ),
    );
  }
}
