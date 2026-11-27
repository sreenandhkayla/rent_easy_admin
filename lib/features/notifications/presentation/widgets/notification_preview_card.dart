import 'package:flutter/material.dart';

import '../../../../core/resources/strings/app_strings.dart';
import '../../../../core/resources/strings/notifications_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/widgets/app_brand_logo.dart';
import '../../../../core/widgets/app_card.dart';
import '../../data/models/admin_notification.dart';
import '../state/create_notification_state.dart';

class NotificationPreviewCard extends StatelessWidget {
  const NotificationPreviewCard({super.key, required this.state});

  static const double _phoneWidth = 240;

  final CreateNotificationState state;

  String get _recipients {
    final AudienceReach? reach = state.reachOf(state.audience);
    if (reach == null) return NotificationsStrings.counting;
    if (reach.owners case final int owners) {
      return NotificationsStrings.ownersCount(AppFormatters.number(owners));
    }
    return NotificationsStrings.countedWhenSent;
  }

  @override
  Widget build(BuildContext context) {
    final String title = state.title.trim();
    final String message = state.message.trim();
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Row(
            children: [
              Expanded(
                child: Text(
                  NotificationsStrings.preview,
                  style: AppTextStyles.cardTitle,
                ),
              ),
              Icon(
                Icons.visibility_outlined,
                size: 14,
                color: AppColors.textSecondary,
              ),
              SizedBox(width: 6),
              Text(
                NotificationsStrings.ownerAppPush,
                style: AppTextStyles.meta,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _phoneWidth),
              child: Container(
                padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
                decoration: BoxDecoration(
                  color: AppColors.contentBackground,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.checkboxBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              NotificationsStrings.previewTime,
                              style: AppTextStyles.titleSmall,
                            ),
                          ),
                          Text(
                            AppStrings.appName,
                            style: AppTextStyles.bodyCaption,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(
                          AppTheme.radiusLarge,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const AppBrandLogo(showText: false, size: 24),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        title.isEmpty
                                            ? NotificationsStrings.previewTitle
                                            : title,
                                        style: AppTextStyles.titleSmall,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Text(
                                      NotificationsStrings.previewNow,
                                      style: AppTextStyles.meta,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  message.isEmpty
                                      ? NotificationsStrings.previewMessage
                                      : message,
                                  style: AppTextStyles.meta,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      state.type.label,
                      style: AppTextStyles.meta,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _SummaryLine(
            label: NotificationsStrings.audience,
            value: state.audience.label,
          ),
          _SummaryLine(
            label: NotificationsStrings.uniqueRecipients,
            value: _recipients,
          ),
        ],
      ),
    );
  }
}

class _SummaryLine extends StatelessWidget {
  const _SummaryLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(child: Text(label, style: AppTextStyles.bodySmall)),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              style: AppTextStyles.titleSmall,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
