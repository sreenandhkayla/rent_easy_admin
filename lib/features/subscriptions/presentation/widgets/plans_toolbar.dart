import 'package:flutter/material.dart';

import '../../../../core/resources/strings/subscriptions_strings.dart';
import '../../../../core/widgets/app_notice_banner.dart';
import '../../../../core/widgets/app_primary_button.dart';

class PlansToolbar extends StatelessWidget {
  const PlansToolbar({super.key, required this.onCreatePlan});

  final VoidCallback onCreatePlan;

  static const double _stackBreakpoint = 640;

  @override
  Widget build(BuildContext context) {
    const Widget notice = AppNoticeBanner(
      tone: AppNoticeTone.info,
      icon: Icons.warning_amber_rounded,
      message: SubscriptionsStrings.plansNotice,
    );
    final Widget createButton = AppPrimaryButton(
      label: SubscriptionsStrings.createPlan,
      icon: Icons.add,
      isCompact: true,
      onPressed: onCreatePlan,
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < _stackBreakpoint) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              notice,
              const SizedBox(height: 12),
              Align(alignment: Alignment.centerRight, child: createButton),
            ],
          );
        }
        return Row(
          children: [
            const Expanded(child: notice),
            const SizedBox(width: 12),
            createButton,
          ],
        );
      },
    );
  }
}
