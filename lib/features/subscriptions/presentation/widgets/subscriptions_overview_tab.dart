import 'package:flutter/material.dart';

import '../../data/models/subscription_overview.dart';
import 'plan_distribution_card.dart';
import 'renewal_flow_card.dart';
import 'subscription_revenue_card.dart';
import 'subscription_rules_card.dart';
import 'subscription_stats_grid.dart';

class SubscriptionsOverviewTab extends StatelessWidget {
  const SubscriptionsOverviewTab({
    super.key,
    required this.overview,
    required this.onViewPayments,
    required this.onManagePlans,
  });

  static const double _twoColumnBreakpoint = 900;

  final SubscriptionOverview overview;
  final VoidCallback onViewPayments;
  final VoidCallback onManagePlans;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SubscriptionStatsGrid(overview: overview),
        const SizedBox(height: 16),
        SubscriptionRevenueCard(
          overview: overview,
          onViewPayments: onViewPayments,
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            const Widget rules = SubscriptionRulesCard();
            const Widget renewal = RenewalFlowCard();
            if (constraints.maxWidth < _twoColumnBreakpoint) {
              return const Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [rules, SizedBox(height: 16), renewal],
              );
            }
            return const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: rules),
                SizedBox(width: 16),
                Expanded(child: renewal),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        PlanDistributionCard(overview: overview, onManagePlans: onManagePlans),
      ],
    );
  }
}
