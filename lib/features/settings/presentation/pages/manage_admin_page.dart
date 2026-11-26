import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/navigation/app_routes.dart';
import '../../../../core/resources/strings/settings_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_formatters.dart';
import '../../../../core/utils/app_messenger.dart';
import '../../../../core/widgets/admin_shell/admin_section.dart';
import '../../../../core/widgets/admin_shell/admin_shell.dart';
import '../../../../core/widgets/app_breadcrumbs.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_confirm_dialog.dart';
import '../../../../core/widgets/app_detail_field.dart';
import '../../../../core/widgets/app_secondary_button.dart';
import '../../../../core/widgets/app_text_link.dart';
import '../../data/models/admin_staff_member.dart';
import '../state/admin_form_state.dart';
import '../state/manage_admin_cubit.dart';
import '../state/manage_admin_state.dart';
import '../widgets/admin_form_card.dart';

class ManageAdminPage extends StatelessWidget {
  const ManageAdminPage({super.key, required this.adminId});

  final String? adminId;

  static void _backToStaff(BuildContext context, {bool saved = false}) {
    final NavigatorState navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop(saved);
    } else {
      navigator.pushReplacementNamed(AppRoutes.adminStaff);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ManageAdminCubit(adminId)..load(),
      child: BlocBuilder<ManageAdminCubit, ManageAdminState>(
        builder: (context, state) {
          final AdminStaffMember? member = state.member;
          final String title = member?.name ?? SettingsStrings.adminNotFound;
          return AdminShell(
            section: AdminSection.settings,
            isSectionRoot: false,
            title: title,
            subtitle: SettingsStrings.manageAdminSubtitle,
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
                AppBreadcrumb(title),
              ],
            ),
            child: switch (state.status) {
              ManageAdminStatus.loading => const Padding(
                padding: EdgeInsets.all(48),
                child: Center(child: CircularProgressIndicator()),
              ),
              ManageAdminStatus.notFound => _NotFound(
                onBack: () => _backToStaff(context),
              ),
              ManageAdminStatus.loaded => _ManageBody(
                state: state,
                member: member!,
                form: state.form!,
                onBack: (saved) => _backToStaff(context, saved: saved),
              ),
            },
          );
        },
      ),
    );
  }
}

class _ManageBody extends StatelessWidget {
  const _ManageBody({
    required this.state,
    required this.member,
    required this.form,
    required this.onBack,
  });

  static const double _twoColumnBreakpoint = 1000;

  final ManageAdminState state;
  final AdminStaffMember member;
  final AdminFormState form;
  final ValueChanged<bool> onBack;

  void _save(BuildContext context) {
    final AdminStaffMember? updated = context.read<ManageAdminCubit>().save();
    if (updated == null) return;
    context.showAppMessage(SettingsStrings.adminSaved(updated.name));
    onBack(true);
  }

  Future<void> _remove(BuildContext context) async {
    final ManageAdminCubit cubit = context.read<ManageAdminCubit>();
    final bool confirmed = await AppConfirmDialog.show(
      context,
      title: SettingsStrings.removeAdminTitle(member.name),
      message: SettingsStrings.removeAdminMessage(member.name),
      confirmLabel: SettingsStrings.removeAdmin,
      cancelLabel: SettingsStrings.cancel,
      isDestructive: true,
    );
    if (!confirmed || !context.mounted || !cubit.remove()) return;
    context.showAppMessage(SettingsStrings.adminRemoved(member.name));
    onBack(true);
  }

  @override
  Widget build(BuildContext context) {
    final ManageAdminCubit cubit = context.read<ManageAdminCubit>();
    final DateTime? lastSignIn = member.lastSignInAt;
    final Widget formCard = AdminFormCard(
      state: form,
      onNameChanged: cubit.setName,
      onEmailChanged: cubit.setEmail,
      onRoleChanged: cubit.setRole,
      onActiveChanged: cubit.setActive,
      onCancel: () => onBack(false),
      onSave: () => _save(context),
      saveLabel: SettingsStrings.saveChanges,
      formError: state.formError,
    );
    final Widget accountCard = AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(SettingsStrings.account, style: AppTextStyles.cardTitle),
          const SizedBox(height: 14),
          AppDetailField(label: SettingsStrings.adminId, value: member.adminId),
          const SizedBox(height: 14),
          AppDetailField(
            label: SettingsStrings.lastSignIn,
            value: lastSignIn == null
                ? SettingsStrings.invitationSent
                : AppFormatters.timestamp(lastSignIn),
          ),
          const Divider(height: 32, color: AppColors.divider),
          if (state.canRemove) ...[
            AppSecondaryButton(
              label: SettingsStrings.removeAdmin,
              icon: Icons.person_remove_outlined,
              isDestructive: true,
              isExpanded: true,
              labelStyle: AppTextStyles.actionLabel,
              onPressed: () => _remove(context),
            ),
            const SizedBox(height: 10),
          ],
          Text(
            state.isSelf
                ? SettingsStrings.cannotRemoveSelf
                : state.isLastSuperAdmin
                ? SettingsStrings.lastSuperAdmin
                : SettingsStrings.removeAdminNote,
            style: AppTextStyles.meta,
          ),
        ],
      ),
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < _twoColumnBreakpoint) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [formCard, const SizedBox(height: 16), accountCard],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 7, child: formCard),
            const SizedBox(width: 16),
            Expanded(flex: 4, child: accountCard),
          ],
        );
      },
    );
  }
}

class _NotFound extends StatelessWidget {
  const _NotFound({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            SettingsStrings.adminNotFoundMessage,
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 12),
          AppTextLink(label: SettingsStrings.backToAdminStaff, onTap: onBack),
        ],
      ),
    );
  }
}
