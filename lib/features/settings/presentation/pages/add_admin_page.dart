import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../../core/resources/strings/settings_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_messenger.dart';
import '../../../../core/widgets/admin_shell/admin_section.dart';
import '../../../../core/widgets/admin_shell/admin_shell.dart';
import '../../../../core/widgets/app_breadcrumbs.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_refresh_button.dart';
import '../../data/models/admin_staff_member.dart';
import '../../data/repositories/admin_staff_repository.dart';
import '../state/add_admin_cubit.dart';
import '../state/admin_form_state.dart';
import '../widgets/admin_form_card.dart';

class AddAdminPage extends StatelessWidget {
  const AddAdminPage({super.key});

  static const double _twoColumnBreakpoint = 1000;

  static void _backToStaff(BuildContext context, {bool saved = false}) {
    final NavigatorState navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop(saved);
    } else {
      navigator.pushReplacementNamed(AppRoutes.adminStaff);
    }
  }

  Future<void> _save(BuildContext context) async {
    final result = await context.read<AddAdminCubit>().save();
    if (!context.mounted) return;
    if (result.error case final String error) {
      context.showAppMessage(error);
      return;
    }
    final AddedAdmin? added = result.added;
    if (added == null) return;
    final AdminStaffMember member = added.member;
    context.showAppMessage(
      added.isNewLogin
          ? SettingsStrings.adminCreated(member.name, member.role)
          : SettingsStrings.adminAddedExistingLogin(member.name, member.role),
    );
    _backToStaff(context, saved: true);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AddAdminCubit>(),
      child: BlocBuilder<AddAdminCubit, AdminFormState>(
        builder: (context, state) {
          final AddAdminCubit cubit = context.read<AddAdminCubit>();
          final Widget form = AdminFormCard(
            state: state,
            onNameChanged: cubit.setName,
            onEmailChanged: cubit.setEmail,
            onPasswordChanged: cubit.setPassword,
            onRoleChanged: cubit.setRole,
            onActiveChanged: cubit.setActive,
            onCancel: () => _backToStaff(context),
            onSave: () => _save(context),
            saveLabel: SettingsStrings.addAdmin,
          );
          const Widget info = AppCard(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  SettingsStrings.whatHappensNext,
                  style: AppTextStyles.cardTitle,
                ),
                SizedBox(height: 12),
                Text(
                  SettingsStrings.whatHappensNextBody,
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          );
          return AdminShell(
            section: AdminSection.settings,
            isSectionRoot: false,
            title: SettingsStrings.addAdmin,
            subtitle: SettingsStrings.addAdminSubtitle,
            breadcrumb: AppBreadcrumbs(
              items: [
                AppBreadcrumb(
                  SettingsStrings.title,
                  onTap: () => Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil(AppRoutes.settings, (_) => false),
                ),
                AppBreadcrumb(
                  SettingsStrings.tabAdminStaff,
                  onTap: () => _backToStaff(context),
                ),
                const AppBreadcrumb(SettingsStrings.addAdmin),
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
