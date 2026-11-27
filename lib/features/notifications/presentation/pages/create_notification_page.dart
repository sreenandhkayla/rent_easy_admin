import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/data/admin_record.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../../core/resources/strings/app_strings.dart';
import '../../../../core/resources/strings/notifications_strings.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/utils/app_messenger.dart';
import '../../../../core/widgets/admin_shell/admin_section.dart';
import '../../../../core/widgets/admin_shell/admin_shell.dart';
import '../../../../core/widgets/app_breadcrumbs.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_confirm_dialog.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_refresh_button.dart';
import '../../../auth/presentation/state/admin_session_cubit.dart';
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

  static NotificationAuthor _author(BuildContext context) {
    final AdminRecord? account = context
        .read<AdminSessionCubit>()
        .state
        .account;
    return NotificationAuthor(
      name: account?.name ?? '',
      email: account?.email ?? '',
    );
  }

  Future<void> _saveDraft(BuildContext context) async {
    final CreateNotificationCubit cubit = context
        .read<CreateNotificationCubit>();
    final bool wasEditing = cubit.state.isEditing;
    final result = await cubit.saveDraft(_author(context));
    if (!context.mounted) return;
    if (result.error case final String error) {
      context.showAppMessage(error);
      return;
    }
    final String? title = result.savedTitle;
    if (title == null) return;
    context.showAppMessage(
      wasEditing
          ? NotificationsStrings.draftUpdatedSnack(title)
          : NotificationsStrings.draftSnack(title),
    );
    _backToList(context, saved: true);
  }

  Future<void> _review(BuildContext context) async {
    final CreateNotificationCubit cubit = context
        .read<CreateNotificationCubit>();
    if (!cubit.validateForSend()) return;
    final CreateNotificationState state = cubit.state;
    final AudienceReach? reach = state.reachOf(state.audience);
    final String recipients = switch (reach) {
      AudienceReach(owners: final int owners) =>
        NotificationsStrings.ownersCount(AppFormatters.number(owners)),
      AudienceReach(shops: final int shops) => NotificationsStrings.shopsCount(
        AppFormatters.number(shops),
      ),
      _ => NotificationsStrings.emptyValue,
    };
    final bool confirmed = await AppConfirmDialog.show(
      context,
      title: NotificationsStrings.sendTitle,
      message: NotificationsStrings.sendMessage(
        state.title.trim(),
        recipients,
        state.audience.label,
      ),
      notice: NotificationsStrings.sendNotice,
      confirmLabel: NotificationsStrings.reviewAndSend,
      cancelLabel: NotificationsStrings.cancel,
    );
    if (!confirmed || !context.mounted) return;
    final result = await cubit.send(_author(context));
    if (!context.mounted) return;
    if (result.error case final String error) {
      context.showAppMessage(error);
      return;
    }
    final String? title = result.savedTitle;
    if (title == null) return;
    context.showAppMessage(NotificationsStrings.queuedSnack(title));
    _backToList(context, saved: true);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<CreateNotificationCubit>(param1: notificationId)..load(),
      child: BlocBuilder<CreateNotificationCubit, CreateNotificationState>(
        builder: (context, state) {
          final CreateNotificationCubit cubit = context
              .read<CreateNotificationCubit>();
          final bool isEdit = notificationId != null;
          final String title = isEdit
              ? NotificationsStrings.editNotification
              : NotificationsStrings.createNotification;
          final DateTime? updatedAt = state.updatedAt;
          return AdminShell(
            section: AdminSection.notifications,
            isSectionRoot: false,
            title: title,
            subtitle: isEdit
                ? NotificationsStrings.editSubtitle
                : NotificationsStrings.createSubtitle,
            breadcrumb: AppBreadcrumbs(
              items: [
                AppBreadcrumb(
                  NotificationsStrings.title,
                  onTap: () => _backToList(context),
                ),
                AppBreadcrumb(title),
              ],
            ),
            headerActions: [
              if (updatedAt != null && isEdit)
                AppRefreshButton(updatedAt: updatedAt, onPressed: cubit.load),
            ],
            child: switch (state.status) {
              CreateNotificationStatus.loading => const Padding(
                padding: EdgeInsets.all(48),
                child: Center(child: CircularProgressIndicator()),
              ),
              CreateNotificationStatus.failure => AppCard(
                child: AppEmptyState(
                  icon: Icons.error_outline_rounded,
                  title: NotificationsStrings.loadFailedTitle,
                  message: state.errorMessage ?? AppStrings.recordsLoadFailed,
                  actionLabel: AppStrings.retry,
                  onAction: cubit.load,
                ),
              ),
              CreateNotificationStatus.notFound => AppCard(
                child: AppEmptyState(
                  icon: Icons.search_off_rounded,
                  title: NotificationsStrings.notificationNotFound,
                  message: NotificationsStrings.notificationNotFoundMessage,
                  actionLabel: NotificationsStrings.backToNotifications,
                  onAction: () => _backToList(context),
                ),
              ),
              CreateNotificationStatus.notEditable => AppCard(
                child: AppEmptyState(
                  icon: Icons.lock_outline_rounded,
                  title: NotificationsStrings.notEditableTitle,
                  message: NotificationsStrings.notEditableMessage,
                  actionLabel: NotificationsStrings.backToNotifications,
                  onAction: () => _backToList(context),
                ),
              ),
              CreateNotificationStatus.ready => _CreateBody(
                form: NotificationFormCard(
                  state: state,
                  onTypeChanged: cubit.setType,
                  onTitleChanged: cubit.setTitle,
                  onMessageChanged: cubit.setMessage,
                  onAudienceChanged: cubit.setAudience,
                  onCancel: () => _backToList(context),
                  onSaveDraft: () => _saveDraft(context),
                  onReview: () => _review(context),
                ),
                preview: NotificationPreviewCard(state: state),
                breakpoint: _twoColumnBreakpoint,
              ),
            },
          );
        },
      ),
    );
  }
}

class _CreateBody extends StatelessWidget {
  const _CreateBody({
    required this.form,
    required this.preview,
    required this.breakpoint,
  });

  final Widget form;
  final Widget preview;
  final double breakpoint;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < breakpoint) {
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
    );
  }
}
