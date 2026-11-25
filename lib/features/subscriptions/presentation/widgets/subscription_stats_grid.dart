import 'package:flutter/material.dart';

import '../../../../core/resources/strings/subscriptions_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/widgets/app_responsive_grid.dart';
import '../../../../core/widgets/app_stat_card.dart';
import '../../data/models/subscription_overview.dart';

class SubscriptionStatsGrid extends StatelessWidget {
  const SubscriptionStatsGrid({super.key, required this.overview});

  final SubscriptionOverview overview;

  @override
  Widget build(BuildContext context) {
    return AppResponsiveGrid(
      minItemWidth: 200,
      children: [
        AppStatCard(
          label: SubscriptionsStrings.totalSubscribedShops,
          value: AppFormatters.number(overview.totalSubscribedShops),
          caption: SubscriptionsStrings.totalSubscribedShopsCaption,
        ),
        AppStatCard(
          label: SubscriptionsStrings.activeSubscriptions,
          value: AppFormatters.number(overview.activeSubscriptions),
          caption: SubscriptionsStrings.excludesExpiring(overview.expiringSoon),
          dotColor: AppColors.statusGreen,
        ),
        AppStatCard(
          label: SubscriptionsStrings.unsubscribedShops,
          value: AppFormatters.number(overview.unsubscribedShops),
          caption: SubscriptionsStrings.unsubscribedShopsCaption,
          dotColor: AppColors.statusGrey,
        ),
        AppStatCard(
          label: SubscriptionsStrings.expiringSoon,
          value: AppFormatters.number(overview.expiringSoon),
          caption: SubscriptionsStrings.expiringSoonCaption,
          dotColor: AppColors.statusAmber,
        ),
        AppStatCard(
          label: SubscriptionsStrings.expiredSubscriptions,
          value: AppFormatters.number(overview.expiredSubscriptions),
          caption: SubscriptionsStrings.expiredSubscriptionsCaption,
          dotColor: AppColors.statusRed,
        ),
        AppStatCard(
          label: SubscriptionsStrings.pendingPayments,
          value: AppFormatters.number(overview.pendingPayments),
          caption: SubscriptionsStrings.pendingPaymentsCaption,
        ),
        AppStatCard(
          label: SubscriptionsStrings.failedPayments,
          value: AppFormatters.number(overview.failedPaymentsThisMonth),
          caption: SubscriptionsStrings.failedPaymentsCaption,
        ),
        AppStatCard(
          label: SubscriptionsStrings.verifiedRevenue(overview.currentMonth),
          value: AppFormatters.rupees(overview.thisMonthRevenue),
          caption: SubscriptionsStrings.verifiedRevenueCaption,
        ),
      ],
    );
  }
}
