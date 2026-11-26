import 'package:flutter/material.dart';

import '../../../../core/resources/strings/subscriptions_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_secondary_button.dart';
import '../../data/models/plan_definition.dart';
import 'plan_benefit_row.dart';
import 'plan_labels.dart';
import 'plan_status_pill.dart';

class PlanCard extends StatelessWidget {
  const PlanCard({
    super.key,
    required this.plan,
    required this.onViewDetails,
    required this.onEdit,
  });

  final PlanDefinition plan;
  final VoidCallback onViewDetails;
  final VoidCallback onEdit;

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
          const SizedBox(height: 14),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.end,
            spacing: 6,
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
              Text(
                AppFormatters.number(plan.subscribedShops),
                style: AppTextStyles.titleSmall,
              ),
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
              const SizedBox(width: 8),
              AppSecondaryButton(
                label: SubscriptionsStrings.edit,
                icon: Icons.edit_outlined,
                onPressed: onEdit,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
