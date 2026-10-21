import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/extensions/theme_context_extension.dart';

/// The Ventus brand mark: a "V" whose right arm curls like a gust of wind.
///
/// One stroke, so it reads as a single shape at any size. The path and the
/// placement transform are shared with the app-icon and splash artwork in
/// `assets/branding/`, so every surface shows exactly the same mark.
class VentusMark extends StatelessWidget {
  const VentusMark({
    super.key,
    this.size = 36,
    this.tile = true,
    this.color,
    this.glyph = const Color(0xFFFFFFFF),
    this.radius,
  });

  final double size;

  /// Draw a rounded background tile behind the V.
  final bool tile;

  /// Tile colour when [tile] is true, otherwise the colour of the V itself.
  /// Defaults to the theme primary so the mark follows the brand colour.
  final Color? color;

  /// Colour of the V when drawn on a tile.
  final Color glyph;
  final double? radius;

  /// The V's centreline, in a 100×100 box.
  static const _path = 'M22 24 L46 80 L68 32 C74 18 62 10 55 20';

  @override
  Widget build(BuildContext context) {
    final base = color ?? context.colors.primary;
    final stroke = _hex(tile ? glyph : base);
    final rx = (radius ?? size * 0.28) * 100 / size;

    // The path's bounding box is centred on (45.85, 47.75), so this transform
    // centres it in the box and scales it to ~54% of the height.
    final svg =
        '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">'
        '${tile ? '<rect width="100" height="100" rx="$rx" fill="${_hex(base)}"/>' : ''}'
        '<g transform="translate(50 50) scale(0.7) translate(-45.85 -47.75)">'
        '<path d="$_path" fill="none" stroke="$stroke" stroke-width="13" '
        'stroke-linecap="round" stroke-linejoin="round"/>'
        '</g></svg>';

    return SvgPicture.string(svg, width: size, height: size);
  }

  static String _hex(Color c) {
    final argb = c.toARGB32();
    return '#${(argb & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';
  }
}

enum VentusLogoVariant { full, mark, wordmark }

/// Brand lockup: mark + lowercase "ventus" wordmark in the display face.
class VentusLogo extends StatelessWidget {
  const VentusLogo({
    super.key,
    this.variant = VentusLogoVariant.full,
    this.size = 28,
    this.color,
    this.mark,
  });

  final VentusLogoVariant variant;
  final double size;

  /// Wordmark color; defaults to the theme ink.
  final Color? color;

  /// Mark tile color; defaults to the theme primary.
  final Color? mark;

  @override
  Widget build(BuildContext context) {
    final wordColor = color ?? context.colors.ink;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (variant != VentusLogoVariant.wordmark)
          VentusMark(size: size * 1.28, color: mark),
        if (variant == VentusLogoVariant.full) SizedBox(width: size * 0.34),
        if (variant != VentusLogoVariant.mark)
          Text(
            'ventus',
            style: context.typography.display.copyWith(
              fontSize: size * 1.1,
              height: 1,
              fontWeight: FontWeight.w700,
              letterSpacing: size * -0.04,
              color: wordColor,
            ),
          ),
      ],
    );
  }
}
