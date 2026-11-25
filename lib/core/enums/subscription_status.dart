import '../resources/strings/app_strings.dart';

enum SubscriptionStatus {
  active(AppStrings.statusActive),
  expiringSoon(AppStrings.statusExpiringSoon),
  expired(AppStrings.statusExpired),
  unsubscribed(AppStrings.statusUnsubscribed);

  const SubscriptionStatus(this.label);

  final String label;
}

enum SubscriptionFilter {
  all(null),
  active(SubscriptionStatus.active),
  expiringSoon(SubscriptionStatus.expiringSoon),
  expired(SubscriptionStatus.expired),
  unsubscribed(SubscriptionStatus.unsubscribed);

  const SubscriptionFilter(this.status);

  final SubscriptionStatus? status;

  bool matches(SubscriptionStatus value) => status == null || status == value;
}
