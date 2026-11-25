import 'package:flutter/material.dart';

import '../../resources/strings/app_strings.dart';
import '../../utils/app_messenger.dart';
import 'admin_section.dart';

void openAdminSection(
  BuildContext context,
  AdminSection section, {
  AdminSection? current,
}) {
  if (section == current) return;
  final String? route = section.route;
  if (route == null) {
    context.showAppMessage(AppStrings.sectionNotBuilt(section.label));
    return;
  }
  Navigator.of(context).pushNamedAndRemoveUntil(route, (_) => false);
}

void returnToSection(BuildContext context, AdminSection section) {
  final NavigatorState navigator = Navigator.of(context);
  if (navigator.canPop()) {
    navigator.pop();
    return;
  }
  final String? route = section.route;
  if (route != null) navigator.pushReplacementNamed(route);
}
