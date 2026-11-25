import 'package:flutter/material.dart';

import '../../../../core/resources/strings/shop_owners_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/widgets/app_activity_timeline.dart';
import '../../../../core/widgets/app_card.dart';
import '../../data/models/owner_details.dart';

class OwnerActivityCard extends StatelessWidget {
  const OwnerActivityCard({super.key, required this.activities});

  final List<OwnerActivity> activities;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            ShopOwnersStrings.administrativeActivity,
            style: AppTextStyles.cardTitle,
          ),
          const SizedBox(height: 16),
          AppActivityTimeline(
            entries: [
              for (final OwnerActivity activity in activities)
                AppTimelineEntry(
                  title: activity.title,
                  subtitle:
                      '${activity.actor} · '
                      '${activity.hasTime ? AppFormatters.timestamp(activity.at) : AppFormatters.date(activity.at)}',
                ),
            ],
          ),
        ],
      ),
    );
  }
}
