import 'package:flutter/material.dart';

import '../../../../core/resources/strings/subscriptions_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_secondary_button.dart';

class PlanActionsCard extends StatelessWidget {
  const PlanActionsCard({
    super.key,
    required this.isArchived,
    this.onEdit,
    this.onArchive,
  });

  final bool isArchived;
  final VoidCallback? onEdit;
  final VoidCallback? onArchive;

  bool get _canManage => onEdit != null || onArchive != null;

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
          if (onEdit case final VoidCallback edit)
            AppSecondaryButton(
              label: SubscriptionsStrings.editPlan,
              icon: Icons.edit_outlined,
              isExpanded: true,
              labelStyle: AppTextStyles.actionLabel,
              onPressed: edit,
            ),
          if (onArchive case final VoidCallback archive when !isArchived) ...[
            const SizedBox(height: 10),
            AppSecondaryButton(
              label: SubscriptionsStrings.archivePlan,
              icon: Icons.archive_outlined,
              isDestructive: true,
              isExpanded: true,
              labelStyle: AppTextStyles.actionLabel,
              onPressed: archive,
            ),
          ],
          if (_canManage) const SizedBox(height: 12),
          Text(
            !_canManage
                ? SubscriptionsStrings.managePlansDenied
                : isArchived
                ? SubscriptionsStrings.archivedPlanNote
                : SubscriptionsStrings.archivePlanNote,
            style: AppTextStyles.meta,
          ),
        ],
      ),
    );
  }
}
