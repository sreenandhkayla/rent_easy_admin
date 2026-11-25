import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/resources/strings/app_strings.dart';
import '../../../../core/resources/strings/shop_owners_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/widgets/app_access_status_pill.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_initials_avatar.dart';
import '../../../../core/widgets/app_pagination.dart';
import '../../../../core/widgets/app_secondary_button.dart';
import '../../../../core/widgets/app_sortable_header.dart';
import '../../../../core/widgets/app_table_header.dart';
import '../../data/models/shop_owner.dart';
import '../state/shop_owners_state.dart';

class ShopOwnersTable extends StatelessWidget {
  const ShopOwnersTable({
    super.key,
    required this.state,
    required this.onSort,
    required this.onPageChanged,
    required this.onView,
  });

  static const double _minTableWidth = 960;

  final ShopOwnersState state;
  final ValueChanged<OwnerSortField> onSort;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<ShopOwner> onView;

  @override
  Widget build(BuildContext context) {
    final List<ShopOwner> rows = state.pageOwners;
    final int total = state.filteredOwners.length;
    final int start = total == 0
        ? 0
        : (state.page - 1) * ShopOwnersState.pageSize + 1;
    final int end = start == 0 ? 0 : start + rows.length - 1;
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final double width = math.max(
                constraints.maxWidth,
                _minTableWidth,
              );
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _HeaderRow(state: state, onSort: onSort),
                      if (rows.isEmpty)
                        const AppEmptyState(
                          icon: Icons.search,
                          title: ShopOwnersStrings.noMatchesTitle,
                          message: ShopOwnersStrings.noMatchesMessage,
                        ),
                      for (final ShopOwner owner in rows)
                        _OwnerRow(owner: owner, onView: () => onView(owner)),
                    ],
                  ),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 16,
              runSpacing: 12,
              children: [
                Text(
                  ShopOwnersStrings.showingRange(start, end, total),
                  style: AppTextStyles.bodyCaption,
                ),
                AppPagination(
                  currentPage: state.page,
                  pageCount: state.pageCount,
                  onPageChanged: onPageChanged,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Columns {
  static const int name = 30;
  static const int mobile = 13;
  static const int ownerId = 10;
  static const int registered = 12;
  static const int shops = 6;
  static const int subscribed = 8;
  static const int status = 11;
  static const double action = 80;
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow({required this.state, required this.onSort});

  final ShopOwnersState state;
  final ValueChanged<OwnerSortField> onSort;

  @override
  Widget build(BuildContext context) {
    Widget sortable(String label, OwnerSortField field, {bool end = false}) =>
        AppSortableHeader(
          label: label,
          isActive: state.sortField == field,
          isAscending: state.isAscending,
          alignEnd: end,
          onTap: () => onSort(field),
        );

    Widget plain(String label, {bool end = false}) => Text(
      label,
      style: AppTextStyles.tableHeader,
      textAlign: end ? TextAlign.end : TextAlign.start,
    );

    return AppTableHeader(
      showTopBorder: false,
      child: Row(
        children: [
          Expanded(
            flex: _Columns.name,
            child: sortable(ShopOwnersStrings.ownerName, OwnerSortField.name),
          ),
          Expanded(
            flex: _Columns.mobile,
            child: plain(ShopOwnersStrings.mobileNumber),
          ),
          Expanded(
            flex: _Columns.ownerId,
            child: plain(ShopOwnersStrings.ownerId),
          ),
          Expanded(
            flex: _Columns.registered,
            child: sortable(
              ShopOwnersStrings.registered,
              OwnerSortField.registeredAt,
            ),
          ),
          Expanded(
            flex: _Columns.shops,
            child: sortable(
              ShopOwnersStrings.shops,
              OwnerSortField.shops,
              end: true,
            ),
          ),
          Expanded(
            flex: _Columns.subscribed,
            child: plain(ShopOwnersStrings.subscribed, end: true),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: _Columns.status,
            child: plain(ShopOwnersStrings.status),
          ),
          const SizedBox(width: _Columns.action),
        ],
      ),
    );
  }
}

class _OwnerRow extends StatelessWidget {
  const _OwnerRow({required this.owner, required this.onView});

  final ShopOwner owner;
  final VoidCallback onView;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: _Columns.name,
            child: Row(
              children: [
                AppInitialsAvatar(name: owner.name, size: 30, isMuted: true),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(owner.name, style: AppTextStyles.titleSmall),
                ),
              ],
            ),
          ),
          Expanded(
            flex: _Columns.mobile,
            child: Text(owner.mobile, style: AppTextStyles.tableCell),
          ),
          Expanded(
            flex: _Columns.ownerId,
            child: Text(owner.ownerId, style: AppTextStyles.tableCell),
          ),
          Expanded(
            flex: _Columns.registered,
            child: Text(
              AppFormatters.date(owner.registeredAt),
              style: AppTextStyles.tableCell,
            ),
          ),
          Expanded(
            flex: _Columns.shops,
            child: Text(
              '${owner.shops}',
              style: AppTextStyles.tableCell,
              textAlign: TextAlign.end,
            ),
          ),
          Expanded(
            flex: _Columns.subscribed,
            child: Text(
              '${owner.subscribedShops}',
              style: AppTextStyles.tableCell,
              textAlign: TextAlign.end,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: _Columns.status,
            child: Align(
              alignment: Alignment.centerLeft,
              child: AppAccessStatusPill(
                isRestricted: owner.status == OwnerStatus.restricted,
              ),
            ),
          ),
          SizedBox(
            width: _Columns.action,
            child: Align(
              alignment: Alignment.centerRight,
              child: AppSecondaryButton(
                label: AppStrings.view,
                onPressed: onView,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
