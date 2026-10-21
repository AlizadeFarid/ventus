import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/extensions/theme_context_extension.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import 'ventus_icon.dart';
import 'ventus_tap.dart';
import '../../core/l10n/l10n_extension.dart';
import '../../core/theme/app_sizes.dart';

/// Text input, ported from the prototype `Input.jsx`.
///
/// Renders an optional label, a 54px field with a leading [icon], focus ring,
/// error/helper text, and a built-in reveal toggle when [obscure] is set.
class VentusTextField extends StatefulWidget {
  const VentusTextField({
    super.key,
    this.label,
    this.controller,
    this.focusNode,
    this.hintText,
    this.icon,
    this.helper,
    this.errorText,
    this.obscure = false,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.autofillHints,
    this.inputFormatters,
  });

  final String? label;
  final TextEditingController? controller;

  /// Optional external focus node. When omitted, an internal one is used.
  final FocusNode? focusNode;
  final String? hintText;

  /// Leading icon name from [VentusIcons].
  final String? icon;
  final String? helper;
  final String? errorText;

  /// Password mode — obscures text and shows an eye/eye-off reveal toggle.
  final bool obscure;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final List<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<VentusTextField> createState() => _VentusTextFieldState();
}

class _VentusTextFieldState extends State<VentusTextField> {
  late final FocusNode _focusNode;
  late final bool _ownsFocusNode;
  bool _focused = false;
  bool _reveal = false;

  @override
  void initState() {
    super.initState();
    _ownsFocusNode = widget.focusNode == null;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() => setState(() => _focused = _focusNode.hasFocus);

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    if (_ownsFocusNode) _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.typography;
    final hasError = widget.errorText != null;

    // At rest the field is defined by its fill, not an outline. A border only
    // appears for the two states that must be unmistakable: focus and error.
    final borderColor = hasError
        ? colors.danger
        : _focused
        ? colors.primary
        : null;

    final fillColor = _focused || hasError
        ? colors.surface
        : colors.surfaceSand;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: type.sm.copyWith(
              fontWeight: FontWeight.w600,
              color: colors.ink2,
            ),
          ),
          const SizedBox(height: AppSpacing.s2),
        ],
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: AppSizes.controlLg,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: AppRadius.brMd,
            border: borderColor == null
                ? null
                : Border.all(color: borderColor, width: 1.5),
            boxShadow: _focused
                ? [
                    BoxShadow(
                      color: colors.ring,
                      blurRadius: 0,
                      spreadRadius: 3,
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              if (widget.icon != null) ...[
                VentusIcon(widget.icon!, size: 20, color: colors.muted),
                const SizedBox(width: AppSpacing.s3),
              ],
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  obscureText: widget.obscure && !_reveal,
                  keyboardType: widget.keyboardType,
                  // Single-line fields end on "Done" (closes the keyboard) unless a form
                  // asks for "Next" to walk to the following field.
                  textInputAction:
                      widget.textInputAction ?? TextInputAction.done,
                  inputFormatters: widget.inputFormatters,
                  onChanged: widget.onChanged,
                  onSubmitted: widget.onSubmitted,
                  autofillHints: widget.autofillHints,
                  cursorColor: colors.primary,
                  style: type.body.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colors.ink,
                  ),
                  decoration: InputDecoration(
                    isCollapsed: true,
                    border: InputBorder.none,
                    hintText: widget.hintText,
                    hintStyle: type.body.copyWith(color: colors.muted),
                  ),
                ),
              ),
              if (widget.obscure)
                VentusTap(
                  onTap: () => setState(() => _reveal = !_reveal),
                  semanticLabel: _reveal
                      ? context.l10n.hidePassword
                      : context.l10n.showPassword,
                  feedback: VentusTapFeedback.none,
                  padding: const EdgeInsets.fromLTRB(AppSpacing.s2, 12, 0, 12),
                  child: VentusIcon(
                    _reveal ? VentusIcons.eyeOff : VentusIcons.eye,
                    size: 20,
                    color: colors.muted,
                  ),
                ),
            ],
          ),
        ),
        if (hasError || widget.helper != null) ...[
          const SizedBox(height: 7),
          Text(
            widget.errorText ?? widget.helper!,
            style: type.caption.copyWith(
              color: hasError ? colors.danger : colors.muted,
            ),
          ),
        ],
      ],
    );
  }
}
