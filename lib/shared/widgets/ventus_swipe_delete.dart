import 'package:flutter/material.dart';

import '../../core/extensions/theme_context_extension.dart';
import 'ventus_icon.dart';

/// Red panel with a trash glyph revealed behind a row swiped left in a
/// [Dismissible]. Pass the row's [borderRadius] when the row is a rounded card.
class VentusSwipeDeleteBackground extends StatelessWidget {
  const VentusSwipeDeleteBackground({super.key, this.borderRadius});

  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final panel = Container(
      alignment: borderRadius == null
          ? Alignment.centerRight
          : Alignment.center,
      padding: borderRadius == null
          ? const EdgeInsets.only(right: 24)
          : EdgeInsets.zero,
      decoration: BoxDecoration(
        color: context.colors.danger,
        borderRadius: borderRadius,
      ),
      child: const VentusIcon(VentusIcons.trash, size: 22, color: Colors.white),
    );
    // A rounded card slides over a full-width red slab, so the slab's corners
    // peek out as hard wedges around the card's curves. Give rounded rows a
    // compact, fully rounded tile pinned to the end instead: it reads as its
    // own button revealed behind the card.
    if (borderRadius == null) return panel;
    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(width: 84, height: double.infinity, child: panel),
    );
  }
}
