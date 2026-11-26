import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/resources/strings/analytics_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/utils/app_messenger.dart';
import '../../../../core/widgets/admin_shell/admin_section.dart';
import '../../../../core/widgets/admin_shell/admin_shell.dart';
import '../../../../core/widgets/app_list_skeleton.dart';
import '../../../../core/widgets/app_refresh_button.dart';
import '../../../../core/widgets/app_responsive_grid.dart';
import '../../../../core/widgets/app_stat_card.dart';
import '../../data/models/analytics_export.dart';
import '../../data/models/analytics_snapshot.dart';
import '../state/analytics_cubit.dart';
import '../state/analytics_state.dart';
import '../widgets/analytics_breakdown_grid.dart';
import '../widgets/analytics_toolbar.dart';
import '../widgets/analytics_trends_grid.dart';
import '../widgets/export_report_dialog.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  Future<void> _export(BuildContext context) async {
    final AnalyticsExportRequest? request = await ExportReportDialog.show(
      context,
    );
    if (request == null || !context.mounted) return;
    context.showAppMessage(
      AnalyticsStrings.exportPrepared(
        request.report.label,
        request.format.label,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AnalyticsCubit()..load(),
      child: BlocBuilder<AnalyticsCubit, AnalyticsState>(
        builder: (context, state) {
          final AnalyticsCubit cubit = context.read<AnalyticsCubit>();
          final DateTime? updatedAt = state.updatedAt;
          final AnalyticsSnapshot? snapshot = state.snapshot;
          return AdminShell(
            section: AdminSection.analyticsAndReports,
            title: AnalyticsStrings.title,
            subtitle: AnalyticsStrings.subtitle,
            headerActions: [
              if (updatedAt != null)
                AppRefreshButton(updatedAt: updatedAt, onPressed: cubit.load),
            ],
            child: snapshot == null
                ? const AppListSkeleton()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AnalyticsToolbar(
                        state: state,
                        onPeriodChanged: cubit.selectPeriod,
                        onRangeChanged: cubit.selectRange,
                        onCompareChanged: cubit.setCompare,
                        onExport: () => _export(context),
                      ),
                      const SizedBox(height: 16),
                      _TotalsGrid(snapshot: snapshot),
                      const SizedBox(height: 16),
                      AnalyticsTrendsGrid(state: state),
                      const SizedBox(height: 16),
                      AnalyticsBreakdownGrid(snapshot: snapshot),
                    ],
                  ),
          );
        },
      ),
    );
  }
}

class _TotalsGrid extends StatelessWidget {
  const _TotalsGrid({required this.snapshot});

  final AnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return AppResponsiveGrid(
      minItemWidth: 220,
      maxColumns: 3,
      children: [
        AppStatCard(
          label: AnalyticsStrings.totalItems,
          value: AppFormatters.number(snapshot.totalItems),
          caption: AnalyticsStrings.totalItemsCaption,
        ),
        AppStatCard(
          label: AnalyticsStrings.totalRentals,
          value: AppFormatters.number(snapshot.totalRentals),
          caption: AnalyticsStrings.totalRentalsCaption,
        ),
        AppStatCard(
          label: AnalyticsStrings.totalCustomers,
          value: AppFormatters.number(snapshot.totalCustomers),
          caption: AnalyticsStrings.totalCustomersCaption,
        ),
      ],
    );
  }
}
