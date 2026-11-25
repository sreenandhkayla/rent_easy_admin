import 'package:flutter/material.dart';

import '../../../../core/resources/strings/subscriptions_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_progress_row.dart';
import '../../../../core/widgets/app_text_link.dart';
import '../../data/models/subscription_overview.dart';

class PlanDistributionCard extends StatelessWidget {
  const PlanDistributionCard({
    super.key,
    required this.overview,
    required this.onManagePlans,
  });

  final SubscriptionOverview overview;
  final VoidCallback onManagePlans;

  @override
  Widget build(BuildContext context) {
    final int total = overview.planShopTotal;
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  SubscriptionsStrings.planDistribution,
                  style: AppTextStyles.cardTitle,
                ),
              ),
              AppTextLink(
                label: SubscriptionsStrings.managePlans,
                onTap: onManagePlans,
              ),
            ],
          ),
          for (final PlanFigure figure in overview.shopsByPlan) ...[
            const SizedBox(height: 14),
            AppProgressRow(
              label: figure.plan,
              trailing: SubscriptionsStrings.shopsAndShare(
                figure.value,
                AppFormatters.percent(total == 0 ? 0 : figure.value / total),
              ),
              fraction: total == 0 ? 0 : figure.value / total,
            ),
          ],
        ],
      ),
    );
  }
}
