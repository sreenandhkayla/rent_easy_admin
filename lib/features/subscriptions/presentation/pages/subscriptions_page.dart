import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/widgets/admin_permission_context.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/enums/admin_permission.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../../core/resources/strings/app_strings.dart';
import '../../../../core/resources/strings/subscriptions_strings.dart';
import '../../../../core/utils/app_messenger.dart';
import '../../../../core/widgets/admin_shell/admin_section.dart';
import '../../../../core/widgets/admin_shell/admin_shell.dart';
import '../../../../core/widgets/app_refresh_button.dart';
import '../../../../core/widgets/app_segmented_tabs.dart';
import '../../data/models/subscription_overview.dart';
import '../state/subscriptions_cubit.dart';
import '../state/subscriptions_state.dart';
import '../widgets/plans_tab.dart';
import '../widgets/reconciliation_tab.dart';
import '../widgets/shop_subscriptions_tab.dart';
import '../widgets/subscription_payments_tab.dart';
import '../widgets/subscriptions_overview_tab.dart';

class SubscriptionsPage extends StatelessWidget {
  const SubscriptionsPage({
    super.key,
    this.initialTab = SubscriptionsTab.overview,
  });

  final SubscriptionsTab initialTab;

  static const Set<SubscriptionsTab> _builtTabs = {
    SubscriptionsTab.overview,
    SubscriptionsTab.shopSubscriptions,
    SubscriptionsTab.plans,
    SubscriptionsTab.payments,
    SubscriptionsTab.reconciliation,
  };

  void _notBuilt(BuildContext context, String label) =>
      context.showAppMessage(AppStrings.sectionNotBuilt(label));

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SubscriptionsCubit>(
        param1: _builtTabs.contains(initialTab)
            ? initialTab
            : SubscriptionsTab.overview,
      )..load(),
      child: BlocBuilder<SubscriptionsCubit, SubscriptionsState>(
        builder: (context, state) {
          final SubscriptionsCubit cubit = context.read<SubscriptionsCubit>();
          final SubscriptionOverview? overview = state.overview;
          final bool canManagePlans = context.canPerform(
            AdminPermission.managePlans,
          );
          return AdminShell(
            section: AdminSection.subscriptions,
            title: SubscriptionsStrings.title,
            subtitle: SubscriptionsStrings.subtitle,
            headerActions: [
              if (overview != null)
                AppRefreshButton(
                  updatedAt: overview.updatedAt,
                  onPressed: cubit.load,
                ),
            ],
            child: overview == null
                ? const Padding(
                    padding: EdgeInsets.all(48),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: AppSegmentedTabs(
                          labels: SubscriptionsStrings.tabs,
                          selectedIndex: state.tab.index,
                          onSelected: (index) {
                            final SubscriptionsTab tab =
                                SubscriptionsTab.values[index];
                            if (_builtTabs.contains(tab)) {
                              cubit.selectTab(tab);
                            } else {
                              _notBuilt(
                                context,
                                SubscriptionsStrings.tabs[index],
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (state.tab == SubscriptionsTab.shopSubscriptions)
                        ShopSubscriptionsTab(state: state)
                      else if (state.tab == SubscriptionsTab.plans)
                        PlansTab(
                          plans: state.plans,
                          isLoading: state.isPlansLoading,
                          errorMessage: state.plansError,
                          onRetry: cubit.loadPlans,
                          onCreatePlan: !canManagePlans
                              ? null
                              : () async {
                                  final Object? saved = await Navigator.of(
                                    context,
                                  ).pushNamed(AppRoutes.createPlan);
                                  if (saved == true) cubit.loadPlans();
                                },
                          onViewDetails: (plan) async {
                            final Object? changed = await Navigator.of(context)
                                .pushNamed(AppRoutes.planDetailsFor(plan.id));
                            if (changed == true) cubit.loadPlans();
                          },
                          onEdit: !canManagePlans
                              ? null
                              : (plan) async {
                                  final Object? saved = await Navigator.of(
                                    context,
                                  ).pushNamed(AppRoutes.editPlanFor(plan.id));
                                  if (saved == true) cubit.loadPlans();
                                },
                        )
                      else if (state.tab == SubscriptionsTab.payments)
                        SubscriptionPaymentsTab(
                          state: state,
                          onFilterChanged: cubit.filterPayments,
                          onSearch: cubit.searchPayments,
                          onView: (payment) => Navigator.of(context).pushNamed(
                            AppRoutes.paymentDetailsFor(payment.transactionId),
                          ),
                        )
                      else if (state.tab == SubscriptionsTab.reconciliation &&
                          state.reconciliationSummary != null)
                        ReconciliationTab(
                          summary: state.reconciliationSummary!,
                          rows: state.reconciliationPayments,
                          onOpen: (payment) => Navigator.of(context).pushNamed(
                            AppRoutes.paymentDetailsFor(payment.transactionId),
                          ),
                        )
                      else
                        SubscriptionsOverviewTab(
                          overview: overview,
                          onViewPayments: () =>
                              cubit.selectTab(SubscriptionsTab.payments),
                          onManagePlans: () =>
                              cubit.selectTab(SubscriptionsTab.plans),
                        ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
