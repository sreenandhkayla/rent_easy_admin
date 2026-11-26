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
import 'plan_offer_tag.dart';
import 'plan_price.dart';
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
                child: PlanPrice(
                  price: plan.price,
                  billingPeriod: plan.billingPeriod,
                  offerPercentage: plan.offerPercentage,
                ),
              ),
              const SizedBox(width: 12),
              PlanStatusPill(status: plan.status),
            ],
          ),
          if (plan.offerTag case final String tag) ...[
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: PlanOfferTag(label: tag),
            ),
          ],
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
                label: SubscriptionsStrings.offer,
                value: plan.hasDiscount
                    ? SubscriptionsStrings.offerSummary(
                        plan.offerPercentage,
                        AppFormatters.rupees(plan.offerPrice),
                      )
                    : SubscriptionsStrings.noOffer,
              ),
              AppDetailField(
                label: SubscriptionsStrings.subscribedShops,
                value: switch (plan.subscribedShops) {
                  final int count => AppFormatters.number(count),
                  null => SubscriptionsStrings.emptyValue,
                },
              ),
              AppDetailField(
                label: SubscriptionsStrings.lastUpdated,
                value: switch (plan.updatedAt) {
                  final DateTime date => AppFormatters.date(date),
                  null => SubscriptionsStrings.emptyValue,
                },
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
