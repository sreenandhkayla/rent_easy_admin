import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/resources/strings/settings_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_dropdown.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_search_field.dart';
import '../../../../core/widgets/app_table_header.dart';
import '../../data/models/activity_log_entry.dart';

class ActivityLogsTab extends StatefulWidget {
  const ActivityLogsTab({
    super.key,
    required this.entries,
    required this.actors,
    required this.query,
    required this.selectedActor,
    required this.onSearch,
    required this.onActorChanged,
  });

  final List<ActivityLogEntry> entries;
  final List<String> actors;
  final String query;
  final String? selectedActor;
  final ValueChanged<String> onSearch;
  final ValueChanged<String?> onActorChanged;

  @override
  State<ActivityLogsTab> createState() => _ActivityLogsTabState();
}

class _ActivityLogsTabState extends State<ActivityLogsTab> {
  static const double _actorMinWidth = 126;

  late final TextEditingController _searchController = TextEditingController(
    text: widget.query,
  );

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LayoutBuilder(
          builder: (context, constraints) => Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              SizedBox(
                width: math.min(
                  constraints.maxWidth,
                  AppTheme.searchFieldMaxWidth,
                ),
                child: AppSearchField(
                  controller: _searchController,
                  hintText: SettingsStrings.logSearchHint,
                  onChanged: widget.onSearch,
                ),
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: _actorMinWidth),
                child: AppDropdown<String?>(
                  value: widget.selectedActor,
                  items: [null, ...widget.actors],
                  labelOf: (actor) => actor ?? SettingsStrings.allAdmins,
                  onChanged: widget.onActorChanged,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _LogsTable(entries: widget.entries),
      ],
    );
  }
}

class _Columns {
  static const int time = 13;
  static const int admin = 12;
  static const int action = 25;
  static const int target = 19;
  static const int reason = 23;
}

class _LogsTable extends StatelessWidget {
  const _LogsTable({required this.entries});

  static const double _minTableWidth = 960;

  final List<ActivityLogEntry> entries;

  @override
  Widget build(BuildContext context) {
    Widget header(String label, int flex) => Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Text(label, style: AppTextStyles.tableHeader),
      ),
    );
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: math.max(constraints.maxWidth, _minTableWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppTableHeader(
                      showTopBorder: false,
                      child: Row(
                        children: [
                          header(SettingsStrings.time, _Columns.time),
                          header(SettingsStrings.admin, _Columns.admin),
                          header(SettingsStrings.action, _Columns.action),
                          header(SettingsStrings.target, _Columns.target),
                          header(SettingsStrings.reason, _Columns.reason),
                        ],
                      ),
                    ),
                    if (entries.isEmpty)
                      const AppEmptyState(
                        icon: Icons.search,
                        title: SettingsStrings.noLogsTitle,
                        message: SettingsStrings.noLogsMessage,
                      ),
                    for (final ActivityLogEntry entry in entries)
                      _LogRow(entry: entry),
                  ],
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(SettingsStrings.auditNote, style: AppTextStyles.meta),
          ),
        ],
      ),
    );
  }
}

class _LogRow extends StatelessWidget {
  const _LogRow({required this.entry});

  final ActivityLogEntry entry;

  @override
  Widget build(BuildContext context) {
    Widget cell(String value, int flex, TextStyle style) => Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Text(value, style: style),
      ),
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          cell(
            AppFormatters.timestamp(entry.at),
            _Columns.time,
            AppTextStyles.bodySmall,
          ),
          cell(entry.actor, _Columns.admin, AppTextStyles.tableCell),
          cell(entry.action, _Columns.action, AppTextStyles.titleSmall),
          cell(entry.target, _Columns.target, AppTextStyles.tableCell),
          cell(
            entry.reason ?? SettingsStrings.emptyValue,
            _Columns.reason,
            AppTextStyles.bodySmall,
          ),
        ],
      ),
    );
  }
}
