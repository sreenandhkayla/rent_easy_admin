import 'package:flutter/material.dart';

import '../../../../core/resources/images/app_images.dart';
import '../../../../core/resources/strings/subscriptions_strings.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_responsive_grid.dart';
import '../../data/models/plan_definition.dart';
import 'plan_card.dart';
import 'plans_toolbar.dart';

class PlansTab extends StatelessWidget {
  const PlansTab({
    super.key,
    required this.plans,
    required this.onCreatePlan,
    required this.onViewDetails,
    required this.onEdit,
  });

  final List<PlanDefinition> plans;
  final VoidCallback onCreatePlan;
  final ValueChanged<PlanDefinition> onViewDetails;
  final ValueChanged<PlanDefinition> onEdit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PlansToolbar(onCreatePlan: onCreatePlan),
        const SizedBox(height: 16),
        if (plans.isEmpty)
          const AppCard(
            child: AppEmptyState(
              svgIcon: AppImages.subscriptionIcon,
              title: SubscriptionsStrings.noPlansTitle,
              message: SubscriptionsStrings.noPlansMessage,
            ),
          )
        else
          AppResponsiveGrid(
            minItemWidth: 280,
            maxColumns: 3,
            spacing: 16,
            children: [
              for (final PlanDefinition plan in plans)
                PlanCard(
                  plan: plan,
                  onViewDetails: () => onViewDetails(plan),
                  onEdit: () => onEdit(plan),
                ),
            ],
          ),
      ],
    );
  }
}
