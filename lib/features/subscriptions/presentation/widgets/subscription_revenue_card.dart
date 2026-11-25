import 'package:flutter/material.dart';

import '../../../../core/resources/strings/subscriptions_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_progress_row.dart';
import '../../../../core/widgets/app_responsive_grid.dart';
import '../../../../core/widgets/app_status_dot.dart';
import '../../../../core/widgets/app_text_link.dart';
import '../../data/models/subscription_overview.dart';
import 'monthly_revenue_chart.dart';

class SubscriptionRevenueCard extends StatelessWidget {
  const SubscriptionRevenueCard({
    super.key,
    required this.overview,
    required this.onViewPayments,
  });

  static const double _twoColumnBreakpoint = 760;

  final SubscriptionOverview overview;
  final VoidCallback onViewPayments;

  @override
  Widget build(BuildContext context) {
    final double change = overview.monthOverMonthChange;
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      SubscriptionsStrings.subscriptionRevenue,
                      style: AppTextStyles.cardTitle,
                    ),
                    SizedBox(height: 4),
                    Text(
                      SubscriptionsStrings.subscriptionRevenueNote,
                      style: AppTextStyles.meta,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              AppTextLink(
                label: SubscriptionsStrings.viewPayments,
                onTap: onViewPayments,
              ),
            ],
          ),
          const SizedBox(height: 16),
          AppResponsiveGrid(
            minItemWidth: 180,
            spacing: 12,
            children: [
              _RevenueTile(
                label: SubscriptionsStrings.thisMonth(overview.currentMonth),
                value: AppFormatters.rupees(overview.thisMonthRevenue),
                caption: SubscriptionsStrings.changeVs(
                  change,
                  overview.lastMonth,
                ),
                captionStyle: change >= 0
                    ? AppTextStyles.metaPositive
                    : AppTextStyles.meta,
                dotColor: AppColors.statusGreen,
              ),
              _RevenueTile(
                label: SubscriptionsStrings.lastMonth(overview.lastMonth),
                value: AppFormatters.rupees(overview.lastMonthRevenue),
                caption: SubscriptionsStrings.verifiedPayments,
              ),
              _RevenueTile(
                label: SubscriptionsStrings.thisYear(overview.currentMonth),
                value: AppFormatters.rupees(overview.yearToDateRevenue),
                caption: SubscriptionsStrings.yearRange(overview.currentMonth),
              ),
              _RevenueTile(
                label: SubscriptionsStrings.totalRevenueEarned,
                value: AppFormatters.rupees(overview.lifetimeRevenue),
                caption: SubscriptionsStrings.allTimeCaption,
                dotColor: AppColors.statusCoral,
              ),
            ],
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final Widget chart = MonthlyRevenueChart(
                months: overview.monthlyRevenue,
              );
              final Widget byPlan = _RevenueByPlan(overview: overview);
              if (constraints.maxWidth < _twoColumnBreakpoint) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [chart, const SizedBox(height: 24), byPlan],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: chart),
                  const SizedBox(width: 24),
                  Expanded(child: byPlan),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _RevenueTile extends StatelessWidget {
  const _RevenueTile({
    required this.label,
    required this.value,
    required this.caption,
    this.captionStyle = AppTextStyles.meta,
    this.dotColor,
  });

  final String label;
  final String value;
  final String caption;
  final TextStyle captionStyle;
  final Color? dotColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.contentBackground,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (dotColor != null) ...[
                AppStatusDot(color: dotColor!),
                const SizedBox(width: 8),
              ],
              Expanded(child: Text(label, style: AppTextStyles.labelMuted)),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: AppTextStyles.statValueMedium),
          const SizedBox(height: 6),
          Text(caption, style: captionStyle),
        ],
      ),
    );
  }
}

class _RevenueByPlan extends StatelessWidget {
  const _RevenueByPlan({required this.overview});

  final SubscriptionOverview overview;

  @override
  Widget build(BuildContext context) {
    final int total = overview.thisMonthRevenue;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                SubscriptionsStrings.revenueByPlan(overview.currentMonth),
                style: AppTextStyles.labelRegular,
              ),
            ),
            Text(AppFormatters.rupees(total), style: AppTextStyles.meta),
          ],
        ),
        const SizedBox(height: 14),
        for (final PlanFigure figure in overview.revenueByPlan) ...[
          AppProgressRow(
            label: figure.plan,
            trailing: SubscriptionsStrings.amountAndShare(
              AppFormatters.rupees(figure.value),
              AppFormatters.percent(total == 0 ? 0 : figure.value / total),
            ),
            fraction: total == 0 ? 0 : figure.value / total,
          ),
          const SizedBox(height: 14),
        ],
        const Divider(height: 8, color: AppColors.divider),
        const SizedBox(height: 10),
        _SummaryLine(
          label: SubscriptionsStrings.averageRevenuePerShop,
          value: AppFormatters.rupees(overview.averageRevenuePerShop),
        ),
        const SizedBox(height: 10),
        _SummaryLine(
          label: SubscriptionsStrings.notCounted,
          value: SubscriptionsStrings.paymentCounts(
            overview.pendingPayments,
            overview.failedPaymentsThisMonth,
          ),
        ),
      ],
    );
  }
}

class _SummaryLine extends StatelessWidget {
  const _SummaryLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label, style: AppTextStyles.bodyCaption)),
        const SizedBox(width: 12),
        Text(value, style: AppTextStyles.labelRegular),
      ],
    );
  }
}
