class MonthlyRevenue {
  const MonthlyRevenue({required this.month, required this.amount});

  final DateTime month;
  final int amount;
}

class PlanFigure {
  const PlanFigure({required this.plan, required this.value});

  final String plan;
  final int value;
}

class SubscriptionOverview {
  const SubscriptionOverview({
    required this.activeSubscriptions,
    required this.unsubscribedShops,
    required this.expiringSoon,
    required this.expiredSubscriptions,
    required this.pendingPayments,
    required this.failedPaymentsThisMonth,
    required this.currentMonth,
    required this.monthlyRevenue,
    required this.yearToDateRevenue,
    required this.lifetimeRevenue,
    required this.revenueByPlan,
    required this.shopsByPlan,
    required this.updatedAt,
  });

  final int activeSubscriptions;
  final int unsubscribedShops;
  final int expiringSoon;
  final int expiredSubscriptions;
  final int pendingPayments;
  final int failedPaymentsThisMonth;
  final DateTime currentMonth;
  final List<MonthlyRevenue> monthlyRevenue;
  final int yearToDateRevenue;
  final int lifetimeRevenue;
  final List<PlanFigure> revenueByPlan;
  final List<PlanFigure> shopsByPlan;
  final DateTime updatedAt;

  int get totalSubscribedShops => activeSubscriptions + expiringSoon;

  int get thisMonthRevenue => monthlyRevenue.last.amount;

  int get lastMonthRevenue => monthlyRevenue[monthlyRevenue.length - 2].amount;

  DateTime get lastMonth => monthlyRevenue[monthlyRevenue.length - 2].month;

  double get monthOverMonthChange =>
      lastMonthRevenue == 0 ? 0 : thisMonthRevenue / lastMonthRevenue - 1;

  int get averageRevenuePerShop => totalSubscribedShops == 0
      ? 0
      : (thisMonthRevenue / totalSubscribedShops).round();

  int get planShopTotal =>
      shopsByPlan.fold(0, (sum, figure) => sum + figure.value);
}
