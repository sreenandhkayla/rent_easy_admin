import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/resources/images/app_images.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../../core/resources/strings/reports_strings.dart';
import '../../../../core/widgets/admin_shell/admin_section.dart';
import '../../../../core/widgets/admin_shell/admin_shell.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_list_skeleton.dart';
import '../../../../core/widgets/app_refresh_button.dart';
import '../state/reports_cubit.dart';
import '../state/reports_state.dart';
import '../widgets/reports_table.dart';
import '../widgets/reports_toolbar.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key, this.initialFilter = ReportStatusFilter.all});

  final ReportStatusFilter initialFilter;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ReportsCubit(initialFilter: initialFilter)..load(),
      child: BlocBuilder<ReportsCubit, ReportsState>(
        builder: (context, state) {
          final ReportsCubit cubit = context.read<ReportsCubit>();
          final DateTime? updatedAt = state.updatedAt;
          return AdminShell(
            section: AdminSection.reportsAndComplaints,
            title: ReportsStrings.title,
            subtitle: ReportsStrings.subtitle,
            headerActions: [
              if (updatedAt != null)
                AppRefreshButton(updatedAt: updatedAt, onPressed: cubit.load),
            ],
            child: state.isLoading && state.reports.isEmpty
                ? const AppListSkeleton()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ReportsToolbar(
                        state: state,
                        onStatusChanged: cubit.filterByStatus,
                        onSearch: cubit.search,
                        onCategoryChanged: cubit.filterByCategory,
                        onDateChanged: cubit.filterByDate,
                      ),
                      const SizedBox(height: 16),
                      if (state.reports.isEmpty)
                        const AppCard(
                          child: AppEmptyState(
                            svgIcon: AppImages.inboxIcon,
                            title: ReportsStrings.noReportsTitle,
                            message: ReportsStrings.noReportsMessage,
                          ),
                        )
                      else
                        ReportsTable(
                          rows: state.visibleReports,
                          onReview: (report) async {
                            await Navigator.of(context).pushNamed(
                              AppRoutes.reportDetailsFor(report.reportId),
                            );
                            cubit.syncReports();
                          },
                        ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
