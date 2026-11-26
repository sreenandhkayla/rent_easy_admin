import 'package:flutter/material.dart';

import '../../../../core/resources/strings/reports_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/widgets/app_activity_timeline.dart';
import '../../../../core/widgets/app_card.dart';
import '../../data/models/shop_report.dart';

class ReportHistoryCard extends StatelessWidget {
  const ReportHistoryCard({super.key, required this.report});

  final ShopReport report;

  AppTimelineEntry _entry(ReportEvent event) {
    final String? note = event.note;
    final String title = switch (event.type) {
      ReportEventType.submitted => ReportsStrings.eventSubmitted,
      ReportEventType.reviewStarted => ReportsStrings.eventReviewStarted,
      ReportEventType.assigned => ReportsStrings.eventAssigned(note ?? ''),
      ReportEventType.unassigned => ReportsStrings.eventUnassigned,
      ReportEventType.clarificationRequested =>
        ReportsStrings.eventClarification,
      ReportEventType.resolved => ReportsStrings.eventResolved,
      ReportEventType.dismissed => ReportsStrings.eventDismissed,
      ReportEventType.correctionReceived =>
        ReportsStrings.eventCorrectionReceived,
      ReportEventType.correctionReviewed =>
        ReportsStrings.eventCorrectionReviewed,
    };
    final String subtitle = switch (event.type) {
      ReportEventType.submitted =>
        note ?? ReportsStrings.submittedBy(report.shopName),
      ReportEventType.correctionReceived => ReportsStrings.via(event.actor),
      ReportEventType.correctionReviewed when note != null =>
        ReportsStrings.actorNote(event.actor, note),
      _ => event.actor,
    };
    return AppTimelineEntry(
      title: title,
      subtitle: subtitle,
      detail: AppFormatters.timestamp(event.at),
      dotColor: AppColors.ink,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            ReportsStrings.reviewHistory,
            style: AppTextStyles.cardTitle,
          ),
          const SizedBox(height: 16),
          AppActivityTimeline(
            entries: [
              for (final ReportEvent event in report.history) _entry(event),
            ],
          ),
        ],
      ),
    );
  }
}
