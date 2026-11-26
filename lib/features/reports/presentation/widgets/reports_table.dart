import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/resources/strings/reports_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_secondary_button.dart';
import '../../../../core/widgets/app_table_header.dart';
import '../../data/models/shop_report.dart';
import 'report_status_pill.dart';

class ReportsTable extends StatelessWidget {
  const ReportsTable({super.key, required this.rows, required this.onReview});

  static const double _minTableWidth = 960;

  final List<ShopReport> rows;
  final ValueChanged<ShopReport> onReview;

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
                    title: ReportsStrings.noMatchesTitle,
                    message: ReportsStrings.noMatchesMessage,
                  ),
                for (int i = 0; i < rows.length; i++)
                  _ReportRow(
                    item: rows[i],
                    showDivider: i < rows.length - 1,
                    onReview: () => onReview(rows[i]),
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
  static const int reportId = 9;
  static const int shop = 33;
  static const int category = 13;
  static const int submitted = 10;
  static const int status = 11;
  static const int admin = 12;
  static const double action = 80;
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow();

  @override
  Widget build(BuildContext context) {
    Widget cell(String label, int flex) => Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Text(label, style: AppTextStyles.tableHeader),
      ),
    );
    return AppTableHeader(
      showTopBorder: false,
      child: Row(
        children: [
          cell(ReportsStrings.reportId, _Columns.reportId),
          cell(ReportsStrings.reportingShop, _Columns.shop),
          cell(ReportsStrings.category, _Columns.category),
          cell(ReportsStrings.submitted, _Columns.submitted),
          cell(ReportsStrings.status, _Columns.status),
          cell(ReportsStrings.assignedAdmin, _Columns.admin),
          const SizedBox(width: _Columns.action),
        ],
      ),
    );
  }
}

class _ReportRow extends StatelessWidget {
  const _ReportRow({
    required this.item,
    required this.showDivider,
    required this.onReview,
  });

  final ShopReport item;
  final bool showDivider;
  final VoidCallback onReview;

  @override
  Widget build(BuildContext context) {
    Widget text(
      String value,
      int flex, {
      TextStyle style = AppTextStyles.tableCell,
    }) => Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Text(value, style: style),
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
          text(
            item.reportId,
            _Columns.reportId,
            style: AppTextStyles.titleSmall,
          ),
          text(item.shopName, _Columns.shop),
          text(item.category.label, _Columns.category),
          text(AppFormatters.date(item.submittedAt), _Columns.submitted),
          Expanded(
            flex: _Columns.status,
            child: Align(
              alignment: Alignment.centerLeft,
              child: ReportStatusPill(status: item.status),
            ),
          ),
          text(item.assignedAdmin ?? ReportsStrings.unassigned, _Columns.admin),
          SizedBox(
            width: _Columns.action,
            child: Align(
              alignment: Alignment.centerRight,
              child: AppSecondaryButton(
                label: ReportsStrings.review,
                onPressed: onReview,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
