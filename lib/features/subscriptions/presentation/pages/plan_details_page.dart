import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../../core/resources/strings/app_strings.dart';
import '../../../../core/resources/strings/subscriptions_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_messenger.dart';
import '../../../../core/widgets/admin_shell/admin_section.dart';
import '../../../../core/widgets/admin_shell/admin_shell.dart';
import '../../../../core/widgets/app_breadcrumbs.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_confirm_dialog.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_refresh_button.dart';
import '../../../../core/widgets/app_text_link.dart';
import '../../data/models/plan_definition.dart';
import '../state/plan_details_cubit.dart';
import '../state/plan_details_state.dart';
import '../widgets/plan_actions_card.dart';
import '../widgets/plan_overview_card.dart';

class PlanDetailsPage extends StatelessWidget {
  const PlanDetailsPage({super.key, required this.planId});

  final String? planId;

  static void _backToPlans(BuildContext context, {bool changed = false}) {
    final NavigatorState navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop(changed);
    } else {
      navigator.pushReplacementNamed(AppRoutes.subscriptionPlans);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PlanDetailsCubit>(param1: planId)..load(),
      child: BlocBuilder<PlanDetailsCubit, PlanDetailsState>(
        builder: (context, state) {
          final PlanDefinition? plan = state.plan;
          final DateTime? updatedAt = state.updatedAt;
          final String title = plan == null
              ? SubscriptionsStrings.planNotFound
              : SubscriptionsStrings.planTitle(plan.name);
          return PopScope<Object?>(
            canPop: !state.hasChanges,
            onPopInvokedWithResult: (didPop, _) {
              if (!didPop) Navigator.of(context).pop(true);
            },
            child: AdminShell(
              section: AdminSection.subscriptions,
              isSectionRoot: false,
              title: title,
              subtitle: SubscriptionsStrings.planDetailsSubtitle,
              breadcrumb: AppBreadcrumbs(
                items: [
                  AppBreadcrumb(
                    SubscriptionsStrings.title,
                    onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.subscriptions,
                      (_) => false,
                    ),
                  ),
                  AppBreadcrumb(
                    SubscriptionsStrings.tabPlans,
                    onTap: () =>
                        _backToPlans(context, changed: state.hasChanges),
                  ),
                  AppBreadcrumb(title),
                ],
              ),
              headerActions: [
                if (updatedAt != null)
                  AppRefreshButton(
                    updatedAt: updatedAt,
                    onPressed: context.read<PlanDetailsCubit>().load,
                  ),
              ],
              child: switch (state.status) {
                PlanDetailsStatus.loading => const Padding(
                  padding: EdgeInsets.all(48),
                  child: Center(child: CircularProgressIndicator()),
                ),
                PlanDetailsStatus.failure => AppCard(
                  child: AppEmptyState(
                    icon: Icons.error_outline_rounded,
                    title: SubscriptionsStrings.planNotFound,
                    message: state.errorMessage ?? AppStrings.recordsLoadFailed,
                    actionLabel: AppStrings.retry,
                    onAction: context.read<PlanDetailsCubit>().load,
                  ),
                ),
                PlanDetailsStatus.notFound => _NotFound(
                  onBack: () => _backToPlans(context),
                ),
                PlanDetailsStatus.loaded => _DetailsBody(plan: plan!),
              },
            ),
          );
        },
      ),
    );
  }
}

class _DetailsBody extends StatelessWidget {
  const _DetailsBody({required this.plan});

  static const double _twoColumnBreakpoint = 1000;

  final PlanDefinition plan;

  Future<void> _archive(BuildContext context) async {
    final PlanDetailsCubit cubit = context.read<PlanDetailsCubit>();
    final bool confirmed = await AppConfirmDialog.show(
      context,
      title: SubscriptionsStrings.archivePlanTitle(plan.name),
      message: SubscriptionsStrings.archivePlanMessage(plan.subscribedShops),
      notice: SubscriptionsStrings.archiveNotice,
      confirmLabel: SubscriptionsStrings.archivePlan,
      cancelLabel: AppStrings.cancel,
      isDestructive: true,
      maxWidth: AppTheme.dialogWideMaxWidth,
      borderRadius: AppTheme.radiusDialog,
    );
    if (!confirmed || !context.mounted) return;
    final String? error = await cubit.archive();
    if (!context.mounted) return;
    context.showAppMessage(
      error ?? SubscriptionsStrings.planArchivedSnack(plan.name),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget main = PlanOverviewCard(plan: plan);
    final Widget side = PlanActionsCard(
      isArchived: plan.isArchived,
      onEdit: () async {
        final PlanDetailsCubit cubit = context.read<PlanDetailsCubit>();
        final Object? saved = await Navigator.of(context)
            .pushNamed(AppRoutes.editPlanFor(plan.id));
        if (saved == true) cubit.reloadAfterEdit();
      },
      onArchive: () => _archive(context),
    );
    return LayoutBuilder(
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
            SubscriptionsStrings.planNotFoundMessage,
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 12),
          AppTextLink(label: SubscriptionsStrings.backToPlans, onTap: onBack),
        ],
      ),
    );
  }
}
