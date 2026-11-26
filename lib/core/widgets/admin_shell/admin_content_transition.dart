import 'package:flutter/material.dart';

import '../../navigation/app_routes.dart';
import '../../theme/app_theme.dart';

class AdminContentTransition extends StatefulWidget {
  const AdminContentTransition({super.key, required this.child});

  final Widget child;

  @override
  State<AdminContentTransition> createState() => _AdminContentTransitionState();
}

class _AdminContentTransitionState extends State<AdminContentTransition>
    with SingleTickerProviderStateMixin, RouteAware {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppTheme.pageTransitionDuration,
  );
  late final Animation<double> _curve = CurvedAnimation(
    parent: _controller,
    curve: AppTheme.pageTransitionCurve,
  );
  late final Animation<Offset> _offset = Tween<Offset>(
    begin: AppTheme.pageTransitionOffset,
    end: Offset.zero,
  ).animate(_curve);
  PageRoute<dynamic>? _route;

  @override
  void initState() {
    super.initState();
    _controller.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ModalRoute<dynamic>? route = ModalRoute.of(context);
    if (route is PageRoute<dynamic> && route != _route) {
      if (_route != null) AppRoutes.observer.unsubscribe(this);
      _route = route;
      AppRoutes.observer.subscribe(this, route);
    }
  }

  @override
  void didPopNext() => _controller.forward(from: 0);

  @override
  void dispose() {
    AppRoutes.observer.unsubscribe(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _curve,
      child: SlideTransition(position: _offset, child: widget.child),
    );
  }
}
