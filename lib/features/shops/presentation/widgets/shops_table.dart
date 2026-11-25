import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/resources/strings/app_strings.dart';
import '../../../../core/resources/strings/shops_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/widgets/app_access_status_pill.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_pagination.dart';
import '../../../../core/widgets/app_secondary_button.dart';
import '../../../../core/widgets/app_sortable_header.dart';
import '../../../../core/widgets/app_subscription_pill.dart';
import '../../../../core/widgets/app_table_header.dart';
import '../../data/models/shop.dart';
import '../state/shops_state.dart';
import 'shop_labels.dart';

class ShopsTable extends StatelessWidget {
  const ShopsTable({
    super.key,
    required this.state,
    required this.onSort,
    required this.onPageChanged,
    required this.onView,
  });

  static const double _minTableWidth = 1080;

  final ShopsState state;
  final ValueChanged<ShopSortField> onSort;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<Shop> onView;

  @override
  Widget build(BuildContext context) {
    final List<Shop> rows = state.pageShops;
    final int total = state.filteredShops.length;
    final int start = total == 0
        ? 0
        : (state.page - 1) * ShopsState.pageSize + 1;
    final int end = start == 0 ? 0 : start + rows.length - 1;
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: math.max(constraints.maxWidth, _minTableWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _HeaderRow(state: state, onSort: onSort),
                    if (rows.isEmpty)
                      const AppEmptyState(
                        icon: Icons.search,
                        title: ShopsStrings.noMatchesTitle,
                        message: ShopsStrings.noMatchesMessage,
                      ),
                    for (final Shop shop in rows)
                      _ShopRow(shop: shop, onView: () => onView(shop)),
                  ],
                ),
              ),
            ),
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
                  ShopsStrings.showingRange(
                    start,
                    end,
                    total,
                    state.totalOnPlatform,
                  ),
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
  static const int name = 21;
  static const int shopId = 9;
  static const int owner = 15;
  static const int location = 15;
  static const int plan = 11;
  static const int subscription = 11;
  static const int expiry = 11;
  static const int status = 9;
  static const double action = 72;
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow({required this.state, required this.onSort});

  final ShopsState state;
  final ValueChanged<ShopSortField> onSort;

  @override
  Widget build(BuildContext context) {
    Widget plain(String label) => Text(label, style: AppTextStyles.tableHeader);
    return AppTableHeader(
      showTopBorder: false,
      child: Row(
        children: [
          Expanded(
            flex: _Columns.name,
            child: AppSortableHeader(
              label: ShopsStrings.shopName,
              isActive: state.sortField == ShopSortField.name,
              isAscending: state.isAscending,
              onTap: () => onSort(ShopSortField.name),
            ),
          ),
          Expanded(flex: _Columns.shopId, child: plain(ShopsStrings.shopId)),
          Expanded(flex: _Columns.owner, child: plain(ShopsStrings.owner)),
          Expanded(
            flex: _Columns.location,
            child: plain(ShopsStrings.location),
          ),
          Expanded(flex: _Columns.plan, child: plain(ShopsStrings.plan)),
          Expanded(
            flex: _Columns.subscription,
            child: plain(ShopsStrings.subscription),
          ),
          Expanded(
            flex: _Columns.expiry,
            child: AppSortableHeader(
              label: ShopsStrings.expiry,
              isActive: state.sortField == ShopSortField.expiry,
              isAscending: state.isAscending,
              onTap: () => onSort(ShopSortField.expiry),
            ),
          ),
          Expanded(
            flex: _Columns.status,
            child: plain(ShopsStrings.shopStatus),
          ),
          const SizedBox(width: _Columns.action),
        ],
      ),
    );
  }
}

class _ShopRow extends StatelessWidget {
  const _ShopRow({required this.shop, required this.onView});

  final Shop shop;
  final VoidCallback onView;

  @override
  Widget build(BuildContext context) {
    final DateTime? expiresAt = shop.expiresAt;
    final String? branchOf = shop.branchOf;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: _Columns.name,
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(shop.name, style: AppTextStyles.tableCellStrong),
                  const SizedBox(height: 2),
                  Text(
                    branchOf == null
                        ? ShopsStrings.mainShop
                        : ShopsStrings.branchOf(branchOf),
                    style: AppTextStyles.meta,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: _Columns.shopId,
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(shop.shopId, style: AppTextStyles.tableCell),
            ),
          ),
          Expanded(
            flex: _Columns.owner,
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(shop.ownerName, style: AppTextStyles.tableCell),
            ),
          ),
          Expanded(
            flex: _Columns.location,
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(shop.location, style: AppTextStyles.tableCell),
            ),
          ),
          Expanded(
            flex: _Columns.plan,
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                ShopLabels.plan(shop.plan),
                style: AppTextStyles.tableCell,
              ),
            ),
          ),
          Expanded(
            flex: _Columns.subscription,
            child: Align(
              alignment: Alignment.centerLeft,
              child: AppSubscriptionPill(status: shop.subscription),
            ),
          ),
          Expanded(
            flex: _Columns.expiry,
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                expiresAt == null
                    ? ShopsStrings.emptyValue
                    : AppFormatters.date(expiresAt),
                style: AppTextStyles.tableCell,
              ),
            ),
          ),
          Expanded(
            flex: _Columns.status,
            child: Align(
              alignment: Alignment.centerLeft,
              child: AppAccessStatusPill(
                isRestricted: shop.status == ShopStatus.restricted,
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
