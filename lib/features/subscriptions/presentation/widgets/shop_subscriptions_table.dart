import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/resources/strings/app_strings.dart';
import '../../../../core/resources/strings/subscriptions_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_payment_pill.dart';
import '../../../../core/widgets/app_secondary_button.dart';
import '../../../../core/widgets/app_subscription_pill.dart';
import '../../../../core/widgets/app_table_header.dart';
import '../../data/models/shop_subscription.dart';

class ShopSubscriptionsTable extends StatelessWidget {
  const ShopSubscriptionsTable({
    super.key,
    required this.rows,
    required this.onView,
  });

  static const double _minTableWidth = 1000;

  final List<ShopSubscription> rows;
  final ValueChanged<ShopSubscription> onView;

  @override
  Widget build(BuildContext context) {
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
                    const _HeaderRow(),
                    if (rows.isEmpty)
                      const AppEmptyState(
                        icon: Icons.search,
                        title: SubscriptionsStrings.noMatchesTitle,
                        message: SubscriptionsStrings.noMatchesMessage,
                      ),
                    for (final ShopSubscription row in rows)
                      _SubscriptionRow(item: row, onView: () => onView(row)),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Text(
              SubscriptionsStrings.shopsShown(rows.length),
              style: AppTextStyles.bodyCaption,
            ),
          ),
        ],
      ),
    );
  }
}

class _Columns {
  static const int name = 27;
  static const int owner = 12;
  static const int plan = 10;
  static const int start = 10;
  static const int expiry = 10;
  static const int status = 12;
  static const int payment = 11;
  static const double action = 72;
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow();

  @override
  Widget build(BuildContext context) {
    Widget cell(String label, int flex) => Expanded(
      flex: flex,
      child: Text(label, style: AppTextStyles.tableHeader),
    );
    return AppTableHeader(
      showTopBorder: false,
      child: Row(
        children: [
          cell(SubscriptionsStrings.shopName, _Columns.name),
          cell(SubscriptionsStrings.owner, _Columns.owner),
          cell(SubscriptionsStrings.plan, _Columns.plan),
          cell(SubscriptionsStrings.startDate, _Columns.start),
          cell(SubscriptionsStrings.expiryDate, _Columns.expiry),
          cell(SubscriptionsStrings.status, _Columns.status),
          cell(SubscriptionsStrings.payment, _Columns.payment),
          const SizedBox(width: _Columns.action),
        ],
      ),
    );
  }
}

class _SubscriptionRow extends StatelessWidget {
  const _SubscriptionRow({required this.item, required this.onView});

  final ShopSubscription item;
  final VoidCallback onView;

  String _date(DateTime? date) =>
      date == null ? SubscriptionsStrings.emptyValue : AppFormatters.date(date);

  @override
  Widget build(BuildContext context) {
    Widget text(String value, int flex) => Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Text(value, style: AppTextStyles.tableCell),
      ),
    );
    Widget pill(Widget child, int flex) => Expanded(
      flex: flex,
      child: Align(alignment: Alignment.centerLeft, child: child),
    );
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
                  Text(item.shopName, style: AppTextStyles.titleSmall),
                  const SizedBox(height: 2),
                  Text(item.shopId, style: AppTextStyles.meta),
                ],
              ),
            ),
          ),
          text(item.ownerName, _Columns.owner),
          text(
            item.plan?.label ?? SubscriptionsStrings.emptyValue,
            _Columns.plan,
          ),
          text(_date(item.startedAt), _Columns.start),
          text(_date(item.expiresAt), _Columns.expiry),
          pill(AppSubscriptionPill(status: item.status), _Columns.status),
          pill(AppPaymentPill(status: item.payment), _Columns.payment),
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
