import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/access/role_preview_cubit.dart';
import 'core/di/injection.dart';
import 'core/navigation/app_routes.dart';
import 'core/resources/strings/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/state/admin_session_cubit.dart';
import 'features/auth/presentation/state/admin_session_state.dart';
import 'features/settings/presentation/state/platform_branding_cubit.dart';

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
        BlocProvider<PlatformBrandingCubit>(
          create: (_) => getIt<PlatformBrandingCubit>()..load(),
        ),
      ],
      child: BlocListener<AdminSessionCubit, AdminSessionState>(
        listenWhen: (previous, current) =>
            previous.status != current.status &&
            current.status == AdminSessionStatus.signedIn,
        listener: (context, _) => context.read<PlatformBrandingCubit>().load(),
        child: BlocBuilder<PlatformBrandingCubit, String?>(
          builder: (context, platformName) => MaterialApp(
            title: platformName == null
                ? AppStrings.consoleTitle
                : AppStrings.consoleTitleFor(platformName),
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            themeMode: ThemeMode.light,
            initialRoute: AppRoutes.login,
            onGenerateRoute: AppRoutes.onGenerateRoute,
            onGenerateInitialRoutes: AppRoutes.onGenerateInitialRoutes,
            navigatorObservers: [AppRoutes.observer],
          ),
        ),
      ),
    );
  }
}
