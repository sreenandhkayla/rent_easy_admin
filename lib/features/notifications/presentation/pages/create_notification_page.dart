import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/navigation/app_routes.dart';
import '../../../../core/resources/strings/notifications_strings.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/utils/app_messenger.dart';
import '../../../../core/widgets/admin_shell/admin_section.dart';
import '../../../../core/widgets/admin_shell/admin_shell.dart';
import '../../../../core/widgets/app_breadcrumbs.dart';
import '../../../../core/widgets/app_confirm_dialog.dart';
import '../../../../core/widgets/app_refresh_button.dart';
import '../../data/models/admin_notification.dart';
import '../state/create_notification_cubit.dart';
import '../state/create_notification_state.dart';
import '../widgets/notification_form_card.dart';
import '../widgets/notification_preview_card.dart';

class CreateNotificationPage extends StatelessWidget {
  const CreateNotificationPage({super.key, this.notificationId});

  final String? notificationId;

  static const double _twoColumnBreakpoint = 1000;

  static void _backToList(BuildContext context, {bool saved = false}) {
    final NavigatorState navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop(saved);
    } else {
      navigator.pushReplacementNamed(AppRoutes.notifications);
    }
  }

  Future<void> _pickSchedule(BuildContext context) async {
    final CreateNotificationCubit cubit = context
        .read<CreateNotificationCubit>();
    final DateTime now = DateTime.now();
    final DateTime initial =
        cubit.state.scheduledAt ?? now.add(const Duration(hours: 1));
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date == null || !context.mounted) return;
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (time == null) return;
    cubit.setScheduledAt(
      DateTime(date.year, date.month, date.day, time.hour, time.minute),
    );
  }

  void _saveDraft(BuildContext context) {
    final AdminNotification? draft = context
        .read<CreateNotificationCubit>()
        .saveDraft(actor: AdminProfile.current.name);
    if (draft == null) return;
    context.showAppMessage(
      context.read<CreateNotificationCubit>().isEditing
          ? NotificationsStrings.draftUpdatedSnack(draft.notificationId)
          : NotificationsStrings.draftSnack(draft.notificationId),
    );
    _backToList(context, saved: true);
  }

  Future<void> _review(BuildContext context) async {
    final CreateNotificationCubit cubit = context
        .read<CreateNotificationCubit>();
    if (!cubit.validateForSend()) return;
    final CreateNotificationState state = cubit.state;
    final int? owners = cubit.reach.owners;
    final String recipients = owners == null
        ? NotificationsStrings.emptyValue
        : NotificationsStrings.ownersCount(AppFormatters.number(owners));
    final DateTime? scheduledAt = state.scheduledAt;
    final bool isScheduled =
        state.delivery == NotificationDelivery.schedule && scheduledAt != null;
    final bool confirmed = await AppConfirmDialog.show(
      context,
      title: isScheduled
          ? NotificationsStrings.scheduleTitle
          : NotificationsStrings.sendTitle,
      message: isScheduled
          ? NotificationsStrings.scheduleMessage(
              state.title.trim(),
              recipients,
              state.audience.label,
              AppFormatters.timestamp(scheduledAt),
            )
          : NotificationsStrings.sendMessage(
              state.title.trim(),
              recipients,
              state.audience.label,
            ),
      notice: NotificationsStrings.sendNotice,
      confirmLabel: isScheduled
          ? NotificationsStrings.schedule
          : NotificationsStrings.sendNow,
      cancelLabel: NotificationsStrings.cancel,
    );
    if (!confirmed || !context.mounted) return;
    final AdminNotification? notification = cubit.send(
      actor: AdminProfile.current.name,
    );
    if (notification == null) return;
    context.showAppMessage(
      notification.status == NotificationStatus.scheduled
          ? NotificationsStrings.scheduledSnack(notification.notificationId)
          : NotificationsStrings.sentSnack(notification.notificationId),
    );
    _backToList(context, saved: true);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CreateNotificationCubit(draftId: notificationId),
      child: BlocBuilder<CreateNotificationCubit, CreateNotificationState>(
        builder: (context, state) {
          final CreateNotificationCubit cubit = context
              .read<CreateNotificationCubit>();
          final Widget form = NotificationFormCard(
            state: state,
            reachOf: cubit.reachFor,
            onTypeChanged: cubit.setType,
            onTitleChanged: cubit.setTitle,
            onMessageChanged: cubit.setMessage,
            onAudienceChanged: cubit.setAudience,
            onDeliveryChanged: cubit.setDelivery,
            onPickSchedule: () => _pickSchedule(context),
            onCancel: () => _backToList(context),
            onSaveDraft: () => _saveDraft(context),
            onReview: () => _review(context),
          );
          final Widget preview = NotificationPreviewCard(
            state: state,
            reach: cubit.reach,
          );
          return AdminShell(
            section: AdminSection.notifications,
            isSectionRoot: false,
            title: cubit.isEditing
                ? NotificationsStrings.editNotification
                : NotificationsStrings.createNotification,
            subtitle: cubit.isEditing
                ? NotificationsStrings.editSubtitle
                : NotificationsStrings.createSubtitle,
            breadcrumb: AppBreadcrumbs(
              items: [
                AppBreadcrumb(
                  NotificationsStrings.title,
                  onTap: () => _backToList(context),
                ),
                AppBreadcrumb(
                  cubit.isEditing
                      ? NotificationsStrings.editNotification
                      : NotificationsStrings.createNotification,
                ),
              ],
            ),
            headerActions: [
              AppRefreshButton(
                updatedAt: state.updatedAt,
                onPressed: cubit.refresh,
              ),
            ],
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < _twoColumnBreakpoint) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [form, const SizedBox(height: 16), preview],
                  );
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: form),
                    const SizedBox(width: 16),
                    Expanded(child: preview),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
