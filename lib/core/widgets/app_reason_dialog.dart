import 'package:flutter/material.dart';

import '../resources/strings/app_strings.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'app_dialog_frame.dart';
import 'app_notice_banner.dart';
import 'app_primary_button.dart';
import 'app_secondary_button.dart';
import 'app_text_field.dart';

class AppReasonDialog extends StatefulWidget {
  const AppReasonDialog({
    super.key,
    required this.title,
    required this.message,
    required this.reasonLabel,
    required this.reasonHint,
    required this.reasonRequiredError,
    required this.confirmLabel,
    this.notice,
    this.isDestructive = true,
  });

  final String title;
  final String message;
  final String reasonLabel;
  final String reasonHint;
  final String reasonRequiredError;
  final String confirmLabel;
  final String? notice;
  final bool isDestructive;

  static Future<String?> show(
    BuildContext context, {
    required String title,
    required String message,
    required String reasonLabel,
    required String reasonHint,
    required String reasonRequiredError,
    required String confirmLabel,
    String? notice,
    bool isDestructive = true,
  }) {
    return showDialog<String>(
      context: context,
      barrierColor: AppColors.scrim,
      builder: (_) => AppReasonDialog(
        title: title,
        message: message,
        reasonLabel: reasonLabel,
        reasonHint: reasonHint,
        reasonRequiredError: reasonRequiredError,
        confirmLabel: confirmLabel,
        notice: notice,
        isDestructive: isDestructive,
      ),
    );
  }

  @override
  State<AppReasonDialog> createState() => _AppReasonDialogState();
}

class _AppReasonDialogState extends State<AppReasonDialog> {
  final TextEditingController _reasonController = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _confirm() {
    final String reason = _reasonController.text.trim();
    if (reason.isEmpty) {
      setState(() => _error = widget.reasonRequiredError);
      return;
    }
    Navigator.of(context).pop(reason);
  }

  @override
  Widget build(BuildContext context) {
    final NavigatorState navigator = Navigator.of(context);
    return AppDialogFrame(
      title: widget.title,
      onClose: navigator.pop,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(widget.message, style: AppTextStyles.bodySmall),
          if (widget.notice case final String notice) ...[
            const SizedBox(height: 16),
            AppNoticeBanner(
              tone: AppNoticeTone.info,
              icon: Icons.warning_amber_rounded,
              message: notice,
            ),
          ],
          const SizedBox(height: 16),
          AppTextField(
            label: widget.reasonLabel,
            hintText: widget.reasonHint,
            controller: _reasonController,
            errorText: _error,
            minLines: 3,
            maxLines: 5,
            keyboardType: TextInputType.multiline,
            onChanged: (_) {
              if (_error != null) setState(() => _error = null);
            },
          ),
        ],
      ),
      actions: [
        AppSecondaryButton(label: AppStrings.cancel, onPressed: navigator.pop),
        AppPrimaryButton(
          label: widget.confirmLabel,
          isCompact: true,
          isDestructive: widget.isDestructive,
          onPressed: _confirm,
        ),
      ],
    );
  }
}
