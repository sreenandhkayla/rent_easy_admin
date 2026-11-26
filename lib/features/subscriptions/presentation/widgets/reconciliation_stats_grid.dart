import 'package:flutter/material.dart';

import '../../../../core/resources/strings/subscriptions_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/widgets/app_responsive_grid.dart';
import '../../../../core/widgets/app_stat_card.dart';
import '../../data/models/reconciliation_summary.dart';

class ReconciliationStatsGrid extends StatelessWidget {
  const ReconciliationStatsGrid({super.key, required this.summary});

  final ReconciliationSummary summary;

  @override
  Widget build(BuildContext context) {
    return AppResponsiveGrid(
      minItemWidth: 200,
      children: [
        AppStatCard(
          label: SubscriptionsStrings.matched,
          value: AppFormatters.number(summary.matched),
          caption: SubscriptionsStrings.matchedCaption,
          dotColor: AppColors.statusGreen,
        ),
        AppStatCard(
          label: SubscriptionsStrings.unmatched,
          value: AppFormatters.number(summary.unmatched),
          caption: SubscriptionsStrings.unmatchedCaption,
          dotColor: AppColors.statusRed,
        ),
        AppStatCard(
          label: SubscriptionsStrings.pending,
          value: AppFormatters.number(summary.pending),
          caption: SubscriptionsStrings.pendingSettlementCaption,
          dotColor: AppColors.statusAmber,
        ),
        AppStatCard(
          label: SubscriptionsStrings.refunds,
          value: AppFormatters.number(summary.refunds),
          caption: SubscriptionsStrings.refundsCaption,
        ),
      ],
    );
  }
}
