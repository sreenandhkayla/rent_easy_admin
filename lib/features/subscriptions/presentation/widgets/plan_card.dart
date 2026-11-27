import 'package:flutter/material.dart';

import '../../../../core/resources/strings/subscriptions_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_secondary_button.dart';
import '../../data/models/plan_definition.dart';
import 'plan_benefit_row.dart';
import 'plan_offer_tag.dart';
import 'plan_price.dart';
import 'plan_status_pill.dart';

class PlanCard extends StatelessWidget {
  const PlanCard({
    super.key,
    required this.plan,
    required this.onViewDetails,
    this.onEdit,
  });

  final PlanDefinition plan;
  final VoidCallback onViewDetails;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Text(plan.name, style: AppTextStyles.cardTitle)),
              const SizedBox(width: 12),
              PlanStatusPill(status: plan.status),
            ],
          ),
          if (plan.offerTag case final String tag) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: PlanOfferTag(label: tag),
            ),
          ],
          const SizedBox(height: 14),
          PlanPrice(
            price: plan.price,
            billingPeriod: plan.billingPeriod,
            offerPercentage: plan.offerPercentage,
          ),
          if (plan.description.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(plan.description, style: AppTextStyles.bodySmall),
          ],
          const Divider(height: 28, color: AppColors.divider),
          for (final String feature in plan.highlights)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: PlanBenefitRow(label: feature),
            ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Expanded(
                child: Text(
                  SubscriptionsStrings.subscribedShops,
                  style: AppTextStyles.bodySmall,
                ),
              ),
              const SizedBox(width: 12),
              Text(switch (plan.subscribedShops) {
                final int count => AppFormatters.number(count),
                null => SubscriptionsStrings.emptyValue,
              }, style: AppTextStyles.titleSmall),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: AppSecondaryButton(
                  label: SubscriptionsStrings.viewDetails,
                  isExpanded: true,
                  onPressed: onViewDetails,
                ),
              ),
              if (onEdit case final VoidCallback edit) ...[
                const SizedBox(width: 8),
                AppSecondaryButton(
                  label: SubscriptionsStrings.edit,
                  icon: Icons.edit_outlined,
                  onPressed: edit,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
