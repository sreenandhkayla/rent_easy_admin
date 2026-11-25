import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/resources/images/app_images.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../../core/resources/strings/app_strings.dart';
import '../../../../core/resources/strings/shops_strings.dart';
import '../../../../core/utils/app_messenger.dart';
import '../../../../core/widgets/admin_shell/admin_section.dart';
import '../../../../core/widgets/admin_shell/admin_shell.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_list_skeleton.dart';
import '../../../../core/widgets/app_refresh_button.dart';
import '../state/shops_cubit.dart';
import '../state/shops_state.dart';
import '../widgets/shops_table.dart';
import '../widgets/shops_toolbar.dart';

class ShopsPage extends StatelessWidget {
  const ShopsPage({super.key, this.initialQuery = ''});

  final String initialQuery;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ShopsCubit(initialQuery: initialQuery)..load(),
      child: BlocConsumer<ShopsCubit, ShopsState>(
        listenWhen: (previous, current) =>
            !previous.hasError && current.hasError && current.shops.isNotEmpty,
        listener: (context, _) =>
            context.showAppMessage(ShopsStrings.refreshError),
        builder: (context, state) {
          final ShopsCubit cubit = context.read<ShopsCubit>();
          final DateTime? updatedAt = state.updatedAt;
          return AdminShell(
            section: AdminSection.shopsAndBranches,
            title: ShopsStrings.title,
            subtitle: ShopsStrings.subtitle,
            headerActions: [
              if (updatedAt != null)
                AppRefreshButton(updatedAt: updatedAt, onPressed: cubit.load),
            ],
            child: state.isLoading && state.shops.isEmpty
                ? const AppListSkeleton()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ShopsToolbar(
                        state: state,
                        onSearch: cubit.search,
                        onSubscriptionChanged: cubit.filterBySubscription,
                        onPlanChanged: cubit.filterByPlan,
                        onStatusChanged: cubit.filterByStatus,
                        onDateChanged: cubit.filterByRegistrationDate,
                      ),
                      const SizedBox(height: 16),
                      if (state.shops.isEmpty && state.hasError)
                        AppCard(
                          child: AppEmptyState(
                            icon: Icons.wifi_off_rounded,
                            title: ShopsStrings.loadErrorTitle,
                            message: AppStrings.checkConnection,
                            actionLabel: AppStrings.retry,
                            onAction: cubit.load,
                          ),
                        )
                      else if (state.shops.isEmpty)
                        const AppCard(
                          child: AppEmptyState(
                            svgIcon: AppImages.inboxIcon,
                            title: ShopsStrings.noShopsTitle,
                            message: ShopsStrings.noShopsMessage,
                          ),
                        )
                      else
                        ShopsTable(
                          state: state,
                          onSort: cubit.sortBy,
                          onPageChanged: cubit.goToPage,
                          onView: (shop) async {
                            await Navigator.of(
                              context,
                            ).pushNamed(AppRoutes.shopDetailsFor(shop.shopId));
                            cubit.syncShops();
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
