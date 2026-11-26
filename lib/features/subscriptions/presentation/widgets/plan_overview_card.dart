import 'package:flutter/material.dart';

import '../../../../core/resources/strings/subscriptions_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_detail_field.dart';
import '../../../../core/widgets/app_responsive_grid.dart';
import '../../data/models/plan_definition.dart';
import 'plan_benefit_row.dart';
import 'plan_labels.dart';
import 'plan_status_pill.dart';

class PlanOverviewCard extends StatelessWidget {
  const PlanOverviewCard({super.key, required this.plan});

  final PlanDefinition plan;

  @override
  Widget build(BuildContext context) {
    final List<String> benefits = plan.highlights;
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.end,
                  spacing: 8,
                  children: [
                    Text(
                      AppFormatters.rupees(plan.price),
                      style: AppTextStyles.statValueMedium,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        PlanLabels.perPeriod(plan.billingPeriod),
                        style: AppTextStyles.bodyCaption,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              PlanStatusPill(status: plan.status),
            ],
          ),
          if (plan.description.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(plan.description, style: AppTextStyles.bodySmall),
          ],
          const Divider(height: 36, color: AppColors.divider),
          AppResponsiveGrid(
            minItemWidth: 180,
            maxColumns: 2,
            spacing: 18,
            children: [
              AppDetailField(
                label: SubscriptionsStrings.billingDuration,
                value: PlanLabels.billingOption(plan.billingPeriod),
              ),
              AppDetailField(
                label: SubscriptionsStrings.planLimits,
                value: plan.limit ?? SubscriptionsStrings.emptyValue,
              ),
              AppDetailField(
                label: SubscriptionsStrings.subscribedShops,
                value: AppFormatters.number(plan.subscribedShops),
              ),
              AppDetailField(
                label: SubscriptionsStrings.lastUpdated,
                value: AppFormatters.date(plan.updatedAt),
              ),
            ],
          ),
          const SizedBox(height: 22),
          const Text(
            SubscriptionsStrings.planBenefits,
            style: AppTextStyles.titleSmall,
          ),
          const SizedBox(height: 10),
          if (benefits.isEmpty)
            const Text(
              SubscriptionsStrings.noBenefits,
              style: AppTextStyles.bodySmall,
            )
          else
            for (final String benefit in benefits)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: PlanBenefitRow(label: benefit),
              ),
        ],
      ),
    );
  }
}
