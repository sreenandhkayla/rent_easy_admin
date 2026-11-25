import 'dart:math' as math;

import 'package:flutter/material.dart';

class AppResponsiveGrid extends StatelessWidget {
  const AppResponsiveGrid({
    super.key,
    required this.children,
    required this.minItemWidth,
    this.maxColumns = 4,
    this.spacing = 16,
  });

  final List<Widget> children;
  final double minItemWidth;
  final int maxColumns;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final int fit =
            ((constraints.maxWidth + spacing) / (minItemWidth + spacing))
                .floor();
        final int columns = math.max(1, math.min(maxColumns, fit));
        final List<Widget> rows = [];
        for (int start = 0; start < children.length; start += columns) {
          final List<Widget> cells = [];
          for (int i = 0; i < columns; i++) {
            if (i > 0) cells.add(SizedBox(width: spacing));
            final int index = start + i;
            cells.add(
              Expanded(
                child: index < children.length
                    ? children[index]
                    : const SizedBox.shrink(),
              ),
            );
          }
          if (rows.isNotEmpty) rows.add(SizedBox(height: spacing));
          rows.add(
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: cells,
              ),
            ),
          );
        }
        return Column(children: rows);
      },
    );
  }
}
