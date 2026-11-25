import 'package:flutter/material.dart';

import '../../../../core/resources/images/app_images.dart';
import '../../../../core/resources/strings/subscriptions_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_icon_circle.dart';
import '../../../../core/widgets/app_status_pill.dart';

class SubscriptionRulesCard extends StatelessWidget {
  const SubscriptionRulesCard({super.key});

  static const List<_Rule> _rules = [
    _Rule(
      svgIcon: AppImages.storeIcon,
      title: SubscriptionsStrings.ruleEntitlementTitle,
      body: SubscriptionsStrings.ruleEntitlementBody,
    ),
    _Rule(
      svgIcon: AppImages.shieldIcon,
      title: SubscriptionsStrings.ruleVerifiedTitle,
      body: SubscriptionsStrings.ruleVerifiedBody,
    ),
    _Rule(
      svgIcon: AppImages.restrictIcon,
      title: SubscriptionsStrings.ruleExpiryTitle,
      body: SubscriptionsStrings.ruleExpiryBody,
    ),
    _Rule(
      icon: Icons.schedule,
      title: SubscriptionsStrings.ruleReturnsTitle,
      body: SubscriptionsStrings.ruleReturnsBody,
      needsApproval: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            SubscriptionsStrings.subscriptionRules,
            style: AppTextStyles.cardTitle,
          ),
          const SizedBox(height: 8),
          for (int i = 0; i < _rules.length; i++) ...[
            if (i > 0) const Divider(height: 1, color: AppColors.divider),
            _RuleTile(rule: _rules[i]),
          ],
        ],
      ),
    );
  }
}

class _Rule {
  const _Rule({
    required this.title,
    required this.body,
    this.icon,
    this.svgIcon,
    this.needsApproval = false,
  });

  final String title;
  final String body;
  final IconData? icon;
  final String? svgIcon;
  final bool needsApproval;
}

class _RuleTile extends StatelessWidget {
  const _RuleTile({required this.rule});

  final _Rule rule;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppIconCircle(icon: rule.icon, svgIcon: rule.svgIcon),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(rule.title, style: AppTextStyles.titleSmall),
                    if (rule.needsApproval)
                      const AppStatusPill(
                        label: SubscriptionsStrings.needsApproval,
                        color: AppColors.pillAmberText,
                        backgroundColor: AppColors.pillAmberBackground,
                        showDot: false,
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(rule.body, style: AppTextStyles.meta),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
