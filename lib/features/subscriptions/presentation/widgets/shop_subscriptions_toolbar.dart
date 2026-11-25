import 'package:flutter/material.dart';

import '../../../../core/enums/subscription_plan.dart';
import '../../../../core/enums/subscription_status.dart';
import '../../../../core/resources/strings/subscriptions_strings.dart';
import '../../../../core/widgets/app_dropdown.dart';
import '../../../../core/widgets/app_search_field.dart';
import '../../../../core/widgets/app_segmented_tabs.dart';
import '../state/subscriptions_state.dart';

class ShopSubscriptionsToolbar extends StatefulWidget {
  const ShopSubscriptionsToolbar({
    super.key,
    required this.state,
    required this.onStatusChanged,
    required this.onSearch,
    required this.onPlanChanged,
    required this.onExpiryChanged,
  });

  final SubscriptionsState state;
  final ValueChanged<SubscriptionFilter> onStatusChanged;
  final ValueChanged<String> onSearch;
  final ValueChanged<PlanFilter> onPlanChanged;
  final ValueChanged<ExpiryFilter> onExpiryChanged;

  @override
  State<ShopSubscriptionsToolbar> createState() =>
      _ShopSubscriptionsToolbarState();
}

class _ShopSubscriptionsToolbarState extends State<ShopSubscriptionsToolbar> {
  static const double _singleRowBreakpoint = 1100;
  static const double _searchMinWidth = 280;

  late final TextEditingController _searchController = TextEditingController(
    text: widget.state.query,
  );

  static String _statusLabel(SubscriptionFilter filter) =>
      filter.status?.label ?? SubscriptionsStrings.statusAll;

  static String _expiryLabel(ExpiryFilter filter) => switch (filter) {
    ExpiryFilter.any => SubscriptionsStrings.anyExpiryDate,
    ExpiryFilter.next7Days => SubscriptionsStrings.expiresIn7Days,
    ExpiryFilter.next30Days => SubscriptionsStrings.expiresIn30Days,
    ExpiryFilter.expired => SubscriptionsStrings.alreadyExpired,
  };

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SubscriptionsState state = widget.state;
    final Widget statusTabs = AppSegmentedTabs(
      labels: [for (final f in SubscriptionFilter.values) _statusLabel(f)],
      counts: [for (final f in SubscriptionFilter.values) state.countFor(f)],
      selectedIndex: state.statusFilter.index,
      onSelected: (index) =>
          widget.onStatusChanged(SubscriptionFilter.values[index]),
    );
    final Widget search = AppSearchField(
      controller: _searchController,
      hintText: SubscriptionsStrings.searchHint,
      onChanged: widget.onSearch,
    );
    final Widget plan = AppDropdown<PlanFilter>(
      value: state.planFilter,
      items: PlanFilter.values,
      labelOf: (filter) => filter.label,
      onChanged: widget.onPlanChanged,
    );
    final Widget expiry = AppDropdown<ExpiryFilter>(
      value: state.expiryFilter,
      items: ExpiryFilter.values,
      labelOf: _expiryLabel,
      onChanged: widget.onExpiryChanged,
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= _singleRowBreakpoint) {
          return Row(
            children: [
              statusTabs,
              const SizedBox(width: 10),
              Expanded(child: search),
              const SizedBox(width: 10),
              plan,
              const SizedBox(width: 10),
              expiry,
            ],
          );
        }
        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            statusTabs,
            SizedBox(
              width: constraints.maxWidth < _searchMinWidth
                  ? constraints.maxWidth
                  : _searchMinWidth,
              child: search,
            ),
            plan,
            expiry,
          ],
        );
      },
    );
  }
}
