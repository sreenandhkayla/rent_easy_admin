import 'package:flutter/material.dart';

import '../../../../core/resources/strings/shops_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/widgets/app_activity_timeline.dart';
import '../../../../core/widgets/app_card.dart';
import '../../data/models/shop_details.dart';

class ShopActivityCard extends StatelessWidget {
  const ShopActivityCard({super.key, required this.activities});

  final List<ShopActivity> activities;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            ShopsStrings.administrativeActivity,
            style: AppTextStyles.cardTitle,
          ),
          const SizedBox(height: 16),
          AppActivityTimeline(
            entries: [
              for (final ShopActivity activity in activities)
                AppTimelineEntry(
                  title: activity.title,
                  subtitle:
                      '${activity.actor} · '
                      '${activity.hasTime ? AppFormatters.timestamp(activity.at) : AppFormatters.date(activity.at)}',
                  detail: activity.reason == null
                      ? null
                      : ShopsStrings.reasonLine(activity.reason!),
                  isHighlighted: activity.isHighlighted,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
