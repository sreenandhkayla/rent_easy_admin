import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/owner_details.dart';
import '../../data/models/shop_owner.dart';
import '../../data/shop_owners_mock_data.dart';
import 'owner_details_state.dart';

class OwnerDetailsCubit extends Cubit<OwnerDetailsState> {
  OwnerDetailsCubit(this.ownerId) : super(const OwnerDetailsState());

  final String? ownerId;

  void load() {
    final String? id = ownerId;
    final OwnerDetails? details = id == null
        ? null
        : ShopOwnersMockData.details(id);
    emit(
      OwnerDetailsState(
        status: details == null
            ? OwnerDetailsStatus.notFound
            : OwnerDetailsStatus.loaded,
        details: details,
        updatedAt: DateTime.now(),
      ),
    );
  }

  void restrict({required String reason, required String actor}) => _setStatus(
    OwnerStatus.restricted,
    OwnerActivity(
      title: 'Account restricted · ${reason.trim()}',
      actor: actor,
      at: DateTime.now(),
    ),
  );

  void restore({required String actor}) => _setStatus(
    OwnerStatus.active,
    OwnerActivity(title: 'Account restored', actor: actor, at: DateTime.now()),
  );

  void _setStatus(OwnerStatus status, OwnerActivity activity) {
    final String? id = ownerId;
    if (id == null || state.details == null) return;
    ShopOwnersMockData.updateStatus(id, status, activity);
    load();
  }
}
