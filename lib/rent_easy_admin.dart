import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/access/role_preview_cubit.dart';
import 'core/navigation/app_routes.dart';
import 'core/theme/app_theme.dart';

class RentEasyAdmin extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RolePreviewCubit(),
      child: MaterialApp(
        title: "RentEasy Admin",
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        themeMode: ThemeMode.light,
        initialRoute: AppRoutes.login,
        onGenerateRoute: AppRoutes.onGenerateRoute,
        navigatorObservers: [AppRoutes.observer],
      ),
    );
  }
}
