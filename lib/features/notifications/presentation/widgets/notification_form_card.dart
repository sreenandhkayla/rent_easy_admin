import 'package:flutter/material.dart';

import '../../../../core/resources/images/app_images.dart';
import '../../../../core/resources/strings/notifications_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_dropdown.dart';
import '../../../../core/widgets/app_labeled_field.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_radio_card.dart';
import '../../../../core/widgets/app_responsive_grid.dart';
import '../../../../core/widgets/app_secondary_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_text_link.dart';
import '../../data/models/admin_notification.dart';
import '../state/create_notification_state.dart';

class NotificationFormCard extends StatelessWidget {
  const NotificationFormCard({
    super.key,
    required this.state,
    required this.reachOf,
    required this.onTypeChanged,
    required this.onTitleChanged,
    required this.onMessageChanged,
    required this.onAudienceChanged,
    required this.onDeliveryChanged,
    required this.onPickSchedule,
    required this.onCancel,
    required this.onSaveDraft,
    required this.onReview,
  });

  static const int titleMaxLength = 65;
  static const int messageMaxLength = 240;

  final CreateNotificationState state;
  final AudienceReach Function(NotificationAudience audience) reachOf;
  final ValueChanged<NotificationType> onTypeChanged;
  final ValueChanged<String> onTitleChanged;
  final ValueChanged<String> onMessageChanged;
  final ValueChanged<NotificationAudience> onAudienceChanged;
  final ValueChanged<NotificationDelivery> onDeliveryChanged;
  final VoidCallback onPickSchedule;
  final VoidCallback onCancel;
  final VoidCallback onSaveDraft;
  final VoidCallback onReview;

  String _audienceNote(NotificationAudience audience) {
    final AudienceReach reach = reachOf(audience);
    final int? shops = reach.shops;
    final int? owners = reach.owners;
    return switch (audience) {
      NotificationAudience.allOwners =>
        NotificationsStrings.audienceAllOwnersNote,
      NotificationAudience.selectedShops =>
        NotificationsStrings.audienceSelectedShopsNote,
      _ when shops != null && owners != null =>
        NotificationsStrings.shopsAndOwners(
          AppFormatters.number(shops),
          AppFormatters.number(owners),
        ),
      _ => NotificationsStrings.emptyValue,
    };
  }

  @override
  Widget build(BuildContext context) {
    final DateTime? scheduledAt = state.scheduledAt;
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppLabeledField(
            label: NotificationsStrings.notificationType,
            child: AppDropdown<NotificationType>(
              value: state.type,
              items: NotificationType.values,
              labelOf: (type) => type.label,
              onChanged: onTypeChanged,
              isExpanded: true,
            ),
          ),
          const SizedBox(height: 20),
          AppTextField(
            label: NotificationsStrings.titleLabel,
            hintText: NotificationsStrings.titleHint,
            maxLength: titleMaxLength,
            errorText: state.showTitleError
                ? NotificationsStrings.titleRequired
                : null,
            textInputAction: TextInputAction.next,
            onChanged: onTitleChanged,
          ),
          const SizedBox(height: 12),
          AppTextField(
            label: NotificationsStrings.messageLabel,
            hintText: NotificationsStrings.messageHint,
            maxLength: messageMaxLength,
            minLines: 3,
            maxLines: 6,
            keyboardType: TextInputType.multiline,
            errorText: state.showMessageError
                ? NotificationsStrings.messageRequired
                : null,
            onChanged: onMessageChanged,
          ),
          const SizedBox(height: 16),
          _Section(
            label: NotificationsStrings.audienceLabel,
            children: [
              AppResponsiveGrid(
                minItemWidth: 240,
                maxColumns: 2,
                spacing: 10,
                children: [
                  for (final NotificationAudience audience
                      in CreateNotificationState.audiences)
                    AppRadioCard(
                      title: audience.label,
                      subtitle: _audienceNote(audience),
                      isSelected: state.audience == audience,
                      onTap: () => onAudienceChanged(audience),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                NotificationsStrings.audienceDedupeNote,
                style: AppTextStyles.meta,
              ),
              if (state.showAudienceError) ...[
                const SizedBox(height: 6),
                const Text(
                  NotificationsStrings.selectedShopsUnavailable,
                  style: AppTextStyles.fieldError,
                ),
              ],
            ],
          ),
          const SizedBox(height: 20),
          _Section(
            label: NotificationsStrings.deliveryLabel,
            children: [
              AppResponsiveGrid(
                minItemWidth: 240,
                maxColumns: 2,
                spacing: 10,
                children: [
                  AppRadioCard(
                    title: NotificationsStrings.sendNow,
                    subtitle: NotificationsStrings.sendNowNote,
                    isSelected: state.delivery == NotificationDelivery.sendNow,
                    onTap: () =>
                        onDeliveryChanged(NotificationDelivery.sendNow),
                  ),
                  AppRadioCard(
                    title: NotificationsStrings.schedule,
                    subtitle: NotificationsStrings.scheduleNote,
                    isSelected: state.delivery == NotificationDelivery.schedule,
                    onTap: () =>
                        onDeliveryChanged(NotificationDelivery.schedule),
                  ),
                ],
              ),
              if (state.delivery == NotificationDelivery.schedule) ...[
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: AppSecondaryButton(
                    label: scheduledAt == null
                        ? NotificationsStrings.pickDateTime
                        : NotificationsStrings.scheduledFor(
                            AppFormatters.timestamp(scheduledAt),
                          ),
                    icon: Icons.calendar_today_outlined,
                    iconColor: AppColors.textPrimary,
                    onPressed: onPickSchedule,
                  ),
                ),
              ],
              if (state.showScheduleError(DateTime.now())) ...[
                const SizedBox(height: 6),
                const Text(
                  NotificationsStrings.scheduleRequired,
                  style: AppTextStyles.fieldError,
                ),
              ],
            ],
          ),
          const Divider(height: 40, color: AppColors.divider),
          Wrap(
            alignment: WrapAlignment.end,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: AppTextLink(
                  label: NotificationsStrings.cancel,
                  showChevron: false,
                  onTap: onCancel,
                ),
              ),
              AppSecondaryButton(
                label: NotificationsStrings.saveDraft,
                onPressed: onSaveDraft,
              ),
              AppPrimaryButton(
                label: NotificationsStrings.reviewAndSend,
                svgIcon: AppImages.sendIcon,
                isCompact: true,
                onPressed: onReview,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.label, required this.children});

  final String label;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: AppTextStyles.label),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }
}
