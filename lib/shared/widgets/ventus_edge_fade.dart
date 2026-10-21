import 'package:flutter/material.dart';

import '../../core/extensions/theme_context_extension.dart';

/// Fades the right edge of a horizontally scrolling strip into [color] (the
/// page background by default), so a clipped item reads as "more this way"
/// instead of as truncated content.
class VentusEdgeFade extends StatelessWidget {
  const VentusEdgeFade({super.key, required this.child, this.color});

  final Widget child;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final fill = color ?? context.colors.bg;
    return Stack(
      children: [
        child,
        Positioned(
          top: 0,
          bottom: 0,
          right: 0,
          width: 32,
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [fill.withValues(alpha: 0), fill],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
