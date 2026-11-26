import 'models/analytics_snapshot.dart';

class AnalyticsMockData {
  AnalyticsMockData._();

  static final DateTime _currentMonth = DateTime(2026, 11);

  static AnalyticsSnapshot snapshot() => AnalyticsSnapshot(
    totalItems: 42860,
    totalRentals: 18450,
    totalCustomers: 24320,
    currentMonth: _currentMonth,
    monthly: {
      AnalyticsMetric.shopRegistrations: _months(
        const [96, 101, 108, 104, 112, 118, 120, 126, 141, 134, 152, 167],
        const [78, 84, 88, 85, 92, 97, 101, 104, 116, 112, 126, 139],
      ),
      AnalyticsMetric.ownerRegistrations: _months(
        const [74, 79, 85, 81, 88, 93, 98, 103, 113, 108, 120, 131],
        const [61, 66, 70, 67, 73, 77, 81, 86, 94, 90, 101, 110],
      ),
      AnalyticsMetric.activeSubscriptions: _months(
        const [832, 841, 852, 866, 880, 893, 905, 915, 928, 940, 966, 987],
        const [690, 701, 712, 724, 738, 750, 761, 772, 784, 795, 812, 826],
      ),
      AnalyticsMetric.verifiedRevenue: _months(
        const [
          612000,
          624000,
          638000,
          651000,
          667000,
          681000,
          695000,
          710000,
          722000,
          731000,
          730000,
          749000,
        ],
        const [
          512000,
          521000,
          533000,
          544000,
          556000,
          569000,
          580000,
          592000,
          603000,
          611000,
          614000,
          628000,
        ],
      ),
    },
    yearly: {
      AnalyticsMetric.shopRegistrations: _years(const [
        980,
        1240,
        1460,
        1610,
        1735,
      ]),
      AnalyticsMetric.ownerRegistrations: _years(const [
        760,
        990,
        1170,
        1290,
        1388,
      ]),
      AnalyticsMetric.activeSubscriptions: _years(const [
        410,
        560,
        720,
        870,
        987,
      ]),
      AnalyticsMetric.verifiedRevenue: _years(const [
        5240000,
        6380000,
        7410000,
        8260000,
        8090000,
      ]),
    },
    planShares: const [
      AnalyticsShare(label: 'Basic', value: 412),
      AnalyticsShare(label: 'Professional', value: 389),
      AnalyticsShare(label: 'Premium', value: 186),
    ],
    shopStatus: const ShopStatusBreakdown(
      active: 1206,
      inactive: 326,
      restricted: 43,
    ),
    subscriptionFigures: const SubscriptionFigures(
      renewals: 384,
      expiries: 61,
      expiringSoon: 46,
      paymentSuccessRate: 0.962,
      failedPayments: 18,
      multiShopOwners: 196,
    ),
  );

  static List<AnalyticsPoint> _months(List<int> values, List<int> lastYear) => [
    for (int i = 0; i < values.length; i++)
      AnalyticsPoint(
        period: DateTime(
          _currentMonth.year,
          _currentMonth.month - values.length + 1 + i,
        ),
        value: values[i],
        previousYear: lastYear[i],
      ),
  ];

  static List<AnalyticsPoint> _years(List<int> values) => [
    for (int i = 0; i < values.length; i++)
      AnalyticsPoint(
        period: DateTime(_currentMonth.year - values.length + 1 + i),
        value: values[i],
      ),
  ];
}
