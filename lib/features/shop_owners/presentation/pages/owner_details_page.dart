import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/navigation/app_routes.dart';
import '../../../../core/resources/strings/app_strings.dart';
import '../../../../core/resources/strings/shop_owners_strings.dart';
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
import '../../data/models/owner_details.dart';
import '../../data/models/shop_owner.dart';
import '../state/owner_details_cubit.dart';
import '../state/owner_details_state.dart';
import '../widgets/linked_shops_card.dart';
import '../widgets/owner_account_actions_card.dart';
import '../widgets/owner_activity_card.dart';
import '../widgets/owner_profile_card.dart';

class OwnerDetailsPage extends StatelessWidget {
  const OwnerDetailsPage({super.key, required this.ownerId});

  final String? ownerId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OwnerDetailsCubit(ownerId)..load(),
      child: BlocBuilder<OwnerDetailsCubit, OwnerDetailsState>(
        builder: (context, state) {
          final OwnerDetails? details = state.details;
          final DateTime? updatedAt = state.updatedAt;
          final String title =
              details?.owner.name ?? ShopOwnersStrings.ownerNotFound;
          void backToList() =>
              returnToSection(context, AdminSection.shopOwners);
          return AdminShell(
            section: AdminSection.shopOwners,
            isSectionRoot: false,
            title: title,
            subtitle: ShopOwnersStrings.ownerDetailsSubtitle,
            breadcrumb: AppBreadcrumbs(
              items: [
                AppBreadcrumb(ShopOwnersStrings.title, onTap: backToList),
                AppBreadcrumb(title),
              ],
            ),
            headerActions: [
              if (updatedAt != null)
                AppRefreshButton(
                  updatedAt: updatedAt,
                  onPressed: context.read<OwnerDetailsCubit>().load,
                ),
            ],
            child: switch (state.status) {
              OwnerDetailsStatus.loading => const Padding(
                padding: EdgeInsets.all(48),
                child: Center(child: CircularProgressIndicator()),
              ),
              OwnerDetailsStatus.notFound => _NotFound(onBack: backToList),
              OwnerDetailsStatus.loaded => _OwnerDetailsBody(details: details!),
            },
          );
        },
      ),
    );
  }
}

class _OwnerDetailsBody extends StatelessWidget {
  const _OwnerDetailsBody({required this.details});

  static const double _twoColumnBreakpoint = 1000;

  final OwnerDetails details;

  Future<void> _restrict(BuildContext context) async {
    final OwnerDetailsCubit cubit = context.read<OwnerDetailsCubit>();
    final String name = details.owner.name;
    final String? reason = await AppReasonDialog.show(
      context,
      title: ShopOwnersStrings.restrictTitle(name),
      message: ShopOwnersStrings.restrictMessage,
      reasonLabel: ShopOwnersStrings.reasonLabel,
      reasonHint: ShopOwnersStrings.reasonHint,
      reasonRequiredError: ShopOwnersStrings.reasonRequired,
      confirmLabel: ShopOwnersStrings.restrictAccount,
    );
    if (reason == null || !context.mounted) return;
    cubit.restrict(reason: reason, actor: AdminProfile.current.name);
    context.showAppMessage(ShopOwnersStrings.restrictedMessage(name));
  }

  Future<void> _restore(BuildContext context) async {
    final OwnerDetailsCubit cubit = context.read<OwnerDetailsCubit>();
    final String name = details.owner.name;
    final bool confirmed = await AppConfirmDialog.show(
      context,
      title: ShopOwnersStrings.restoreTitle(name),
      message: ShopOwnersStrings.restoreMessage,
      confirmLabel: ShopOwnersStrings.restoreAccount,
      cancelLabel: AppStrings.cancel,
    );
    if (!confirmed || !context.mounted) return;
    cubit.restore(actor: AdminProfile.current.name);
    context.showAppMessage(ShopOwnersStrings.restoredMessage(name));
  }

  @override
  Widget build(BuildContext context) {
    final Widget main = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OwnerProfileCard(details: details),
        const SizedBox(height: 16),
        LinkedShopsCard(
          shops: details.shops,
          onView: (_) => context.showAppMessage(
            AppStrings.sectionNotBuilt(ShopOwnersStrings.shopDetails),
          ),
        ),
      ],
    );
    final Widget side = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OwnerAccountActionsCard(
          isRestricted: details.owner.status == OwnerStatus.restricted,
          onViewLinkedShops: () => Navigator.of(context)
              .pushNamedAndRemoveUntil(
                AppRoutes.shopsMatching(details.owner.name),
                (_) => false,
              ),
          onRestrict: () => _restrict(context),
          onRestore: () => _restore(context),
        ),
        const SizedBox(height: 16),
        OwnerActivityCard(activities: details.activities),
      ],
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
            ShopOwnersStrings.ownerNotFoundMessage,
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 12),
          AppTextLink(label: ShopOwnersStrings.backToShopOwners, onTap: onBack),
        ],
      ),
    );
  }
}
