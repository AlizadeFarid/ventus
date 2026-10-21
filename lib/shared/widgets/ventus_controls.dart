import 'package:flutter/material.dart';

import '../../core/extensions/theme_context_extension.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import 'ventus_icon.dart';
import 'ventus_tap.dart';
import '../../core/theme/app_typography.dart';

/// Pill-shaped selectable chip (prototype `Controls.jsx` → Chip).
class VentusChip extends StatelessWidget {
  const VentusChip({
    super.key,
    required this.label,
    this.icon,
    this.active = false,
    this.onTap,
  });

  final String label;
  final String? icon;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fg = active ? colors.onPrimary : colors.ink2;

    return VentusTap(
      onTap: onTap,
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
        decoration: BoxDecoration(
          color: active ? colors.primary : colors.surfaceSand,
          borderRadius: AppRadius.brFull,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              VentusIcon(icon!, size: 16, color: fg),
              const SizedBox(width: 7),
            ],
            Text(
              label,
              style: context.typography.sm.copyWith(
                fontWeight: FontWeight.w600,
                color: fg,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum VentusBadgeTone { neutral, primary, sea, success, amber }

/// Small status pill (prototype `Controls.jsx` → Badge).
class VentusBadge extends StatelessWidget {
  const VentusBadge({
    super.key,
    required this.label,
    this.tone = VentusBadgeTone.neutral,
  });

  final String label;
  final VentusBadgeTone tone;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (bg, fg) = switch (tone) {
      VentusBadgeTone.neutral => (colors.surfaceSand, colors.ink2),
      VentusBadgeTone.primary => (colors.primarySoft, colors.primary),
      VentusBadgeTone.sea => (colors.seaSoft, colors.sea),
      VentusBadgeTone.success => (colors.successSoft, colors.success),
      VentusBadgeTone.amber => (colors.amberSoft, colors.amber),
    };

    // No `alignment` here: a Container with alignment expands to fill bounded
    // constraints (e.g. inside a Wrap/Column), which would stretch the pill to
    // full width. Padding alone keeps the width intrinsic to the label.
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: bg, borderRadius: AppRadius.brFull),
      child: Text(
        label,
        style: context.typography.caption.copyWith(
          fontSize: AppFontSize.caption,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.12,
          color: fg,
        ),
      ),
    );
  }
}

/// Labeled checkbox (prototype `Controls.jsx` → Checkbox).
class VentusCheckbox extends StatelessWidget {
  const VentusCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.labelWidget,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;

  /// Rich label (e.g. with tappable links). Takes precedence over [label].
  final Widget? labelWidget;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return VentusTap(
      onTap: onChanged == null ? null : () => onChanged!(!value),
      // The box animates its own tick — a scale on top would read as two
      // responses to one tap.
      feedback: VentusTapFeedback.none,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 22,
            height: 22,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: value ? colors.primary : colors.surfaceSand,
              borderRadius: BorderRadius.circular(7),
            ),
            child: value
                ? VentusIcon(
                    VentusIcons.check,
                    size: 15,
                    color: colors.onPrimary,
                  )
                : null,
          ),
          if (labelWidget != null) ...[
            const SizedBox(width: AppSpacing.s2),
            Flexible(child: labelWidget!),
          ] else if (label != null) ...[
            const SizedBox(width: AppSpacing.s2),
            Flexible(
              child: Text(
                label!,
                style: context.typography.sm.copyWith(color: colors.ink2),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// On/off switch (prototype `Controls.jsx` → Toggle).
class VentusToggle extends StatelessWidget {
  const VentusToggle({super.key, required this.value, this.onChanged});

  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return VentusTap(
      onTap: onChanged == null ? null : () => onChanged!(!value),
      // The knob slides; that is the feedback.
      feedback: VentusTapFeedback.none,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 48,
        height: 28,
        padding: const EdgeInsets.all(3),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        decoration: BoxDecoration(
          color: value ? colors.primary : colors.lineStrong,
          borderRadius: AppRadius.brFull,
        ),
        child: Container(
          width: 22,
          height: 22,
          decoration: const BoxDecoration(
            color: Color(0xFFFFFFFF),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color(0x33000000),
                offset: Offset(0, 1),
                blurRadius: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A single segmented-control option.
typedef VentusSegment<T> = ({T value, String label});

/// Segmented control (prototype `Controls.jsx` → SegmentedControl).
class VentusSegmentedControl<T> extends StatelessWidget {
  const VentusSegmentedControl({
    super.key,
    required this.segments,
    required this.value,
    required this.onChanged,
  });

  final List<VentusSegment<T>> segments;
  final T value;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final shadows = context.shadows;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.surfaceSand,
        borderRadius: AppRadius.brMd,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final segment in segments)
            VentusTap(
              onTap: () => onChanged(segment.value),
              // The selected pill slides between segments on its own.
              feedback: VentusTapFeedback.none,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s4,
                  vertical: AppSpacing.s2,
                ),
                decoration: BoxDecoration(
                  color: segment.value == value
                      ? colors.surface
                      : Colors.transparent,
                  borderRadius: AppRadius.brSm,
                  boxShadow: segment.value == value ? shadows.sm : null,
                ),
                child: Text(
                  segment.label,
                  style: context.typography.sm.copyWith(
                    fontWeight: FontWeight.w600,
                    color: segment.value == value ? colors.ink : colors.muted,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Horizontal rule with an optional centered label (prototype → Divider).
class VentusDivider extends StatelessWidget {
  const VentusDivider({super.key, this.label});

  final String? label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final line = Expanded(child: Container(height: 1, color: colors.line));

    if (label == null) return line;

    return Row(
      children: [
        line,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            label!,
            style: context.typography.caption.copyWith(
              fontWeight: FontWeight.w500,
              color: colors.muted,
            ),
          ),
        ),
        line,
      ],
    );
  }
}
