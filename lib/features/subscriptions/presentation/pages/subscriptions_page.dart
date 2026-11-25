import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
import '../widgets/shop_subscriptions_tab.dart';
import '../widgets/subscriptions_overview_tab.dart';

class SubscriptionsPage extends StatelessWidget {
  const SubscriptionsPage({super.key, this.showShopSubscriptions = false});

  final bool showShopSubscriptions;

  static const Set<SubscriptionsTab> _builtTabs = {
    SubscriptionsTab.overview,
    SubscriptionsTab.shopSubscriptions,
  };

  void _notBuilt(BuildContext context, String label) =>
      context.showAppMessage(AppStrings.sectionNotBuilt(label));

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SubscriptionsCubit(
        initialTab: showShopSubscriptions
            ? SubscriptionsTab.shopSubscriptions
            : SubscriptionsTab.overview,
      )..load(),
      child: BlocBuilder<SubscriptionsCubit, SubscriptionsState>(
        builder: (context, state) {
          final SubscriptionsCubit cubit = context.read<SubscriptionsCubit>();
          final SubscriptionOverview? overview = state.overview;
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
                      else
                        SubscriptionsOverviewTab(
                          overview: overview,
                          onViewPayments: () => _notBuilt(
                            context,
                            SubscriptionsStrings.tabPayments,
                          ),
                          onManagePlans: () =>
                              _notBuilt(context, SubscriptionsStrings.tabPlans),
                        ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
