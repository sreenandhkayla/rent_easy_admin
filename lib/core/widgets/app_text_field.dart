import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../resources/strings/app_strings.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.controller,
    this.initialValue,
    this.hintText,
    this.errorText,
    this.helperText,
    this.inputFormatters,
    this.maxLength,
    this.obscureText = false,
    this.readOnly = false,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.trailingLabel,
    this.onChanged,
    this.onSubmitted,
    this.minLines,
    this.maxLines = 1,
  });

  final String label;
  final TextEditingController? controller;
  final String? initialValue;
  final String? hintText;
  final String? errorText;
  final String? helperText;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final bool obscureText;
  final bool readOnly;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final Widget? trailingLabel;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final int? minLines;
  final int? maxLines;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _isObscured = widget.obscureText;
  late final TextEditingController? _ownController =
      widget.controller == null && widget.initialValue != null
      ? TextEditingController(text: widget.initialValue)
      : null;

  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _ownController?.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _toggleObscured() {
    final bool hadFocus = _focusNode.hasFocus;
    if (hadFocus) _focusNode.unfocus();
    setState(() => _isObscured = !_isObscured);
    if (!hadFocus) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: Text(widget.label, style: AppTextStyles.label)),
            ?widget.trailingLabel,
          ],
        ),
        const SizedBox(height: 10),
        TextField(
          controller: widget.controller ?? _ownController,
          focusNode: _focusNode,
          obscureText: _isObscured,
          obscuringCharacter: '•',
          readOnly: widget.readOnly,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          autofillHints: widget.obscureText && !_isObscured
              ? null
              : widget.autofillHints,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
          inputFormatters: widget.inputFormatters,
          maxLength: widget.maxLength,
          minLines: widget.minLines,
          maxLines: widget.obscureText ? 1 : widget.maxLines,
          style: AppTextStyles.input,
          decoration: InputDecoration(
            hintText: widget.hintText,
            errorText: widget.errorText,
            errorMaxLines: 3,
            helperText: widget.helperText,
            helperStyle: AppTextStyles.bodyCaption,
            helperMaxLines: 3,
            counterStyle: AppTextStyles.meta,
            suffixIcon: widget.obscureText
                ? IconButton(
                    onPressed: _toggleObscured,
                    tooltip: _isObscured
                        ? AppStrings.showPassword
                        : AppStrings.hidePassword,
                    icon: Icon(
                      _isObscured
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 18,
                      color: AppColors.textHint,
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
