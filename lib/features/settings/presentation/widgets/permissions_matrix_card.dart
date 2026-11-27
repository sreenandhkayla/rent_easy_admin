import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/access/role_permissions.dart';
import '../../../../core/enums/admin_permission.dart';
import '../../../../core/enums/admin_role.dart';
import '../../../../core/resources/strings/settings_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_checkbox.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_secondary_button.dart';
import '../../../../core/widgets/app_table_header.dart';

class PermissionsMatrixCard extends StatelessWidget {
  const PermissionsMatrixCard({
    super.key,
    required this.permissions,
    required this.canEdit,
    required this.hasChanges,
    required this.isSaving,
    required this.onToggle,
    required this.onSave,
    required this.onDiscard,
  });

  static const double _minTableWidth = 720;
  static const int _labelFlex = 52;
  static const int _roleFlex = 12;

  final RolePermissions permissions;
  final bool canEdit;
  final bool hasChanges;
  final bool isSaving;
  final void Function(AdminRole role, AdminPermission permission) onToggle;
  final VoidCallback onSave;
  final VoidCallback onDiscard;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              runSpacing: 10,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      SettingsStrings.permissions,
                      style: AppTextStyles.cardTitle,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      canEdit
                          ? SettingsStrings.permissionsNote
                          : SettingsStrings.permissionsReadOnly,
                      style: AppTextStyles.meta,
                    ),
                  ],
                ),
                if (canEdit && hasChanges)
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      AppSecondaryButton(
                        label: SettingsStrings.discardChanges,
                        onPressed: isSaving ? null : onDiscard,
                      ),
                      AppPrimaryButton(
                        label: SettingsStrings.saveChanges,
                        isCompact: true,
                        isLoading: isSaving,
                        onPressed: onSave,
                      ),
                    ],
                  ),
              ],
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: math.max(constraints.maxWidth, _minTableWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppTableHeader(
                      child: Row(
                        children: [
                          const Expanded(
                            flex: _labelFlex,
                            child: Text(
                              SettingsStrings.permission,
                              style: AppTextStyles.tableHeader,
                            ),
                          ),
                          for (final AdminRole role in AdminRole.values)
                            Expanded(
                              flex: _roleFlex,
                              child: Text(
                                role.label,
                                style: AppTextStyles.tableHeader,
                                textAlign: TextAlign.center,
                              ),
                            ),
                        ],
                      ),
                    ),
                    for (int i = 0; i < AdminPermission.values.length; i++)
                      _PermissionRow(
                        permission: AdminPermission.values[i],
                        permissions: permissions,
                        isEditable: canEdit && !isSaving,
                        showDivider: i < AdminPermission.values.length - 1,
                        onToggle: onToggle,
                      ),
                  ],
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Text(
              SettingsStrings.permissionsFixedNote,
              style: AppTextStyles.meta,
            ),
          ),
        ],
      ),
    );
  }
}

class _PermissionRow extends StatelessWidget {
  const _PermissionRow({
    required this.permission,
    required this.permissions,
    required this.isEditable,
    required this.showDivider,
    required this.onToggle,
  });

  final AdminPermission permission;
  final RolePermissions permissions;
  final bool isEditable;
  final bool showDivider;
  final void Function(AdminRole role, AdminPermission permission) onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(bottom: BorderSide(color: AppColors.divider))
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            flex: PermissionsMatrixCard._labelFlex,
            child: Text(permission.label, style: AppTextStyles.tableCell),
          ),
          for (final AdminRole role in AdminRole.values)
            Expanded(
              flex: PermissionsMatrixCard._roleFlex,
              child: Center(child: _cell(role)),
            ),
        ],
      ),
    );
  }

  Widget _cell(AdminRole role) {
    final bool isGranted = permissions.isGranted(role, permission);
    final String semanticLabel = SettingsStrings.permissionFor(
      role.label,
      permission.label,
      isGranted,
    );
    if (RolePermissions.isEditable(role, permission)) {
      return AppCheckbox(
        value: isGranted,
        semanticLabel: semanticLabel,
        onChanged: isEditable ? (_) => onToggle(role, permission) : null,
      );
    }
    return _PermissionMark(isGranted: isGranted, semanticLabel: semanticLabel);
  }
}

class _PermissionMark extends StatelessWidget {
  const _PermissionMark({required this.isGranted, required this.semanticLabel});

  final bool isGranted;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      child: Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          color: isGranted ? AppColors.ink : AppColors.iconCircle,
          shape: BoxShape.circle,
        ),
        child: Icon(
          isGranted ? Icons.check : Icons.close,
          size: isGranted ? 12 : 10,
          color: isGranted ? AppColors.onInk : AppColors.statusGrey,
        ),
      ),
    );
  }
}
