import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'app_card.dart';
import 'app_responsive_grid.dart';
import 'app_shimmer.dart';

class AppListSkeleton extends StatelessWidget {
  const AppListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppShimmer(
          child: AppResponsiveGrid(
            minItemWidth: 220,
            maxColumns: 3,
            children: [
              AppSkeletonBox(height: 112, radius: AppTheme.radiusCard),
              AppSkeletonBox(height: 112, radius: AppTheme.radiusCard),
              AppSkeletonBox(height: 112, radius: AppTheme.radiusCard),
            ],
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) => AppShimmer(
            child: AppSkeletonBox(
              width: constraints.maxWidth < 320 ? constraints.maxWidth : 320,
              height: 32,
            ),
          ),
        ),
        const SizedBox(height: 16),
        AppCard(
          child: LayoutBuilder(
            builder: (context, constraints) => AppShimmer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSkeletonBox(
                    width: constraints.maxWidth * 0.4,
                    height: 14,
                    radius: 7,
                  ),
                  for (int i = 0; i < 4; i++) ...[
                    const SizedBox(height: 12),
                    const AppSkeletonBox(height: 34),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
