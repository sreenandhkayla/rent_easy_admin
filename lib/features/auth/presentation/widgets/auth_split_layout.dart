import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_theme.dart';
import 'login_brand_panel.dart';

class AuthSplitLayout extends StatelessWidget {
  const AuthSplitLayout({super.key, required this.child});

  static const double _splitBreakpoint = 900;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            final Widget form = _FormPanel(child: child);
            if (constraints.maxWidth < _splitBreakpoint) return form;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Expanded(child: LoginBrandPanel()),
                Expanded(child: form),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _FormPanel extends StatelessWidget {
  const _FormPanel({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppTheme.authFormMaxWidth,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
