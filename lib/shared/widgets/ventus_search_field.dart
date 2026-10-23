import 'package:flutter/material.dart';

import '../../core/extensions/theme_context_extension.dart';
import '../../core/l10n/l10n_extension.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/theme/app_spacing.dart';
import 'ventus_icon.dart';
import 'ventus_tap.dart';

/// White field with a hairline rim (drawn as a shadow, not an outline) —
/// sampled from the Rhyme reference.
const _searchRim = [BoxShadow(color: Color(0x141F1B18), spreadRadius: 1)];

/// The one search input: white fill, search glyph, clear (×) once there is
/// text. Used wherever the user types to find something (explore, destination
/// step, city / currency pickers).
class VentusSearchField extends StatefulWidget {
  const VentusSearchField({
    super.key,
    required this.controller,
    this.focusNode,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.autofocus = false,
    this.onBack,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool autofocus;

  /// When set, the leading search glyph becomes a back arrow that calls this
  /// (used by [VentusSearchLayout] to leave the search without a Cancel text).
  final VoidCallback? onBack;

  @override
  State<VentusSearchField> createState() => _VentusSearchFieldState();
}

class _VentusSearchFieldState extends State<VentusSearchField> {
  FocusNode? _ownNode;
  FocusNode get _node => widget.focusNode ?? (_ownNode ??= FocusNode());
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _node.addListener(_onFocus);
  }

  void _onFocus() => setState(() => _focused = _node.hasFocus);

  @override
  void dispose() {
    _node.removeListener(_onFocus);
    _ownNode?.dispose();
    super.dispose();
  }

  void _clear() {
    widget.controller.clear();
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = context.typography;
    // The whole bar is the tap target, not just the line of text inside it.
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _node.requestFocus,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: AppSizes.controlMd,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: AppRadius.brMd,
          boxShadow: _focused ? context.focusRing : _searchRim,
        ),
        child: Row(
          children: [
            if (widget.onBack == null)
              VentusIcon(VentusIcons.search, size: 20, color: colors.muted)
            else
              VentusTap(
                onTap: widget.onBack,
                feedback: VentusTapFeedback.none,
                semanticLabel: context.l10n.back,
                padding: const EdgeInsets.only(right: 2),
                child: VentusIcon(
                  VentusIcons.arrowLeft,
                  size: 20,
                  color: colors.ink,
                ),
              ),
            const SizedBox(width: AppSpacing.s3),
            Expanded(
              child: TextField(
                controller: widget.controller,
                focusNode: _node,
                autofocus: widget.autofocus,
                onChanged: widget.onChanged,
                onSubmitted: widget.onSubmitted,
                textInputAction: TextInputAction.search,
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
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: widget.controller,
              builder: (context, value, _) => value.text.isEmpty
                  ? const SizedBox.shrink()
                  : VentusTap(
                      onTap: _clear,
                      feedback: VentusTapFeedback.none,
                      semanticLabel: context.l10n.clear,
                      padding: const EdgeInsets.only(left: AppSpacing.s2),
                      child: VentusIcon(
                        VentusIcons.close,
                        size: 18,
                        color: colors.muted,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A [VentusSearchField] look-alike that is a button: tapping opens a search
/// sheet. Same height, radius and fill so it reads as the same control.
class VentusSearchButton extends StatelessWidget {
  const VentusSearchButton({
    super.key,
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return VentusTap(
      onTap: onTap,
      semanticLabel: label,
      child: Container(
        height: AppSizes.controlMd,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: AppRadius.brMd,
          boxShadow: _searchRim,
        ),
        child: Row(
          children: [
            VentusIcon(VentusIcons.search, size: 20, color: colors.muted),
            const SizedBox(width: AppSpacing.s3),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.typography.body.copyWith(color: colors.muted),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
