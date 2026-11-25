import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/navigation/app_routes.dart';
import '../../../../core/resources/strings/app_strings.dart';
import '../../../../core/resources/strings/shops_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_messenger.dart';
import '../../../../core/widgets/admin_shell/admin_navigation.dart';
import '../../../../core/widgets/admin_shell/admin_section.dart';
import '../../../../core/widgets/admin_shell/admin_shell.dart';
import '../../../../core/widgets/app_breadcrumbs.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_confirm_dialog.dart';
import '../../../../core/widgets/app_reason_dialog.dart';
import '../../../../core/widgets/app_refresh_button.dart';
import '../../../../core/widgets/app_text_link.dart';
import '../../data/models/shop.dart';
import '../../data/models/shop_details.dart';
import '../state/shop_details_cubit.dart';
import '../state/shop_details_state.dart';
import '../widgets/related_branches_card.dart';
import '../widgets/shop_actions_card.dart';
import '../widgets/shop_activity_card.dart';
import '../widgets/shop_notices.dart';
import '../widgets/shop_profile_card.dart';
import '../widgets/shop_subscription_card.dart';

class ShopDetailsPage extends StatelessWidget {
  const ShopDetailsPage({super.key, required this.shopId});

  final String? shopId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ShopDetailsCubit(shopId)..load(),
      child: BlocBuilder<ShopDetailsCubit, ShopDetailsState>(
        builder: (context, state) {
          final ShopDetails? details = state.details;
          final DateTime? updatedAt = state.updatedAt;
          final String title = details?.shop.name ?? ShopsStrings.shopNotFound;
          void backToList() =>
              returnToSection(context, AdminSection.shopsAndBranches);
          return AdminShell(
            section: AdminSection.shopsAndBranches,
            isSectionRoot: false,
            title: title,
            subtitle: ShopsStrings.shopDetailsSubtitle,
            breadcrumb: AppBreadcrumbs(
              items: [
                AppBreadcrumb(ShopsStrings.title, onTap: backToList),
                AppBreadcrumb(title),
              ],
            ),
            headerActions: [
              if (updatedAt != null)
                AppRefreshButton(
                  updatedAt: updatedAt,
                  onPressed: context.read<ShopDetailsCubit>().load,
                ),
            ],
            child: switch (state.status) {
              ShopDetailsStatus.loading => const Padding(
                padding: EdgeInsets.all(48),
                child: Center(child: CircularProgressIndicator()),
              ),
              ShopDetailsStatus.notFound => _NotFound(onBack: backToList),
              ShopDetailsStatus.loaded => _ShopDetailsBody(details: details!),
            },
          );
        },
      ),
    );
  }
}

class _ShopDetailsBody extends StatelessWidget {
  const _ShopDetailsBody({required this.details});

  static const double _twoColumnBreakpoint = 1000;

  final ShopDetails details;

  void _viewSubscription(BuildContext context) => context.showAppMessage(
    AppStrings.sectionNotBuilt(ShopsStrings.subscriptionDetails),
  );

  void _viewOwner(BuildContext context) {
    final NavigatorState navigator = Navigator.of(context);
    navigator.pushNamedAndRemoveUntil(AppRoutes.shopOwners, (_) => false);
    navigator.pushNamed(AppRoutes.ownerDetailsFor(details.shop.ownerId));
  }

  Future<void> _restrict(BuildContext context) async {
    final ShopDetailsCubit cubit = context.read<ShopDetailsCubit>();
    final String name = details.shop.name;
    final String? reason = await AppReasonDialog.show(
      context,
      title: ShopsStrings.restrictTitle(name),
      message: ShopsStrings.restrictDialogMessage,
      reasonLabel: ShopsStrings.reasonLabel,
      reasonHint: ShopsStrings.reasonHint,
      reasonRequiredError: ShopsStrings.reasonRequired,
      confirmLabel: ShopsStrings.restrictShop,
    );
    if (reason == null || !context.mounted) return;
    cubit.restrict(reason: reason, actor: AdminProfile.current.name);
    context.showAppMessage(ShopsStrings.restrictedSnack(name));
  }

  Future<void> _restore(BuildContext context) async {
    final ShopDetailsCubit cubit = context.read<ShopDetailsCubit>();
    final String name = details.shop.name;
    final bool confirmed = await AppConfirmDialog.show(
      context,
      title: ShopsStrings.restoreTitle(name),
      message: ShopsStrings.restoreDialogMessage,
      confirmLabel: ShopsStrings.restoreShop,
      cancelLabel: AppStrings.cancel,
    );
    if (!confirmed || !context.mounted) return;
    cubit.restore(actor: AdminProfile.current.name);
    context.showAppMessage(ShopsStrings.restoredSnack(name));
  }

  @override
  Widget build(BuildContext context) {
    final Shop shop = details.shop;
    final Widget main = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ShopProfileCard(shop: shop),
        const SizedBox(height: 16),
        ShopSubscriptionCard(
          shop: shop,
          onViewSubscription: () => _viewSubscription(context),
        ),
        const SizedBox(height: 16),
        RelatedBranchesCard(
          branches: details.relatedBranches,
          onOpen: (branch) =>
              Navigator.of(context)
                  .pushNamed(AppRoutes.shopDetailsFor(branch.shopId)),
        ),
      ],
    );
    final Widget side = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ShopActionsCard(
          isRestricted: shop.status == ShopStatus.restricted,
          onViewOwner: () => _viewOwner(context),
          onViewSubscription: () => _viewSubscription(context),
          onRestrict: () => _restrict(context),
          onRestore: () => _restore(context),
        ),
        const SizedBox(height: 16),
        ShopActivityCard(activities: details.activities),
      ],
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ShopNotices(shop: shop),
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
            ShopsStrings.shopNotFoundMessage,
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 12),
          AppTextLink(label: ShopsStrings.backToShops, onTap: onBack),
        ],
      ),
    );
  }
}
