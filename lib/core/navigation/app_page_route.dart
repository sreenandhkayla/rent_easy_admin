import 'package:flutter/material.dart';

import '../../features/auth/presentation/widgets/admin_access_gate.dart';
import '../theme/app_theme.dart';
import '../widgets/admin_shell/admin_section.dart';

class AppPageRoute<T> extends PageRouteBuilder<T> {
  AppPageRoute({
    required RouteSettings super.settings,
    required WidgetBuilder builder,
    this.fadesWholePage = false,
    AdminSection? section,
  }) : super(
         pageBuilder: (context, _, _) => section == null
             ? builder(context)
             : AdminAccessGate(section: section, child: builder(context)),
         transitionDuration: fadesWholePage
             ? AppTheme.pageTransitionDuration
             : Duration.zero,
         reverseTransitionDuration: fadesWholePage
             ? AppTheme.pageTransitionDuration
             : Duration.zero,
       );

  final bool fadesWholePage;

  @override
  RoutePopDisposition get popDisposition {
    final disposition = super.popDisposition;
    return disposition == RoutePopDisposition.bubble
        ? RoutePopDisposition.doNotPop
        : disposition;
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (!fadesWholePage) return child;
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: AppTheme.pageTransitionCurve,
      ),
      child: child,
    );
  }
}
