import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/admin_permission.dart';
import '../../../auth/presentation/widgets/admin_permission_context.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../../core/resources/strings/app_strings.dart';
import '../../../../core/resources/strings/subscriptions_strings.dart';
import '../../../../core/utils/app_messenger.dart';
import '../../../../core/widgets/admin_shell/admin_section.dart';
import '../../../../core/widgets/admin_shell/admin_shell.dart';
import '../../../../core/widgets/app_breadcrumbs.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_refresh_button.dart';
import '../../data/models/plan_definition.dart';
import '../state/create_plan_cubit.dart';
import '../state/create_plan_state.dart';
import '../widgets/create_plan_form_card.dart';
import '../widgets/plan_preview_card.dart';

class CreatePlanPage extends StatelessWidget {
  const CreatePlanPage({super.key, this.planId});

  final String? planId;

  static const double _twoColumnBreakpoint = 1000;

  static void _backToPlans(BuildContext context, {bool saved = false}) {
    final NavigatorState navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop(saved);
    } else {
      navigator.pushReplacementNamed(AppRoutes.subscriptionPlans);
    }
  }

  Future<void> _save(BuildContext context) async {
    final PlanDefinition? plan = await context.read<CreatePlanCubit>().save();
    if (plan == null || !context.mounted) return;
    context.showAppMessage(
      planId == null
          ? SubscriptionsStrings.planCreated(plan.name)
          : SubscriptionsStrings.planUpdated(plan.name),
    );
    _backToPlans(context, saved: true);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CreatePlanCubit>(param1: planId)..load(),
      child: BlocBuilder<CreatePlanCubit, CreatePlanState>(
        builder: (context, state) {
          final CreatePlanCubit cubit = context.read<CreatePlanCubit>();
          final Widget form = CreatePlanFormCard(
            state: state,
            onNameChanged: cubit.setName,
            onStatusChanged: cubit.setStatus,
            onDescriptionChanged: cubit.setDescription,
            onPriceChanged: cubit.setPrice,
            onBillingPeriodChanged: cubit.setBillingPeriod,
            onBenefitsChanged: cubit.setBenefits,
            onLimitChanged: cubit.setLimit,
            onOfferTagChanged: cubit.setOfferTag,
            onOfferPercentageChanged: cubit.setOfferPercentage,
            onCancel: () => _backToPlans(context),
            onSave: () => _save(context),
            saveLabel: state.isEditing
                ? SubscriptionsStrings.saveChanges
                : SubscriptionsStrings.savePlan,
          );
          final String title = state.isEditing
              ? SubscriptionsStrings.editPlan
              : SubscriptionsStrings.createPlan;
          final Widget preview = PlanPreviewCard(state: state);
          return AdminShell(
            section: AdminSection.subscriptions,
            isSectionRoot: false,
            title: title,
            subtitle: state.isEditing
                ? SubscriptionsStrings.editPlanSubtitle
                : SubscriptionsStrings.createPlanSubtitle,
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
                  onTap: () => _backToPlans(context),
                ),
                AppBreadcrumb(title),
              ],
            ),
            headerActions: [
              AppRefreshButton(
                updatedAt: state.updatedAt,
                onPressed: cubit.refresh,
              ),
            ],
            child: !context.canPerform(AdminPermission.managePlans)
                ? AppCard(
                    child: AppEmptyState(
                      icon: Icons.lock_outline_rounded,
                      title: SubscriptionsStrings.managePlansDeniedTitle,
                      message: SubscriptionsStrings.managePlansDenied,
                      actionLabel: SubscriptionsStrings.tabPlans,
                      onAction: () => _backToPlans(context),
                    ),
                  )
                : switch (state.formStatus) {
                    PlanFormStatus.loading => const Padding(
                      padding: EdgeInsets.all(48),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    PlanFormStatus.notFound => const AppCard(
                      child: AppEmptyState(
                        icon: Icons.search_off_rounded,
                        title: SubscriptionsStrings.planNotFound,
                        message: SubscriptionsStrings.planNotFoundMessage,
                      ),
                    ),
                    PlanFormStatus.failure => AppCard(
                      child: AppEmptyState(
                        icon: Icons.error_outline_rounded,
                        title: SubscriptionsStrings.planNotFound,
                        message:
                            state.errorMessage ?? AppStrings.recordsLoadFailed,
                        actionLabel: AppStrings.retry,
                        onAction: cubit.load,
                      ),
                    ),
                    PlanFormStatus.ready => LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxWidth < _twoColumnBreakpoint) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              form,
                              const SizedBox(height: 16),
                              preview,
                            ],
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
                  },
          );
        },
      ),
    );
  }
}
