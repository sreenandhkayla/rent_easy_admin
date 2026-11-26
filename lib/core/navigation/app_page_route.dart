import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AppPageRoute<T> extends PageRouteBuilder<T> {
  AppPageRoute({
    required RouteSettings super.settings,
    required WidgetBuilder builder,
    this.fadesWholePage = false,
  }) : super(
         pageBuilder: (context, _, _) => builder(context),
         transitionDuration: fadesWholePage
             ? AppTheme.pageTransitionDuration
             : Duration.zero,
         reverseTransitionDuration: fadesWholePage
             ? AppTheme.pageTransitionDuration
             : Duration.zero,
       );

  final bool fadesWholePage;

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
