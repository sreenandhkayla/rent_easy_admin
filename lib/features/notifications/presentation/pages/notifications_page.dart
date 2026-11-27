import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../../core/resources/strings/app_strings.dart';
import '../../../../core/resources/strings/notifications_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/admin_shell/admin_section.dart';
import '../../../../core/widgets/admin_shell/admin_shell.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_list_skeleton.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_refresh_button.dart';
import '../../../../core/widgets/app_segmented_tabs.dart';
import '../../data/datasources/notifications_remote_data_source.dart';
import '../state/notifications_cubit.dart';
import '../state/notifications_state.dart';
import '../widgets/notifications_table.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<NotificationsCubit>()..load(),
      child: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          final NotificationsCubit cubit = context.read<NotificationsCubit>();
          final DateTime? updatedAt = state.updatedAt;
          Future<void> open(String route) async {
            await Navigator.of(context).pushNamed(route);
            cubit.load();
          }

          return AdminShell(
            section: AdminSection.notifications,
            title: NotificationsStrings.title,
            subtitle: NotificationsStrings.subtitle,
            headerActions: [
              if (updatedAt != null)
                AppRefreshButton(updatedAt: updatedAt, onPressed: cubit.load),
            ],
            child: !state.hasLoaded && state.errorMessage == null
                ? const AppListSkeleton()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: AppSegmentedTabs(
                          labels: [
                            for (final f in NotificationFilter.values) f.label,
                          ],
                          counts: [
                            for (final f in NotificationFilter.values)
                              state.countFor(f),
                          ],
                          selectedIndex: state.filter.index,
                          onSelected: (index) =>
                              cubit.filterBy(NotificationFilter.values[index]),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: AppPrimaryButton(
                          label: NotificationsStrings.createNotification,
                          icon: Icons.add,
                          isCompact: true,
                          onPressed: () => open(AppRoutes.createNotification),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (state.errorMessage case final String error)
                        AppCard(
                          child: AppEmptyState(
                            icon: Icons.error_outline_rounded,
                            title: NotificationsStrings.loadFailedTitle,
                            message: error,
                            actionLabel: AppStrings.retry,
                            onAction: cubit.load,
                          ),
                        )
                      else ...[
                        NotificationsTable(
                          rows: state.notifications,
                          isLoading: state.isLoading,
                          onView: (item) =>
                              open(AppRoutes.notificationDetailsFor(item.id)),
                          onEdit: (item) =>
                              open(AppRoutes.editNotificationFor(item.id)),
                        ),
                        if (state.notifications.length >=
                            NotificationsRemoteDataSource.listLimit) ...[
                          const SizedBox(height: 10),
                          Text(
                            NotificationsStrings.listLimitNote(
                              NotificationsRemoteDataSource.listLimit,
                            ),
                            style: AppTextStyles.meta,
                          ),
                        ],
                      ],
                    ],
                  ),
          );
        },
      ),
    );
  }
}
