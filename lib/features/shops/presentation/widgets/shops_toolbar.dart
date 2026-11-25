import 'package:flutter/material.dart';

import '../../../../core/enums/registration_date_filter.dart';
import '../../../../core/enums/subscription_plan.dart';
import '../../../../core/enums/subscription_status.dart';
import '../../../../core/resources/strings/app_strings.dart';
import '../../../../core/resources/strings/shops_strings.dart';
import '../../../../core/widgets/app_dropdown.dart';
import '../../../../core/widgets/app_search_field.dart';
import '../state/shops_state.dart';

class ShopsToolbar extends StatefulWidget {
  const ShopsToolbar({
    super.key,
    required this.state,
    required this.onSearch,
    required this.onSubscriptionChanged,
    required this.onPlanChanged,
    required this.onStatusChanged,
    required this.onDateChanged,
  });

  final ShopsState state;
  final ValueChanged<String> onSearch;
  final ValueChanged<SubscriptionFilter> onSubscriptionChanged;
  final ValueChanged<PlanFilter> onPlanChanged;
  final ValueChanged<ShopStatusFilter> onStatusChanged;
  final ValueChanged<RegistrationDateFilter> onDateChanged;

  @override
  State<ShopsToolbar> createState() => _ShopsToolbarState();
}

class _ShopsToolbarState extends State<ShopsToolbar> {
  static const double _searchWidth = 360;

  late final TextEditingController _searchController = TextEditingController(
    text: widget.state.query,
  );

  static String _statusLabel(ShopStatusFilter filter) => switch (filter) {
    ShopStatusFilter.all => ShopsStrings.allShopStatuses,
    ShopStatusFilter.active => AppStrings.statusActive,
    ShopStatusFilter.restricted => AppStrings.statusRestricted,
  };

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          SizedBox(
            width: constraints.maxWidth < _searchWidth
                ? constraints.maxWidth
                : _searchWidth,
            child: AppSearchField(
              controller: _searchController,
              hintText: ShopsStrings.searchHint,
              onChanged: widget.onSearch,
            ),
          ),
          AppDropdown<SubscriptionFilter>(
            value: widget.state.subscriptionFilter,
            items: SubscriptionFilter.values,
            labelOf: (filter) =>
                filter.status?.label ?? ShopsStrings.allSubscriptions,
            onChanged: widget.onSubscriptionChanged,
          ),
          AppDropdown<PlanFilter>(
            value: widget.state.planFilter,
            items: PlanFilter.values,
            labelOf: (filter) => filter.label,
            onChanged: widget.onPlanChanged,
          ),
          AppDropdown<ShopStatusFilter>(
            value: widget.state.statusFilter,
            items: ShopStatusFilter.values,
            labelOf: _statusLabel,
            onChanged: widget.onStatusChanged,
          ),
          AppDropdown<RegistrationDateFilter>(
            value: widget.state.dateFilter,
            items: RegistrationDateFilter.values,
            labelOf: (filter) => filter.label,
            onChanged: widget.onDateChanged,
          ),
        ],
      ),
    );
  }
}
