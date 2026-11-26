import 'package:flutter/material.dart';

import '../../../../core/resources/strings/subscriptions_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_secondary_button.dart';

class PlanActionsCard extends StatelessWidget {
  const PlanActionsCard({
    super.key,
    required this.isArchived,
    required this.onEdit,
    required this.onArchive,
  });

  final bool isArchived;
  final VoidCallback onEdit;
  final VoidCallback onArchive;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            SubscriptionsStrings.planActions,
            style: AppTextStyles.cardTitle,
          ),
          const SizedBox(height: 14),
          AppSecondaryButton(
            label: SubscriptionsStrings.editPlan,
            icon: Icons.edit_outlined,
            isExpanded: true,
            labelStyle: AppTextStyles.actionLabel,
            onPressed: onEdit,
          ),
          if (!isArchived) ...[
            const SizedBox(height: 10),
            AppSecondaryButton(
              label: SubscriptionsStrings.archivePlan,
              icon: Icons.archive_outlined,
              isDestructive: true,
              isExpanded: true,
              labelStyle: AppTextStyles.actionLabel,
              onPressed: onArchive,
            ),
          ],
          const SizedBox(height: 12),
          Text(
            isArchived
                ? SubscriptionsStrings.archivedPlanNote
                : SubscriptionsStrings.archivePlanNote,
            style: AppTextStyles.meta,
          ),
        ],
      ),
    );
  }
}
