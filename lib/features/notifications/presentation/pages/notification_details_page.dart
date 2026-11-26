import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/navigation/app_routes.dart';
import '../../../../core/resources/strings/notifications_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/utils/app_messenger.dart';
import '../../../../core/widgets/admin_shell/admin_section.dart';
import '../../../../core/widgets/admin_shell/admin_shell.dart';
import '../../../../core/widgets/app_breadcrumbs.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_confirm_dialog.dart';
import '../../../../core/widgets/app_refresh_button.dart';
import '../../../../core/widgets/app_text_link.dart';
import '../../data/models/admin_notification.dart';
import '../state/notification_details_cubit.dart';
import '../state/notification_details_state.dart';
import '../widgets/failed_deliveries_card.dart';
import '../widgets/notification_delivery_card.dart';
import '../widgets/notification_message_card.dart';
import '../widgets/notification_stats_row.dart';

class NotificationDetailsPage extends StatelessWidget {
  const NotificationDetailsPage({super.key, required this.notificationId});

  final String? notificationId;

  static void _backToList(BuildContext context) {
    final NavigatorState navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
    } else {
      navigator.pushReplacementNamed(AppRoutes.notifications);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationDetailsCubit(notificationId)..load(),
      child: BlocBuilder<NotificationDetailsCubit, NotificationDetailsState>(
        builder: (context, state) {
          final AdminNotification? notification = state.notification;
          final DateTime? updatedAt = state.updatedAt;
          final String title =
              notification?.title ?? NotificationsStrings.notificationNotFound;
          return AdminShell(
            section: AdminSection.notifications,
            isSectionRoot: false,
            title: title,
            subtitle: NotificationsStrings.detailsSubtitle,
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
              if (updatedAt != null)
                AppRefreshButton(
                  updatedAt: updatedAt,
                  onPressed: context.read<NotificationDetailsCubit>().load,
                ),
            ],
            child: switch (state.status) {
              NotificationDetailsStatus.loading => const Padding(
                padding: EdgeInsets.all(48),
                child: Center(child: CircularProgressIndicator()),
              ),
              NotificationDetailsStatus.notFound => _NotFound(
                onBack: () => _backToList(context),
              ),
              NotificationDetailsStatus.loaded => _DetailsBody(
                notification: notification!,
              ),
            },
          );
        },
      ),
    );
  }
}

class _DetailsBody extends StatelessWidget {
  const _DetailsBody({required this.notification});

  static const double _twoColumnBreakpoint = 1000;

  final AdminNotification notification;

  Future<void> _cancelScheduled(BuildContext context) async {
    final NotificationDetailsCubit cubit = context
        .read<NotificationDetailsCubit>();
    final DateTime? sendAt = notification.sendAt;
    final bool confirmed = await AppConfirmDialog.show(
      context,
      title: NotificationsStrings.cancelScheduledTitle,
      message: NotificationsStrings.cancelScheduledMessage(
        notification.notificationId,
        sendAt == null
            ? NotificationsStrings.emptyValue
            : AppFormatters.timestamp(sendAt),
      ),
      confirmLabel: NotificationsStrings.cancelSend,
      cancelLabel: NotificationsStrings.keepScheduled,
      isDestructive: true,
    );
    if (!confirmed || !context.mounted) return;
    cubit.cancelScheduledSend();
    context.showAppMessage(
      NotificationsStrings.movedToDrafts(notification.notificationId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget main = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NotificationMessageCard(notification: notification),
        if (notification.status != NotificationStatus.draft) ...[
          const SizedBox(height: 16),
          FailedDeliveriesCard(failures: notification.failures),
        ],
      ],
    );
    final Widget side = NotificationDeliveryCard(
      notification: notification,
      onCancelScheduled: () => _cancelScheduled(context),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NotificationStatsRow(notification: notification),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < _twoColumnBreakpoint) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [main, const SizedBox(height: 16), side],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 7, child: main),
                const SizedBox(width: 16),
                Expanded(flex: 4, child: side),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _NotFound extends StatelessWidget {
  const _NotFound({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            NotificationsStrings.notificationNotFoundMessage,
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 12),
          AppTextLink(
            label: NotificationsStrings.backToNotifications,
            onTap: onBack,
          ),
        ],
      ),
    );
  }
}
