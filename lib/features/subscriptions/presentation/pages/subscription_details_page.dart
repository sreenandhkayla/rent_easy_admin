import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/navigation/app_routes.dart';
import '../../../../core/resources/strings/app_strings.dart';
import '../../../../core/resources/strings/subscriptions_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/utils/app_messenger.dart';
import '../../../../core/widgets/admin_shell/admin_section.dart';
import '../../../../core/widgets/admin_shell/admin_shell.dart';
import '../../../../core/widgets/app_breadcrumbs.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_refresh_button.dart';
import '../../../../core/widgets/app_text_link.dart';
import '../../data/models/shop_subscription.dart';
import '../state/subscription_details_cubit.dart';
import '../state/subscription_details_state.dart';
import '../widgets/payment_attempts_card.dart';
import '../widgets/renewal_history_card.dart';
import '../widgets/subscription_actions_card.dart';
import '../widgets/subscription_notice.dart';
import '../widgets/subscription_plan_card.dart';

class SubscriptionDetailsPage extends StatelessWidget {
  const SubscriptionDetailsPage({super.key, required this.shopId});

  final String? shopId;

  static void _backToList(BuildContext context) {
    final NavigatorState navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
    } else {
      navigator.pushReplacementNamed(AppRoutes.shopSubscriptions);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SubscriptionDetailsCubit(shopId)..load(),
      child: BlocBuilder<SubscriptionDetailsCubit, SubscriptionDetailsState>(
        builder: (context, state) {
          final SubscriptionDetails? details = state.details;
          final DateTime? updatedAt = state.updatedAt;
          final String title =
              details?.subscription.shopName ??
              SubscriptionsStrings.subscriptionNotFound;
          return AdminShell(
            section: AdminSection.subscriptions,
            isSectionRoot: false,
            title: title,
            subtitle: SubscriptionsStrings.detailsSubtitle,
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
                  SubscriptionsStrings.tabShopSubscriptions,
                  onTap: () => _backToList(context),
                ),
                AppBreadcrumb(title),
              ],
            ),
            headerActions: [
              if (updatedAt != null)
                AppRefreshButton(
                  updatedAt: updatedAt,
                  onPressed: context.read<SubscriptionDetailsCubit>().load,
                ),
            ],
            child: switch (state.status) {
              SubscriptionDetailsStatus.loading => const Padding(
                padding: EdgeInsets.all(48),
                child: Center(child: CircularProgressIndicator()),
              ),
              SubscriptionDetailsStatus.notFound => _NotFound(
                onBack: () => _backToList(context),
              ),
              SubscriptionDetailsStatus.loaded => _DetailsBody(
                details: details!,
              ),
            },
          );
        },
      ),
    );
  }
}

class _DetailsBody extends StatelessWidget {
  const _DetailsBody({required this.details});

  static const double _twoColumnBreakpoint = 1000;

  final SubscriptionDetails details;

  void _viewOwner(BuildContext context) {
    final NavigatorState navigator = Navigator.of(context);
    navigator.pushNamedAndRemoveUntil(AppRoutes.shopOwners, (_) => false);
    navigator.pushNamed(
      AppRoutes.ownerDetailsFor(details.subscription.ownerId),
    );
  }

  void _viewShop(BuildContext context) {
    final NavigatorState navigator = Navigator.of(context);
    navigator.pushNamedAndRemoveUntil(AppRoutes.shops, (_) => false);
    navigator.pushNamed(AppRoutes.shopDetailsFor(details.subscription.shopId));
  }

  void _simulateRenewal(BuildContext context) {
    final SubscriptionDetailsCubit cubit = context
        .read<SubscriptionDetailsCubit>();
    cubit.simulateVerifiedRenewal();
    final DateTime? expiresAt = cubit.state.details?.subscription.expiresAt;
    if (expiresAt == null) return;
    context.showAppMessage(
      SubscriptionsStrings.renewedSnack(
        details.subscription.shopName,
        AppFormatters.date(expiresAt),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget main = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SubscriptionPlanCard(subscription: details.subscription),
        const SizedBox(height: 16),
        PaymentAttemptsCard(
          attempts: details.attempts,
          onView: (_) => context.showAppMessage(
            AppStrings.sectionNotBuilt(SubscriptionsStrings.transactionDetails),
          ),
        ),
      ],
    );
    final Widget side = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SubscriptionActionsCard(
          onViewShop: () => _viewShop(context),
          onViewOwner: () => _viewOwner(context),
          onSimulateRenewal: () => _simulateRenewal(context),
        ),
        const SizedBox(height: 16),
        RenewalHistoryCard(details: details),
      ],
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SubscriptionNotice(details: details),
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
            SubscriptionsStrings.subscriptionNotFoundMessage,
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 12),
          AppTextLink(
            label: SubscriptionsStrings.backToShopSubscriptions,
            onTap: onBack,
          ),
        ],
      ),
    );
  }
}
