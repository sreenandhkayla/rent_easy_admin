import 'package:flutter/material.dart';

import '../../../../core/resources/strings/settings_strings.dart';
// import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_brand_logo.dart';
import '../../../../core/widgets/app_card.dart';
// import '../../../../core/widgets/app_dropdown.dart';
import '../../../../core/widgets/app_labeled_field.dart';
import '../../../../core/widgets/app_primary_button.dart';
// import '../../../../core/widgets/app_status_pill.dart';
import '../../../../core/widgets/app_text_field.dart';
// import '../../../../core/widgets/app_toggle_row.dart';
import '../../data/models/platform_settings.dart';
import '../state/settings_state.dart';

typedef PlatformEdit = void Function(
  PlatformSettings Function(PlatformSettings) change,
);

class PlatformSettingsTab extends StatelessWidget {
  const PlatformSettingsTab({
    super.key,
    required this.settings,
    required this.versions,
    required this.errors,
    required this.onEdit,
    required this.onSave,
    this.isSaving = false,
  });

  // static const double _twoColumnBreakpoint = 1000;

  final PlatformSettings settings;
  final AppVersionInfo versions;
  final PlatformErrors errors;
  final PlatformEdit onEdit;
  final VoidCallback onSave;
  final bool isSaving;

  @override
  Widget build(BuildContext context) {
    final Widget main = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _GeneralCard(settings: settings, errors: errors, onEdit: onEdit),
        const SizedBox(height: 16),
        // _ConfigurationCard(settings: settings, onEdit: onEdit),
        // const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerRight,
          child: AppPrimaryButton(
            label: SettingsStrings.saveSettings,
            isCompact: true,
            isLoading: isSaving,
            onPressed: onSave,
          ),
        ),
      ],
    );
    //     final Widget side = _VersionCard(versions: versions);
    //     return LayoutBuilder(
    //       builder: (context, constraints) {
    //         if (constraints.maxWidth < _twoColumnBreakpoint) {
    //           return Column(
    //             crossAxisAlignment: CrossAxisAlignment.stretch,
    //             children: [main, const SizedBox(height: 16), side],
    //           );
    //         }
    //         return Row(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Expanded(flex: 7, child: main),
    //             const SizedBox(width: 16),
    //             Expanded(flex: 4, child: side),
    //           ],
    //         );
    //       },
    //     );
    return main;
  }
}

class _FieldPair extends StatelessWidget {
  const _FieldPair({required this.first, required this.second});

  static const double _stackBreakpoint = 520;

  final Widget first;
  final Widget second;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < _stackBreakpoint) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [first, const SizedBox(height: 16), second],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: first),
            const SizedBox(width: 16),
            Expanded(child: second),
          ],
        );
      },
    );
  }
}

class _GeneralCard extends StatefulWidget {
  const _GeneralCard({
    required this.settings,
    required this.errors,
    required this.onEdit,
  });

  final PlatformSettings settings;
  final PlatformErrors errors;
  final PlatformEdit onEdit;

  @override
  State<_GeneralCard> createState() => _GeneralCardState();
}

class _GeneralCardState extends State<_GeneralCard> {
  late final TextEditingController _name = TextEditingController(
    text: widget.settings.platformName,
  );
  late final TextEditingController _email = TextEditingController(
    text: widget.settings.supportEmail,
  );
  late final TextEditingController _phone = TextEditingController(
    text: widget.settings.supportPhone,
  );

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PlatformErrors errors = widget.errors;
    final PlatformEdit onEdit = widget.onEdit;
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(SettingsStrings.general, style: AppTextStyles.cardTitle),
          const SizedBox(height: 16),
          _FieldPair(
            first: AppTextField(
              label: SettingsStrings.platformName,
              controller: _name,
              errorText: errors.platformName,
              textInputAction: TextInputAction.next,
              onChanged: (value) =>
                  onEdit((s) => s.copyWith(platformName: value)),
            ),
            second: const AppLabeledField(
              label: SettingsStrings.logo,
              child: Row(
                children: [
                  AppBrandLogo(showText: false, size: 36),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      SettingsStrings.logoNote,
                      style: AppTextStyles.meta,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _FieldPair(
            first: AppTextField(
              label: SettingsStrings.supportEmail,
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              errorText: errors.supportEmail,
              textInputAction: TextInputAction.next,
              onChanged: (value) =>
                  onEdit((s) => s.copyWith(supportEmail: value)),
            ),
            second: AppTextField(
              label: SettingsStrings.supportPhone,
              controller: _phone,
              keyboardType: TextInputType.phone,
              errorText: errors.supportPhone,
              onChanged: (value) =>
                  onEdit((s) => s.copyWith(supportPhone: value)),
            ),
          ),
        ],
      ),
    );
  }
}

// class _ConfigurationCard extends StatelessWidget {
//   const _ConfigurationCard({required this.settings, required this.onEdit});
//
//   final PlatformSettings settings;
//   final PlatformEdit onEdit;
//
//   @override
//   Widget build(BuildContext context) {
//     return AppCard(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           const Text(
//             SettingsStrings.subscriptionConfig,
//             style: AppTextStyles.cardTitle,
//           ),
//           const SizedBox(height: 16),
//           _FieldPair(
//             first: AppLabeledField(
//               label: SettingsStrings.expiringWindow,
//               child: AppDropdown<int>(
//                 value: settings.expiringWindowDays,
//                 items: PlatformSettings.expiringWindowOptions,
//                 labelOf: SettingsStrings.daysBeforeExpiry,
//                 onChanged: (days) =>
//                     onEdit((s) => s.copyWith(expiringWindowDays: days)),
//                 isExpanded: true,
//               ),
//             ),
//             second: AppLabeledField(
//               label: SettingsStrings.sessionTimeout,
//               child: AppDropdown<int>(
//                 value: settings.sessionTimeoutMinutes,
//                 items: PlatformSettings.sessionTimeoutOptions,
//                 labelOf: SettingsStrings.minutes,
//                 onChanged: (minutes) =>
//                     onEdit((s) => s.copyWith(sessionTimeoutMinutes: minutes)),
//                 isExpanded: true,
//               ),
//             ),
//           ),
//           const SizedBox(height: 18),
//           AppToggleRow(
//             title: SettingsStrings.expiryReminders,
//             subtitle: SettingsStrings.expiryRemindersNote,
//             value: settings.sendExpiryReminders,
//             onChanged: (value) =>
//                 onEdit((s) => s.copyWith(sendExpiryReminders: value)),
//           ),
//           const SizedBox(height: 14),
//           AppToggleRow(
//             title: SettingsStrings.onePerOwner,
//             subtitle: SettingsStrings.onePerOwnerNote,
//             value: settings.oneNotificationPerOwner,
//             onChanged: (value) =>
//                 onEdit((s) => s.copyWith(oneNotificationPerOwner: value)),
//           ),
//           const SizedBox(height: 14),
//           AppToggleRow(
//             title: SettingsStrings.requireTwoStep,
//             subtitle: SettingsStrings.requireTwoStepNote,
//             value: settings.requireTwoStep,
//             onChanged: (value) =>
//                 onEdit((s) => s.copyWith(requireTwoStep: value)),
//           ),
//           const SizedBox(height: 14),
//           const AppToggleRow(
//             title: SettingsStrings.returnsAfterExpiry,
//             subtitle: SettingsStrings.returnsAfterExpiryNote,
//             value: false,
//             onChanged: null,
//             trailing: AppStatusPill(
//               label: SettingsStrings.needsApproval,
//               color: AppColors.pillAmberText,
//               backgroundColor: AppColors.pillAmberBackground,
//               showDot: false,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _VersionCard extends StatelessWidget {
//   const _VersionCard({required this.versions});
//
//   final AppVersionInfo versions;
//
//   @override
//   Widget build(BuildContext context) {
//     final List<(String, String)> rows = [
//       (SettingsStrings.ownerAndroid, versions.ownerAndroid),
//       (SettingsStrings.ownerIos, versions.ownerIos),
//       (SettingsStrings.minimumSupported, versions.minimumSupported),
//       (SettingsStrings.adminWeb, versions.adminWeb),
//     ];
//     return AppCard(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           const Text(
//             SettingsStrings.appVersionInfo,
//             style: AppTextStyles.cardTitle,
//           ),
//           const SizedBox(height: 10),
//           for (final (String label, String value) in rows)
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 5),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Flexible(child: Text(label, style: AppTextStyles.bodySmall)),
//                   const SizedBox(width: 12),
//                   Flexible(
//                     child: Text(
//                       value,
//                       style: AppTextStyles.titleSmall,
//                       textAlign: TextAlign.end,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           const SizedBox(height: 8),
//           const Text(SettingsStrings.sampleVersions, style: AppTextStyles.meta),
//         ],
//       ),
//     );
//   }
// }
