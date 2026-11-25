import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/navigation/app_routes.dart';
import '../state/subscriptions_cubit.dart';
import '../state/subscriptions_state.dart';
import 'shop_subscriptions_table.dart';
import 'shop_subscriptions_toolbar.dart';

class ShopSubscriptionsTab extends StatelessWidget {
  const ShopSubscriptionsTab({super.key, required this.state});

  final SubscriptionsState state;

  @override
  Widget build(BuildContext context) {
    final SubscriptionsCubit cubit = context.read<SubscriptionsCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ShopSubscriptionsToolbar(
          state: state,
          onStatusChanged: cubit.filterByStatus,
          onSearch: cubit.search,
          onPlanChanged: cubit.filterByPlan,
          onExpiryChanged: cubit.filterByExpiry,
        ),
        const SizedBox(height: 16),
        ShopSubscriptionsTable(
          rows: state.visibleSubscriptions,
          onView: (item) async {
            await Navigator.of(context)
                .pushNamed(AppRoutes.subscriptionDetailsFor(item.shopId));
            cubit.syncShopSubscriptions();
          },
        ),
      ],
    );
  }
}
