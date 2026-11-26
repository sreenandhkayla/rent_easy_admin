import 'package:flutter/material.dart';

import '../../../../core/resources/strings/subscriptions_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../data/models/plan_definition.dart';
import 'plan_labels.dart';

class PlanPrice extends StatelessWidget {
  const PlanPrice({
    super.key,
    required this.price,
    required this.billingPeriod,
    this.offerPercentage = 0,
  });

  final int? price;
  final PlanBillingPeriod billingPeriod;
  final int offerPercentage;

  @override
  Widget build(BuildContext context) {
    final int? regular = price;
    final bool hasDiscount = regular != null && offerPercentage > 0;
    final int? payable = regular == null
        ? null
        : PlanDefinition.offerPriceFor(regular, offerPercentage);
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.end,
      spacing: 8,
      runSpacing: 4,
      children: [
        Text(
          payable == null
              ? SubscriptionsStrings.previewPrice
              : AppFormatters.rupees(payable),
          style: AppTextStyles.statValueMedium,
        ),
        if (hasDiscount)
          Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Text(
              AppFormatters.rupees(regular),
              style: AppTextStyles.priceStrikethrough,
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Text(
            PlanLabels.perPeriod(billingPeriod),
            style: AppTextStyles.bodyCaption,
          ),
        ),
      ],
    );
  }
}
