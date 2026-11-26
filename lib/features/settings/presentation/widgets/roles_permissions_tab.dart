import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/resources/strings/settings_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_responsive_grid.dart';
import '../../../../core/widgets/app_secondary_button.dart';
import '../../../../core/widgets/app_status_pill.dart';
import '../../../../core/widgets/app_table_header.dart';
import '../../../../core/enums/admin_permission.dart';
import '../../../../core/enums/admin_role.dart';

class RolesPermissionsTab extends StatelessWidget {
  const RolesPermissionsTab({
    super.key,
    required this.adminCountOf,
    required this.onPreview,
  });

  final int Function(AdminRole role) adminCountOf;
  final ValueChanged<AdminRole> onPreview;

  @override
  Widget build(BuildContext context) {
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
        const _PermissionsCard(),
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

class _PermissionsCard extends StatelessWidget {
  const _PermissionsCard();

  static const double _minTableWidth = 720;
  static const int _labelFlex = 52;
  static const int _roleFlex = 12;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 18, 16, 14),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              runSpacing: 4,
              children: [
                Text(
                  SettingsStrings.permissions,
                  style: AppTextStyles.cardTitle,
                ),
                Text(
                  SettingsStrings.permissionsNote,
                  style: AppTextStyles.meta,
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
                        showDivider: i < AdminPermission.values.length - 1,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PermissionRow extends StatelessWidget {
  const _PermissionRow({required this.permission, required this.showDivider});

  final AdminPermission permission;
  final bool showDivider;

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
            flex: _PermissionsCard._labelFlex,
            child: Text(permission.label, style: AppTextStyles.tableCell),
          ),
          for (final AdminRole role in AdminRole.values)
            Expanded(
              flex: _PermissionsCard._roleFlex,
              child: Center(
                child: _PermissionMark(
                  isGranted: permission.isGranted(role),
                  semanticLabel: SettingsStrings.permissionFor(
                    role.label,
                    permission.label,
                    permission.isGranted(role),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
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
