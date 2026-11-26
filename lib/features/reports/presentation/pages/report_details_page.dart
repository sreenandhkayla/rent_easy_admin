import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/navigation/app_routes.dart';
import '../../../../core/resources/images/app_images.dart';
import '../../../../core/resources/strings/reports_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_messenger.dart';
import '../../../../core/widgets/admin_shell/admin_section.dart';
import '../../../../core/widgets/admin_shell/admin_shell.dart';
import '../../../../core/widgets/app_breadcrumbs.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_notice_banner.dart';
import '../../../../core/widgets/app_reason_dialog.dart';
import '../../../../core/widgets/app_refresh_button.dart';
import '../../../../core/widgets/app_text_link.dart';
import '../../data/models/shop_report.dart';
import '../../data/reports_mock_data.dart';
import '../state/report_details_cubit.dart';
import '../state/report_details_state.dart';
import '../widgets/report_correction_card.dart';
import '../widgets/report_history_card.dart';
import '../widgets/report_review_card.dart';
import '../widgets/report_summary_card.dart';

class ReportDetailsPage extends StatelessWidget {
  const ReportDetailsPage({super.key, required this.reportId});

  final String? reportId;

  static void _backToReports(BuildContext context) {
    final NavigatorState navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
    } else {
      navigator.pushReplacementNamed(AppRoutes.reports);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ReportDetailsCubit(reportId)..load(),
      child: BlocBuilder<ReportDetailsCubit, ReportDetailsState>(
        builder: (context, state) {
          final ShopReport? report = state.report;
          final DateTime? updatedAt = state.updatedAt;
          final String title =
              report?.reportId ?? ReportsStrings.reportNotFound;
          return AdminShell(
            section: AdminSection.reportsAndComplaints,
            isSectionRoot: false,
            title: title,
            subtitle: ReportsStrings.detailsSubtitle,
            breadcrumb: AppBreadcrumbs(
              items: [
                AppBreadcrumb(
                  ReportsStrings.title,
                  onTap: () => _backToReports(context),
                ),
                AppBreadcrumb(title),
              ],
            ),
            headerActions: [
              if (updatedAt != null)
                AppRefreshButton(
                  updatedAt: updatedAt,
                  onPressed: context.read<ReportDetailsCubit>().load,
                ),
            ],
            child: switch (state.status) {
              ReportDetailsStatus.loading => const Padding(
                padding: EdgeInsets.all(48),
                child: Center(child: CircularProgressIndicator()),
              ),
              ReportDetailsStatus.notFound => _NotFound(
                onBack: () => _backToReports(context),
              ),
              ReportDetailsStatus.loaded => _DetailsBody(
                report: report!,
                notifyShop: state.notifyShop,
              ),
            },
          );
        },
      ),
    );
  }
}

class _DetailsBody extends StatelessWidget {
  const _DetailsBody({required this.report, required this.notifyShop});

  static const double _twoColumnBreakpoint = 1000;

  final ShopReport report;
  final bool notifyShop;

  String get _actor => AdminProfile.current.name;

  void _requestClarification(BuildContext context) {
    context.read<ReportDetailsCubit>().requestClarification(actor: _actor);
    context.showAppMessage(
      ReportsStrings.clarificationSent(report.shopName, notifyShop),
    );
  }

  Future<void> _resolve(BuildContext context) async {
    final ReportDetailsCubit cubit = context.read<ReportDetailsCubit>();
    final String? decision = await AppReasonDialog.show(
      context,
      title: ReportsStrings.resolveTitle(report.reportId),
      message: ReportsStrings.resolveMessage,
      notice: ReportsStrings.decisionNotice,
      reasonLabel: ReportsStrings.decisionLabel,
      reasonHint: ReportsStrings.decisionHint,
      reasonRequiredError: ReportsStrings.decisionRequired,
      confirmLabel: ReportsStrings.resolveReport,
      isDestructive: false,
    );
    if (decision == null || !context.mounted) return;
    cubit.resolve(decision, actor: _actor);
    context.showAppMessage(ReportsStrings.reportResolved(report.reportId));
  }

  Future<void> _dismiss(BuildContext context) async {
    final ReportDetailsCubit cubit = context.read<ReportDetailsCubit>();
    final String? reason = await AppReasonDialog.show(
      context,
      title: ReportsStrings.dismissTitle(report.reportId),
      message: ReportsStrings.dismissMessage,
      notice: ReportsStrings.decisionNotice,
      reasonLabel: ReportsStrings.decisionLabel,
      reasonHint: ReportsStrings.decisionHint,
      reasonRequiredError: ReportsStrings.decisionRequired,
      confirmLabel: ReportsStrings.dismissReport,
    );
    if (reason == null || !context.mounted) return;
    cubit.dismiss(reason, actor: _actor);
    context.showAppMessage(ReportsStrings.reportDismissed(report.reportId));
  }

  Future<void> _reviewCorrection(BuildContext context) async {
    final ReportDetailsCubit cubit = context.read<ReportDetailsCubit>();
    final String? note = await AppReasonDialog.show(
      context,
      title: ReportsStrings.correctionDialogTitle(report.reportId),
      message: ReportsStrings.correctionDialogMessage,
      notice: ReportsStrings.correctionNotice,
      reasonLabel: ReportsStrings.correctionNoteLabel,
      reasonHint: ReportsStrings.decisionHint,
      reasonRequiredError: ReportsStrings.correctionNoteRequired,
      confirmLabel: ReportsStrings.recordReview,
      isDestructive: false,
    );
    if (note == null || !context.mounted) return;
    cubit.reviewCorrection(note, actor: _actor);
    context.showAppMessage(
      ReportsStrings.correctionReviewedSnack(report.reportId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ReportDetailsCubit cubit = context.read<ReportDetailsCubit>();
    final ReportCorrection? correction = report.correction;
    final Widget main = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ReportSummaryCard(report: report),
        if (correction != null) ...[
          const SizedBox(height: 16),
          ReportCorrectionCard(
            correction: correction,
            onReview: () => _reviewCorrection(context),
          ),
        ],
      ],
    );
    final Widget side = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ReportReviewCard(
          report: report,
          admins: ReportsMockData.admins,
          notifyShop: notifyShop,
          onAssign: (admin) => cubit.assign(admin, actor: _actor),
          onAssignCorrection: cubit.assignCorrection,
          onNotifyChanged: cubit.setNotifyShop,
          onRequestClarification: () => _requestClarification(context),
          onResolve: () => _resolve(context),
          onDismiss: () => _dismiss(context),
        ),
        const SizedBox(height: 16),
        ReportHistoryCard(report: report),
      ],
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AppNoticeBanner(
          tone: AppNoticeTone.info,
          svgIcon: AppImages.shieldIcon,
          spans: [
            TextSpan(text: ReportsStrings.claimNoticeLead),
            TextSpan(
              text: ReportsStrings.claimNoticeEmphasis,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            TextSpan(text: ReportsStrings.claimNoticeTail),
          ],
        ),
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
                Expanded(flex: 2, child: main),
                const SizedBox(width: 16),
                Expanded(child: side),
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
            ReportsStrings.reportNotFoundMessage,
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 12),
          AppTextLink(label: ReportsStrings.backToReports, onTap: onBack),
        ],
      ),
    );
  }
}
