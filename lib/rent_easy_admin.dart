import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/access/role_preview_cubit.dart';
import 'core/di/injection.dart';
import 'core/navigation/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/state/admin_session_cubit.dart';

class RentEasyAdmin extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AdminSessionCubit>(
          create: (_) => getIt<AdminSessionCubit>()..restore(),
        ),
        BlocProvider<RolePreviewCubit>(create: (_) => RolePreviewCubit()),
      ],
      child: MaterialApp(
        title: "RentEasy Admin",
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        themeMode: ThemeMode.light,
        initialRoute: AppRoutes.login,
        onGenerateRoute: AppRoutes.onGenerateRoute,
        onGenerateInitialRoutes: AppRoutes.onGenerateInitialRoutes,
        navigatorObservers: [AppRoutes.observer],
      ),
    );
  }
}
