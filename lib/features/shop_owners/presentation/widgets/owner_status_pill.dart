import 'package:flutter/material.dart';

import '../../../../core/resources/strings/shop_owners_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_access_status_pill.dart';
import '../../../../core/widgets/app_status_pill.dart';
import '../../data/models/shop_owner.dart';

class OwnerStatusPill extends StatelessWidget {
  const OwnerStatusPill({super.key, required this.status});

  final OwnerStatus status;

  @override
  Widget build(BuildContext context) => switch (status) {
    OwnerStatus.deleted => const AppStatusPill(
      label: ShopOwnersStrings.deleted,
      color: AppColors.textSecondary,
      backgroundColor: AppColors.iconCircle,
    ),
    OwnerStatus.restricted => const AppAccessStatusPill(isRestricted: true),
    OwnerStatus.active => const AppAccessStatusPill(isRestricted: false),
  };
}
