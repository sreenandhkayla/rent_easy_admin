import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/resources/strings/settings_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_initials_avatar.dart';
import '../../../../core/widgets/app_secondary_button.dart';
import '../../../../core/widgets/app_status_pill.dart';
import '../../../../core/widgets/app_table_header.dart';
import '../../data/models/admin_staff_member.dart';

class AdminStaffTable extends StatelessWidget {
  const AdminStaffTable({
    super.key,
    required this.rows,
    required this.onManage,
  });

  static const double _minTableWidth = 900;

  final List<AdminStaffMember> rows;
  final ValueChanged<AdminStaffMember> onManage;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: math.max(constraints.maxWidth, _minTableWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _HeaderRow(),
                if (rows.isEmpty)
                  const AppEmptyState(
                    icon: Icons.search,
                    title: SettingsStrings.noStaffTitle,
                    message: SettingsStrings.noStaffMessage,
                  ),
                for (int i = 0; i < rows.length; i++)
                  _StaffRow(
                    member: rows[i],
                    showDivider: i < rows.length - 1,
                    onManage: () => onManage(rows[i]),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Columns {
  static const int admin = 30;
  static const int email = 26;
  static const int role = 13;
  static const int status = 9;
  static const int lastSignIn = 13;
  static const double action = 84;
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow();

  @override
  Widget build(BuildContext context) {
    Widget cell(String label, int flex) => Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Text(label, style: AppTextStyles.tableHeader),
      ),
    );
    return AppTableHeader(
      showTopBorder: false,
      child: Row(
        children: [
          cell(SettingsStrings.admin, _Columns.admin),
          cell(SettingsStrings.email, _Columns.email),
          cell(SettingsStrings.role, _Columns.role),
          cell(SettingsStrings.status, _Columns.status),
          cell(SettingsStrings.lastSignIn, _Columns.lastSignIn),
          const SizedBox(width: _Columns.action),
        ],
      ),
    );
  }
}

class _StaffRow extends StatelessWidget {
  const _StaffRow({
    required this.member,
    required this.showDivider,
    required this.onManage,
  });

  final AdminStaffMember member;
  final bool showDivider;
  final VoidCallback onManage;

  @override
  Widget build(BuildContext context) {
    Widget text(String value, int flex) => Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Text(value, style: AppTextStyles.tableCell),
      ),
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(bottom: BorderSide(color: AppColors.divider))
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            flex: _Columns.admin,
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Row(
                children: [
                  AppInitialsAvatar(name: member.name, size: 28, isMuted: true),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(member.name, style: AppTextStyles.titleSmall),
                  ),
                ],
              ),
            ),
          ),
          text(member.email, _Columns.email),
          text(member.role, _Columns.role),
          Expanded(
            flex: _Columns.status,
            child: Align(
              alignment: Alignment.centerLeft,
              child: member.isActive
                  ? const AppStatusPill(
                      label: SettingsStrings.statusActive,
                      color: AppColors.statusGreen,
                      backgroundColor: AppColors.pillGreenBackground,
                    )
                  : const AppStatusPill(
                      label: SettingsStrings.statusInactive,
                      color: AppColors.textSecondary,
                      backgroundColor: AppColors.iconCircle,
                    ),
            ),
          ),
          text(
            member.lastSignInAt == null
                ? SettingsStrings.invitationSent
                : AppFormatters.timestamp(member.lastSignInAt!),
            _Columns.lastSignIn,
          ),
          SizedBox(
            width: _Columns.action,
            child: Align(
              alignment: Alignment.centerRight,
              child: AppSecondaryButton(
                label: SettingsStrings.manage,
                onPressed: onManage,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
