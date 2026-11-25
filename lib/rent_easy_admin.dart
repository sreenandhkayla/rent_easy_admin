import 'package:flutter/material.dart';

import 'core/navigation/app_routes.dart';
import 'core/theme/app_theme.dart';

class RentEasyAdmin extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "RentEasy Admin",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      themeMode: ThemeMode.light,
      initialRoute: AppRoutes.login,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
