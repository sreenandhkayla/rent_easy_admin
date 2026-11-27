import 'package:flutter/material.dart';

import '../../../../core/resources/strings/app_strings.dart';
import '../../../../core/resources/strings/settings_strings.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_list_skeleton.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_search_field.dart';
import '../../data/models/admin_staff_member.dart';
import 'admin_staff_table.dart';

class AdminStaffTab extends StatefulWidget {
  const AdminStaffTab({
    super.key,
    required this.staff,
    required this.query,
    required this.onSearch,
    required this.onAddAdmin,
    required this.onManage,
    required this.onRetry,
    this.isLoading = false,
    this.isSearching = false,
    this.errorMessage,
  });

  final List<AdminStaffMember> staff;
  final String query;
  final ValueChanged<String> onSearch;
  final VoidCallback onAddAdmin;
  final ValueChanged<AdminStaffMember> onManage;
  final VoidCallback onRetry;
  final bool isLoading;
  final bool isSearching;
  final String? errorMessage;

  @override
  State<AdminStaffTab> createState() => _AdminStaffTabState();
}

class _AdminStaffTabState extends State<AdminStaffTab> {
  late final TextEditingController _searchController = TextEditingController(
    text: widget.query,
  );

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LayoutBuilder(
          builder: (context, constraints) => Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children: [
              SizedBox(
                width: constraints.maxWidth < AppTheme.searchFieldMaxWidth
                    ? constraints.maxWidth
                    : AppTheme.searchFieldMaxWidth,
                child: AppSearchField(
                  controller: _searchController,
                  hintText: SettingsStrings.staffSearchHint,
                  onChanged: widget.onSearch,
                ),
              ),
              AppPrimaryButton(
                label: SettingsStrings.addAdmin,
                icon: Icons.add,
                isCompact: true,
                onPressed: widget.onAddAdmin,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (widget.isLoading)
          const AppListSkeleton()
        else if (widget.errorMessage case final String message)
          AppCard(
            child: AppEmptyState(
              icon: Icons.error_outline_rounded,
              title: SettingsStrings.staffLoadFailed,
              message: message,
              actionLabel: AppStrings.retry,
              onAction: widget.onRetry,
            ),
          )
        else
          AdminStaffTable(
            rows: widget.staff,
            isLoading: widget.isSearching,
            onManage: widget.onManage,
          ),
      ],
    );
  }
}
