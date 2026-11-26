import 'package:flutter/material.dart';

import '../../../../core/resources/strings/subscriptions_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../state/create_plan_state.dart';
import 'plan_benefit_row.dart';
import 'plan_labels.dart';

class PlanPreviewCard extends StatelessWidget {
  const PlanPreviewCard({super.key, required this.state});

  final CreatePlanState state;

  @override
  Widget build(BuildContext context) {
    final String name = state.name.trim();
    final String description = state.description.trim();
    final int? price = state.priceValue;
    final List<String> benefits = [
      ...state.benefitLines,
      if (state.limit.trim().isNotEmpty &&
          !state.benefitLines.contains(state.limit.trim()))
        state.limit.trim(),
    ];
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            SubscriptionsStrings.preview,
            style: AppTextStyles.cardTitle,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.contentBackground,
              borderRadius: BorderRadius.circular(AppTheme.radiusCard),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.isEmpty ? SubscriptionsStrings.previewName : name,
                  style: AppTextStyles.cardTitle,
                ),
                const SizedBox(height: 12),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.end,
                  spacing: 8,
                  children: [
                    Text(
                      price == null
                          ? SubscriptionsStrings.previewPrice
                          : AppFormatters.rupees(price),
                      style: AppTextStyles.statValueMedium,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        PlanLabels.perPeriod(state.billingPeriod),
                        style: AppTextStyles.bodyCaption,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  description.isEmpty
                      ? SubscriptionsStrings.previewDescription
                      : description,
                  style: AppTextStyles.bodyCaption,
                ),
                const SizedBox(height: 12),
                for (final String benefit
                    in benefits.isEmpty
                        ? const [SubscriptionsStrings.previewBenefits]
                        : benefits)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: PlanBenefitRow(
                      label: benefit,
                      style: AppTextStyles.bodyCaptionPrimary,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            SubscriptionsStrings.previewBillingNote,
            style: AppTextStyles.bodyCaption,
          ),
        ],
      ),
    );
  }
}
