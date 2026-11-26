import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/navigation/app_routes.dart';
import '../../../../core/resources/strings/settings_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_messenger.dart';
import '../../../../core/widgets/admin_shell/admin_section.dart';
import '../../../../core/widgets/admin_shell/admin_shell.dart';
import '../../../../core/widgets/app_breadcrumbs.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_refresh_button.dart';
import '../state/edit_profile_cubit.dart';
import '../state/edit_profile_state.dart';
import '../widgets/edit_profile_form_card.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  static const double _twoColumnBreakpoint = 1000;

  static void _backToProfile(BuildContext context, {bool saved = false}) {
    final NavigatorState navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop(saved);
    } else {
      navigator.pushReplacementNamed(AppRoutes.settings);
    }
  }

  void _save(BuildContext context) {
    if (!context.read<EditProfileCubit>().save()) return;
    context.showAppMessage(SettingsStrings.profileUpdated);
    _backToProfile(context, saved: true);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EditProfileCubit(),
      child: BlocBuilder<EditProfileCubit, EditProfileState>(
        builder: (context, state) {
          final EditProfileCubit cubit = context.read<EditProfileCubit>();
          final Widget form = EditProfileFormCard(
            state: state,
            onNameChanged: cubit.setName,
            onMobileChanged: cubit.setMobileNumber,
            onCancel: () => _backToProfile(context),
            onSave: () => _save(context),
          );
          const Widget info = AppCard(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  SettingsStrings.aboutProfile,
                  style: AppTextStyles.cardTitle,
                ),
                SizedBox(height: 12),
                Text(
                  SettingsStrings.aboutProfileBody,
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          );
          return AdminShell(
            section: AdminSection.settings,
            isSectionRoot: false,
            title: SettingsStrings.editProfile,
            subtitle: SettingsStrings.editProfileSubtitle,
            breadcrumb: AppBreadcrumbs(
              items: [
                AppBreadcrumb(
                  SettingsStrings.title,
                  onTap: () => _backToProfile(context),
                ),
                AppBreadcrumb(
                  SettingsStrings.tabAdminProfile,
                  onTap: () => _backToProfile(context),
                ),
                const AppBreadcrumb(SettingsStrings.editProfile),
              ],
            ),
            headerActions: [
              AppRefreshButton(
                updatedAt: state.updatedAt,
                onPressed: cubit.refresh,
              ),
            ],
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < _twoColumnBreakpoint) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [form, const SizedBox(height: 16), info],
                  );
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 7, child: form),
                    const SizedBox(width: 16),
                    const Expanded(flex: 4, child: info),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
