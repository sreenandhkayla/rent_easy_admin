import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/shop_subscription.dart';
import '../../data/subscriptions_mock_data.dart';
import 'subscription_details_state.dart';

class SubscriptionDetailsCubit extends Cubit<SubscriptionDetailsState> {
  SubscriptionDetailsCubit(this.shopId)
    : super(const SubscriptionDetailsState());

  final String? shopId;

  void load() {
    final String? id = shopId;
    final SubscriptionDetails? details = id == null
        ? null
        : SubscriptionsMockData.details(id);
    emit(
      SubscriptionDetailsState(
        status: details == null
            ? SubscriptionDetailsStatus.notFound
            : SubscriptionDetailsStatus.loaded,
        details: details,
        updatedAt: DateTime.now(),
      ),
    );
  }

  void simulateVerifiedRenewal() {
    final String? id = shopId;
    if (id == null || state.details == null) return;
    SubscriptionsMockData.simulateVerifiedRenewal(id, DateTime.now());
    load();
  }
}
