import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/shop.dart';
import '../../data/models/shop_details.dart';
import '../../data/shops_mock_data.dart';
import 'shop_details_state.dart';

class ShopDetailsCubit extends Cubit<ShopDetailsState> {
  ShopDetailsCubit(this.shopId) : super(const ShopDetailsState());

  final String? shopId;

  void load() {
    final String? id = shopId;
    final ShopDetails? details = id == null ? null : ShopsMockData.details(id);
    emit(
      ShopDetailsState(
        status: details == null
            ? ShopDetailsStatus.notFound
            : ShopDetailsStatus.loaded,
        details: details,
        updatedAt: DateTime.now(),
      ),
    );
  }

  void restrict({required String reason, required String actor}) => _setStatus(
    ShopStatus.restricted,
    ShopActivity(
      title: 'Restricted shop',
      actor: actor,
      at: DateTime.now(),
      reason: reason.trim(),
      isHighlighted: true,
    ),
  );

  void restore({required String actor}) => _setStatus(
    ShopStatus.active,
    ShopActivity(title: 'Restored shop', actor: actor, at: DateTime.now()),
  );

  void _setStatus(ShopStatus status, ShopActivity activity) {
    final String? id = shopId;
    if (id == null || state.details == null) return;
    ShopsMockData.updateStatus(id, status, activity);
    load();
  }
}
