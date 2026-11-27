class DashboardCounts {
  const DashboardCounts({
    required this.totalShops,
    required this.totalShopOwners,
    required this.fetchedAt,
  });

  final int totalShops;
  final int totalShopOwners;
  final DateTime fetchedAt;
}
