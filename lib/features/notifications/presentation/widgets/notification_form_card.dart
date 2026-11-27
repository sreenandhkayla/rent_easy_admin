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
    required this.onTypeChanged,
    required this.onTitleChanged,
    required this.onMessageChanged,
    required this.onAudienceChanged,
    required this.onCancel,
    required this.onSaveDraft,
    required this.onReview,
  });

  static const int titleMaxLength = 65;
  static const int messageMaxLength = 240;

  final CreateNotificationState state;
  final ValueChanged<NotificationType> onTypeChanged;
  final ValueChanged<String> onTitleChanged;
  final ValueChanged<String> onMessageChanged;
  final ValueChanged<NotificationAudience> onAudienceChanged;
  final VoidCallback onCancel;
  final VoidCallback onSaveDraft;
  final VoidCallback onReview;

  String _audienceNote(NotificationAudience audience) {
    final AudienceReach? reach = state.reachOf(audience);
    if (reach == null) return NotificationsStrings.counting;
    if (reach.owners case final int owners) {
      return NotificationsStrings.ownersCount(AppFormatters.number(owners));
    }
    if (reach.shops case final int shops) {
      return NotificationsStrings.shopsCount(AppFormatters.number(shops));
    }
    return NotificationsStrings.emptyValue;
  }

  @override
  Widget build(BuildContext context) {
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
            initialValue: state.title,
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
            initialValue: state.message,
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
                      in NotificationAudience.values)
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
                onPressed: state.isSaving ? null : onSaveDraft,
              ),
              AppPrimaryButton(
                label: NotificationsStrings.reviewAndSend,
                svgIcon: AppImages.sendIcon,
                isCompact: true,
                isLoading: state.isSaving,
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
