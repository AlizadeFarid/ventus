import 'package:flutter/material.dart';

import '../../core/theme/app_sizes.dart';
import 'package:flutter/services.dart';

import '../../core/extensions/theme_context_extension.dart';
import '../../core/theme/app_radius.dart';
import 'ventus_icon.dart';
import '../../core/theme/app_typography.dart';

/// [tonal] is a raised white button with a brand-coloured icon: a clearly
/// active action that still ranks below [primary] (e.g. the AI planner next to
/// "New trip"). A neutral grey fill on a white card reads as disabled.
enum VentusButtonVariant { primary, tonal, secondary, ghost, social, danger }

enum VentusButtonSize { lg, md, sm }

/// Primary action button, ported from the prototype `Button.jsx`.
///
/// Supports five [VentusButtonVariant]s and three [VentusButtonSize]s, optional
/// leading/trailing [VentusIcon]s, a [loading] spinner state, and the subtle
/// press-scale interaction from the design.
class VentusButton extends StatefulWidget {
  const VentusButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = VentusButtonVariant.primary,
    this.size = VentusButtonSize.md,
    this.full = false,
    this.loading = false,
    this.iconLeft,
    this.iconRight,
  });

  final String label;
  final VoidCallback? onPressed;
  final VentusButtonVariant variant;
  final VentusButtonSize size;

  /// Stretch to the full available width.
  final bool full;
  final bool loading;

  /// Icon names from [VentusIcons].
  final String? iconLeft;
  final String? iconRight;

  @override
  State<VentusButton> createState() => _VentusButtonState();
}

class _VentusButtonState extends State<VentusButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final spec = _SizeSpec.of(widget.size);
    final style = _VariantStyle.resolve(widget.variant, context);
    final isDisabled = widget.onPressed == null || widget.loading;

    final labelStyle = context.typography.body.copyWith(
      fontSize: spec.fontSize,
      fontWeight: FontWeight.w700,
      letterSpacing: spec.fontSize * -0.01,
      height: 1,
      color: style.foreground,
    );

    final child = widget.loading
        ? SizedBox(
            width: spec.iconSize,
            height: spec.iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: style.foreground,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.iconLeft != null) ...[
                VentusIcon(
                  widget.iconLeft!,
                  size: spec.iconSize,
                  color: style.iconColor ?? style.foreground,
                ),
                SizedBox(width: spec.gap),
              ],
              Flexible(
                child: Text(
                  widget.label,
                  style: labelStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (widget.iconRight != null) ...[
                SizedBox(width: spec.gap),
                VentusIcon(
                  widget.iconRight!,
                  size: spec.iconSize,
                  color: style.foreground,
                ),
              ],
            ],
          );

    return Semantics(
      button: true,
      enabled: !isDisabled,
      label: widget.label,
      child: GestureDetector(
        onTapDown: isDisabled ? null : (_) => setState(() => _pressed = true),
        onTapUp: isDisabled ? null : (_) => setState(() => _pressed = false),
        onTapCancel: isDisabled ? null : () => setState(() => _pressed = false),
        onTap: isDisabled
            ? null
            : () {
                // Primary actions get a firmer tick than quiet ones.
                widget.variant == VentusButtonVariant.primary
                    ? HapticFeedback.lightImpact()
                    : HapticFeedback.selectionClick();
                widget.onPressed?.call();
              },
        child: AnimatedScale(
          scale: _pressed ? 0.985 : 1,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          child: AnimatedOpacity(
            opacity: isDisabled ? 0.55 : 1,
            duration: const Duration(milliseconds: 150),
            child: Container(
              // A minimum rather than a fixed height, so a scaled-up label
              // grows the button instead of being clipped by it.
              constraints: BoxConstraints(minHeight: spec.height),
              width: widget.full ? double.infinity : null,
              padding: EdgeInsets.symmetric(horizontal: spec.paddingX),
              // Only center when stretched; otherwise an `alignment` would make
              // the Container expand to fill bounded constraints.
              alignment: widget.full ? Alignment.center : null,
              decoration: BoxDecoration(
                color: style.background,
                borderRadius: AppRadius.brFull,
                boxShadow: style.shadow,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class _SizeSpec {
  const _SizeSpec({
    required this.height,
    required this.paddingX,
    required this.fontSize,
    required this.gap,
    required this.iconSize,
  });

  final double height;
  final double paddingX;
  final double fontSize;
  final double gap;
  final double iconSize;

  static _SizeSpec of(VentusButtonSize size) => switch (size) {
    VentusButtonSize.lg => const _SizeSpec(
      height: AppSizes.controlLg,
      paddingX: 24,
      fontSize: AppFontSize.body,
      gap: 9,
      iconSize: 19,
    ),
    VentusButtonSize.md => const _SizeSpec(
      height: AppSizes.controlMd,
      paddingX: 20,
      fontSize: AppFontSize.body,
      gap: 8,
      iconSize: 17,
    ),
    VentusButtonSize.sm => const _SizeSpec(
      height: AppSizes.controlSm,
      paddingX: 16,
      fontSize: AppFontSize.sm,
      gap: 6,
      iconSize: 15,
    ),
  };
}

class _VariantStyle {
  const _VariantStyle({
    required this.background,
    required this.foreground,
    this.iconColor,
    this.shadow,
  });

  final Color background;
  final Color foreground;

  /// Colour of leading/trailing icons when it should differ from the label.
  final Color? iconColor;
  final List<BoxShadow>? shadow;

  static _VariantStyle resolve(
    VentusButtonVariant variant,
    BuildContext context,
  ) {
    final colors = context.colors;
    final shadows = context.shadows;
    return switch (variant) {
      VentusButtonVariant.primary => _VariantStyle(
        background: context.primaryFill,
        foreground: colors.onPrimary,
        // Standard neutral button shadow — no coloured glow.
        shadow: shadows.sm,
      ),
      // A raised white surface rather than a tinted fill: next to the solid
      // primary button a coloured fill looked like a second, muddier primary.
      // Dark mode swaps to the sand surface, since a shadow does not show there.
      VentusButtonVariant.tonal => _VariantStyle(
        background: context.isDark ? colors.surfaceSand : colors.surface,
        foreground: colors.ink,
        iconColor: colors.primary,
        shadow: const [
          BoxShadow(
            color: Color(0x1A1F1B18),
            offset: Offset(0, 4),
            blurRadius: 14,
          ),
          BoxShadow(
            color: Color(0x0F1F1B18),
            offset: Offset(0, 1),
            blurRadius: 3,
          ),
        ],
      ),
      VentusButtonVariant.secondary => _VariantStyle(
        background: colors.surfaceSand,
        foreground: colors.ink,
        shadow: shadows.sm,
      ),
      VentusButtonVariant.ghost => _VariantStyle(
        background: Colors.transparent,
        foreground: colors.ink,
      ),
      VentusButtonVariant.social => _VariantStyle(
        background: colors.surfaceSand,
        foreground: colors.ink,
        shadow: shadows.sm,
      ),
      VentusButtonVariant.danger => _VariantStyle(
        background: colors.danger,
        foreground: const Color(0xFFFFFFFF),
      ),
    };
  }
}
