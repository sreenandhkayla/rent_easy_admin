import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/enums/registration_date_filter.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../../core/resources/images/app_images.dart';
import '../../../../core/resources/strings/app_strings.dart';
import '../../../../core/resources/strings/shop_owners_strings.dart';
import '../../../../core/widgets/admin_shell/admin_section.dart';
import '../../../../core/widgets/admin_shell/admin_shell.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_list_skeleton.dart';
import '../../../../core/widgets/app_refresh_button.dart';
import '../state/shop_owners_cubit.dart';
import '../state/shop_owners_state.dart';
import '../widgets/shop_owners_table.dart';
import '../widgets/shop_owners_toolbar.dart';

class ShopOwnersPage extends StatelessWidget {
  const ShopOwnersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ShopOwnersCubit>()..load(),
      child: BlocBuilder<ShopOwnersCubit, ShopOwnersState>(
        builder: (context, state) {
          final ShopOwnersCubit cubit = context.read<ShopOwnersCubit>();
          final DateTime? updatedAt = state.updatedAt;
          return AdminShell(
            section: AdminSection.shopOwners,
            title: ShopOwnersStrings.title,
            subtitle: ShopOwnersStrings.subtitle,
            headerActions: [
              if (updatedAt != null)
                AppRefreshButton(updatedAt: updatedAt, onPressed: cubit.load),
            ],
            child: !state.hasLoaded && state.errorMessage != null
                ? AppCard(
                    child: AppEmptyState(
                      icon: Icons.error_outline_rounded,
                      title: ShopOwnersStrings.loadFailedTitle,
                      message: state.errorMessage!,
                      actionLabel: AppStrings.retry,
                      onAction: cubit.retry,
                    ),
                  )
                : !state.hasLoaded
                ? const AppListSkeleton()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ShopOwnersToolbar(
                        statusFilter: state.statusFilter,
                        dateFilter: state.dateFilter,
                        totalOnPlatform: state.totalOnPlatform,
                        onSearch: cubit.search,
                        onStatusChanged: cubit.filterByStatus,
                        onDateChanged: cubit.filterByRegistrationDate,
                      ),
                      const SizedBox(height: 16),
                      if (state.totalOnPlatform == 0 &&
                          state.totalCount == 0 &&
                          !state.isSearching &&
                          state.statusFilter == OwnerStatusFilter.all &&
                          state.dateFilter == RegistrationDateFilter.any)
                        const AppCard(
                          child: AppEmptyState(
                            svgIcon: AppImages.inboxIcon,
                            title: ShopOwnersStrings.noOwnersTitle,
                            message: ShopOwnersStrings.noOwnersMessage,
                          ),
                        )
                      else
                        ShopOwnersTable(
                          state: state,
                          onSort: cubit.sortBy,
                          onPageChanged: cubit.goToPage,
                          onPageSizeChanged: cubit.setPageSize,
                          onRetry: cubit.retry,
                          onView: (owner) async {
                            final Object? changed = await Navigator.of(context)
                                .pushNamed(
                                  AppRoutes.ownerDetailsFor(owner.ownerId),
                                );
                            if (changed == true) cubit.load();
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
