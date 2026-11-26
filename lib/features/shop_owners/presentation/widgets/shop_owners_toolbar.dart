import 'package:flutter/material.dart';

import '../../../../core/enums/registration_date_filter.dart';
import '../../../../core/resources/strings/shop_owners_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_dropdown.dart';
import '../../../../core/widgets/app_search_field.dart';
import '../state/shop_owners_state.dart';

class ShopOwnersToolbar extends StatelessWidget {
  const ShopOwnersToolbar({
    super.key,
    required this.statusFilter,
    required this.dateFilter,
    required this.totalOnPlatform,
    required this.onSearch,
    required this.onStatusChanged,
    required this.onDateChanged,
  });

  final OwnerStatusFilter statusFilter;
  final RegistrationDateFilter dateFilter;
  final int totalOnPlatform;
  final ValueChanged<String> onSearch;
  final ValueChanged<OwnerStatusFilter> onStatusChanged;
  final ValueChanged<RegistrationDateFilter> onDateChanged;

  static String statusLabel(OwnerStatusFilter filter) => switch (filter) {
    OwnerStatusFilter.all => ShopOwnersStrings.allStatuses,
    OwnerStatusFilter.active => ShopOwnersStrings.active,
    OwnerStatusFilter.restricted => ShopOwnersStrings.restricted,
  };

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) => Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                SizedBox(
                  width: constraints.maxWidth < AppTheme.searchFieldMaxWidth
                      ? constraints.maxWidth
                      : AppTheme.searchFieldMaxWidth,
                  child: AppSearchField(
                    hintText: ShopOwnersStrings.searchHint,
                    onChanged: onSearch,
                  ),
                ),
                AppDropdown<OwnerStatusFilter>(
                  value: statusFilter,
                  items: OwnerStatusFilter.values,
                  labelOf: statusLabel,
                  onChanged: onStatusChanged,
                ),
                AppDropdown<RegistrationDateFilter>(
                  value: dateFilter,
                  items: RegistrationDateFilter.values,
                  labelOf: (filter) => filter.label,
                  onChanged: onDateChanged,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Text(
          ShopOwnersStrings.ownersOnPlatform(totalOnPlatform),
          style: AppTextStyles.meta,
        ),
      ],
    );
  }
}
