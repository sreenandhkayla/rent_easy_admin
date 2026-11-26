import 'package:flutter/material.dart';

import '../../../../core/resources/strings/analytics_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_progress_row.dart';
import '../../../../core/widgets/app_responsive_grid.dart';
import '../../data/models/analytics_snapshot.dart';

class AnalyticsBreakdownGrid extends StatelessWidget {
  const AnalyticsBreakdownGrid({super.key, required this.snapshot});

  final AnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return AppResponsiveGrid(
      minItemWidth: 260,
      maxColumns: 3,
      children: [
        _PlanDistributionCard(snapshot: snapshot),
        _ShopStatusCard(status: snapshot.shopStatus),
        _SubscriptionFiguresCard(
          figures: snapshot.subscriptionFigures,
          month: snapshot.currentMonth,
        ),
      ],
    );
  }
}

class _BreakdownCard extends StatelessWidget {
  const _BreakdownCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: AppTextStyles.cardTitle),
          const SizedBox(height: 4),
          ...children,
        ],
      ),
    );
  }
}

class _ShareRow extends StatelessWidget {
  const _ShareRow({
    required this.label,
    required this.value,
    required this.total,
  });

  final String label;
  final int value;
  final int total;

  @override
  Widget build(BuildContext context) {
    final double fraction = total == 0 ? 0 : value / total;
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: AppProgressRow(
        label: label,
        trailing: AnalyticsStrings.countAndShare(
          AppFormatters.number(value),
          AppFormatters.percent(fraction),
        ),
        fraction: fraction,
        labelStyle: AppTextStyles.titleSmall,
      ),
    );
  }
}

class _PlanDistributionCard extends StatelessWidget {
  const _PlanDistributionCard({required this.snapshot});

  final AnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return _BreakdownCard(
      title: AnalyticsStrings.planDistribution,
      children: [
        for (final AnalyticsShare share in snapshot.planShares)
          _ShareRow(
            label: share.label,
            value: share.value,
            total: snapshot.planTotal,
          ),
      ],
    );
  }
}

class _ShopStatusCard extends StatelessWidget {
  const _ShopStatusCard({required this.status});

  final ShopStatusBreakdown status;

  @override
  Widget build(BuildContext context) {
    return _BreakdownCard(
      title: AnalyticsStrings.shopStatus,
      children: [
        _ShareRow(
          label: AnalyticsStrings.shopActive,
          value: status.active,
          total: status.total,
        ),
        _ShareRow(
          label: AnalyticsStrings.shopInactive,
          value: status.inactive,
          total: status.total,
        ),
        _ShareRow(
          label: AnalyticsStrings.shopRestricted,
          value: status.restricted,
          total: status.total,
        ),
        const SizedBox(height: 16),
        const Text(AnalyticsStrings.shopStatusNote, style: AppTextStyles.meta),
      ],
    );
  }
}

class _SubscriptionFiguresCard extends StatelessWidget {
  const _SubscriptionFiguresCard({required this.figures, required this.month});

  final SubscriptionFigures figures;
  final DateTime month;

  @override
  Widget build(BuildContext context) {
    final List<(String, String)> rows = [
      (AnalyticsStrings.renewals, AppFormatters.number(figures.renewals)),
      (AnalyticsStrings.expiries, AppFormatters.number(figures.expiries)),
      (
        AnalyticsStrings.expiringSoon,
        AppFormatters.number(figures.expiringSoon),
      ),
      (
        AnalyticsStrings.paymentSuccessRate,
        AppFormatters.percent(figures.paymentSuccessRate),
      ),
      (
        AnalyticsStrings.failedPayments,
        AppFormatters.number(figures.failedPayments),
      ),
      (
        AnalyticsStrings.multiShopOwners,
        AppFormatters.number(figures.multiShopOwners),
      ),
    ];
    return _BreakdownCard(
      title: AnalyticsStrings.subscriptionsAndOwners(month),
      children: [
        const SizedBox(height: 6),
        for (final (String label, String value) in rows)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                Expanded(child: Text(label, style: AppTextStyles.bodySmall)),
                const SizedBox(width: 12),
                Text(value, style: AppTextStyles.titleSmall),
              ],
            ),
          ),
      ],
    );
  }
}
