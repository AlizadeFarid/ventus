import 'package:flutter/material.dart';

import '../../core/extensions/theme_context_extension.dart';
import 'ventus_icon.dart';

/// The leading icon of a row, tile or menu item: just the glyph, in the neutral
/// ink tone, in a fixed slot so every row's text starts at the same x.
///
/// This replaces the tinted rounded-square badge that used to sit behind every
/// such icon. A badge on every row, all the same colour, reads as a template;
/// a bare glyph is quieter and lets the one coral element on a screen (the
/// action, the progress) stand out. Keep a filled badge only where it carries
/// structure — empty-state heroes, timeline nodes, avatars, buttons.
class VentusLeadIcon extends StatelessWidget {
  const VentusLeadIcon(
    this.name, {
    super.key,
    this.size = 22,
    this.color,
    this.slot = 28,
    this.stroke,
  });

  /// A [VentusIcons] name.
  final String name;
  final double size;

  /// Defaults to the secondary ink; pass a colour only for meaning (danger).
  final Color? color;

  /// Width reserved for the icon.
  final double slot;
  final double? stroke;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: slot,
      child: Align(
        alignment: Alignment.centerLeft,
        child: stroke == null
            ? VentusIcon(name, size: size, color: color ?? context.colors.ink2)
            : VentusIcon(
                name,
                size: size,
                stroke: stroke!,
                color: color ?? context.colors.ink2,
              ),
      ),
    );
  }
}
