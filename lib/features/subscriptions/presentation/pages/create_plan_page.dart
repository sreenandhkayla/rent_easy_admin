import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/navigation/app_routes.dart';
import '../../../../core/resources/strings/subscriptions_strings.dart';
import '../../../../core/utils/app_messenger.dart';
import '../../../../core/widgets/admin_shell/admin_section.dart';
import '../../../../core/widgets/admin_shell/admin_shell.dart';
import '../../../../core/widgets/app_breadcrumbs.dart';
import '../../../../core/widgets/app_refresh_button.dart';
import '../../data/models/plan_definition.dart';
import '../state/create_plan_cubit.dart';
import '../state/create_plan_state.dart';
import '../widgets/create_plan_form_card.dart';
import '../widgets/plan_preview_card.dart';

class CreatePlanPage extends StatelessWidget {
  const CreatePlanPage({super.key});

  static const double _twoColumnBreakpoint = 1000;

  static void _backToPlans(BuildContext context, {bool saved = false}) {
    final NavigatorState navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop(saved);
    } else {
      navigator.pushReplacementNamed(AppRoutes.subscriptionPlans);
    }
  }

  void _save(BuildContext context) {
    final PlanDefinition? plan = context.read<CreatePlanCubit>().save();
    if (plan == null) return;
    context.showAppMessage(SubscriptionsStrings.planCreated(plan.name));
    _backToPlans(context, saved: true);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CreatePlanCubit(),
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
            onCancel: () => _backToPlans(context),
            onSave: () => _save(context),
          );
          final Widget preview = PlanPreviewCard(state: state);
          return AdminShell(
            section: AdminSection.subscriptions,
            isSectionRoot: false,
            title: SubscriptionsStrings.createPlan,
            subtitle: SubscriptionsStrings.createPlanSubtitle,
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
                const AppBreadcrumb(SubscriptionsStrings.createPlan),
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
