import 'package:flutter/material.dart';

import '../../../../core/resources/strings/subscriptions_strings.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_search_field.dart';
import '../../../../core/widgets/app_segmented_tabs.dart';
import '../state/subscriptions_state.dart';

class SubscriptionPaymentsToolbar extends StatefulWidget {
  const SubscriptionPaymentsToolbar({
    super.key,
    required this.state,
    required this.onFilterChanged,
    required this.onSearch,
  });

  final SubscriptionsState state;
  final ValueChanged<PaymentFilter> onFilterChanged;
  final ValueChanged<String> onSearch;

  @override
  State<SubscriptionPaymentsToolbar> createState() =>
      _SubscriptionPaymentsToolbarState();
}

class _SubscriptionPaymentsToolbarState
    extends State<SubscriptionPaymentsToolbar> {
  late final TextEditingController _searchController = TextEditingController(
    text: widget.state.paymentQuery,
  );

  static String _label(PaymentFilter filter) => switch (filter) {
    PaymentFilter.all => SubscriptionsStrings.statusAll,
    PaymentFilter.successful => SubscriptionsStrings.successful,
    PaymentFilter.pending => SubscriptionsStrings.pending,
    PaymentFilter.failed => SubscriptionsStrings.failed,
  };

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SubscriptionsState state = widget.state;
    return LayoutBuilder(
      builder: (context, constraints) => Wrap(
        spacing: 10,
        runSpacing: 10,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          AppSegmentedTabs(
            labels: [for (final f in PaymentFilter.values) _label(f)],
            counts: [
              for (final f in PaymentFilter.values) state.paymentCountFor(f),
            ],
            selectedIndex: state.paymentFilter.index,
            onSelected: (index) =>
                widget.onFilterChanged(PaymentFilter.values[index]),
          ),
          SizedBox(
            width: constraints.maxWidth < AppTheme.searchFieldMaxWidth
                ? constraints.maxWidth
                : AppTheme.searchFieldMaxWidth,
            child: AppSearchField(
              controller: _searchController,
              hintText: SubscriptionsStrings.paymentSearchHint,
              onChanged: widget.onSearch,
            ),
          ),
        ],
      ),
    );
  }
}
