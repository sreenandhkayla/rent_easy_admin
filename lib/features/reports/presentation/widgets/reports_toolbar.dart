import 'package:flutter/material.dart';

import '../../../../core/resources/strings/reports_strings.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_dropdown.dart';
import '../../../../core/widgets/app_search_field.dart';
import '../../../../core/widgets/app_segmented_tabs.dart';
import '../../data/models/shop_report.dart';
import '../state/reports_state.dart';

class ReportsToolbar extends StatefulWidget {
  const ReportsToolbar({
    super.key,
    required this.state,
    required this.onStatusChanged,
    required this.onSearch,
    required this.onCategoryChanged,
    required this.onDateChanged,
  });

  final ReportsState state;
  final ValueChanged<ReportStatusFilter> onStatusChanged;
  final ValueChanged<String> onSearch;
  final ValueChanged<ReportCategory?> onCategoryChanged;
  final ValueChanged<ReportDateFilter> onDateChanged;

  @override
  State<ReportsToolbar> createState() => _ReportsToolbarState();
}

class _ReportsToolbarState extends State<ReportsToolbar> {
  static const double _categoryWidth = 136;
  static const double _dateWidth = 116;

  late final TextEditingController _searchController = TextEditingController(
    text: widget.state.query,
  );

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ReportsState state = widget.state;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSegmentedTabs(
          labels: [for (final f in ReportStatusFilter.values) f.label],
          counts: [
            for (final f in ReportStatusFilter.values) state.countFor(f),
          ],
          selectedIndex: state.statusFilter.index,
          onSelected: (index) =>
              widget.onStatusChanged(ReportStatusFilter.values[index]),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) => Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              SizedBox(
                width: constraints.maxWidth < AppTheme.searchFieldMaxWidth
                    ? constraints.maxWidth
                    : AppTheme.searchFieldMaxWidth,
                child: AppSearchField(
                  controller: _searchController,
                  hintText: ReportsStrings.searchHint,
                  onChanged: widget.onSearch,
                ),
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: _categoryWidth),
                child: AppDropdown<ReportCategory?>(
                  value: state.category,
                  items: const [null, ...ReportCategory.values],
                  labelOf: (category) =>
                      category?.label ?? ReportsStrings.categoryAll,
                  onChanged: widget.onCategoryChanged,
                ),
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: _dateWidth),
                child: AppDropdown<ReportDateFilter>(
                  value: state.dateFilter,
                  items: ReportDateFilter.values,
                  labelOf: (filter) => filter.label,
                  onChanged: widget.onDateChanged,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
