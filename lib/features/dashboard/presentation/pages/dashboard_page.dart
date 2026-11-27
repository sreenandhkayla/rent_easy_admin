import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/resources/strings/app_strings.dart';
import '../../../../core/resources/strings/dashboard_strings.dart';
import '../../../../core/utils/app_messenger.dart';
import '../../../../core/widgets/admin_shell/admin_navigation.dart';
import '../../../../core/widgets/admin_shell/admin_section.dart';
import '../../../../core/widgets/admin_shell/admin_shell.dart';
import '../../../../core/widgets/app_refresh_button.dart';
import '../../data/models/dashboard_summary.dart';
import '../state/dashboard_cubit.dart';
import '../state/dashboard_state.dart';
import '../widgets/dashboard_metrics_section.dart';
import '../widgets/pending_work_card.dart';
import '../widgets/recent_activity_card.dart';
import '../widgets/subscription_overview_section.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  static const double _twoColumnBreakpoint = 900;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DashboardCubit>()..load(),
      child: BlocConsumer<DashboardCubit, DashboardState>(
        listenWhen: (previous, current) =>
            current.countsError != null &&
            previous.countsError != current.countsError,
        listener: (context, state) => context.showAppMessage(
          DashboardStrings.countsLoadFailed(state.countsError!),
        ),
        builder: (context, state) {
          final DashboardSummary? summary = state.summary;
          void openSection(AdminSection section) => openAdminSection(
            context,
            section,
            current: AdminSection.dashboard,
          );
          return AdminShell(
            section: AdminSection.dashboard,
            title: DashboardStrings.title,
            subtitle: DashboardStrings.subtitle,
            badgeCounts: {
              if (summary != null)
                AdminSection.reportsAndComplaints: summary.reportsPending,
            },
            headerActions: [
              if (summary != null)
                AppRefreshButton(
                  updatedAt: summary.updatedAt,
                  onPressed: () =>
                      context.read<DashboardCubit>().load(refresh: true),
                ),
            ],
            child: summary == null
                ? const Padding(
                    padding: EdgeInsets.all(48),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DashboardMetricsSection(
                        summary: summary,
                        onOpenSection: openSection,
                      ),
                      const SizedBox(height: 28),
                      SubscriptionOverviewSection(
                        summary: summary,
                        onViewSubscriptions: () =>
                            openSection(AdminSection.subscriptions),
                      ),
                      const SizedBox(height: 20),
                      _WorkAndActivity(
                        summary: summary,
                        onOpenSection: openSection,
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}

class _WorkAndActivity extends StatelessWidget {
  const _WorkAndActivity({required this.summary, required this.onOpenSection});

  final DashboardSummary summary;
  final ValueChanged<AdminSection> onOpenSection;

  @override
  Widget build(BuildContext context) {
    final Widget pending = PendingWorkCard(
      summary: summary,
      onOpenSection: onOpenSection,
    );
    final Widget activity = RecentActivityCard(
      activities: summary.activities,
      onOpenActivityLog: () => context.showAppMessage(
        AppStrings.sectionNotBuilt(DashboardStrings.activityLog),
      ),
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < DashboardPage._twoColumnBreakpoint) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [pending, const SizedBox(height: 16), activity],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: pending),
            const SizedBox(width: 16),
            Expanded(child: activity),
          ],
        );
      },
    );
  }
}
