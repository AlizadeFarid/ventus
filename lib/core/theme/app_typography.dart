import 'package:flutter/material.dart';

/// Typographic scale for the design system, mirroring `tokens.css`.
///
/// CSS `em` letter-spacing is converted to Flutter's absolute logical pixels
/// (`fontSize * em`), and CSS line-height (px) is converted to Flutter's
/// `height` multiplier (`lineHeightPx / fontSize`). Colors are intentionally
/// left unset so text inherits the active theme's ink color (light/dark) via
/// the surrounding [DefaultTextStyle] / [TextTheme].
///
/// Typography is theme-invariant (identical in light and dark), so a single
/// [standard] instance is reused for both.
/// The only font sizes the app uses. Call sites reference these (or a
/// [AppTypography] style) — never a numeric literal.
abstract final class AppFontSize {
  static const double hero = 48;
  static const double display = 34;
  static const double h1 = 28;
  static const double h2 = 22;
  static const double h3 = 18;
  static const double body = 16;
  static const double sm = 14;
  static const double caption = 12;
  static const double eyebrow = 11;
}

@immutable
class AppTypography extends ThemeExtension<AppTypography> {
  const AppTypography({
    required this.display,
    required this.h1,
    required this.h2,
    required this.h3,
    required this.body,
    required this.sm,
    required this.caption,
    required this.eyebrow,
  });

  final TextStyle display;
  final TextStyle h1;
  final TextStyle h2;
  final TextStyle h3;
  final TextStyle body;
  final TextStyle sm;
  final TextStyle caption;

  /// All-caps, wide-tracked label (rendered uppercase by callers).
  final TextStyle eyebrow;

  /// Body/UI face. Bundled as a variable TTF under `assets/fonts` (declared in
  /// pubspec.yaml), so it is available on the very first frame, offline
  /// included — `google_fonts` used to fetch it over the network on first use,
  /// which meant the first launch rendered in the platform fallback and then
  /// re-flowed once the download landed.
  static const _body = 'Plus Jakarta Sans';

  /// Headings use the same family as body text: one voice, and Bricolage
  /// Grotesque had no `ə`/`Ə` glyph, so Azerbaijani headings fell back to the
  /// system font mid-word.
  static const _display = _body;

  /// Builds a style on one of the bundled families.
  ///
  /// Both faces ship as per-weight static files (see pubspec.yaml), so a plain
  /// `fontWeight` — including one applied later via `copyWith`, or a bare
  /// `TextStyle(fontWeight: ...)` deeper in the tree — resolves to the real cut
  /// of the typeface rather than a synthesised bold.
  static TextStyle _style({
    required String family,
    required double fontSize,
    required double height,
    required FontWeight weight,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontFamily: family,
      fontSize: fontSize,
      height: height,
      fontWeight: weight,
      letterSpacing: letterSpacing,
    );
  }

  static final AppTypography standard = AppTypography(
    display: _style(
      family: _display,
      fontSize: AppFontSize.display,
      height: 40 / AppFontSize.display,
      weight: FontWeight.w700,
      letterSpacing: AppFontSize.display * -0.03,
    ),
    h1: _style(
      family: _display,
      fontSize: AppFontSize.h1,
      height: 35 / AppFontSize.h1,
      weight: FontWeight.w700,
      letterSpacing: AppFontSize.h1 * -0.025,
    ),
    h2: _style(
      family: _display,
      fontSize: AppFontSize.h2,
      height: 27 / AppFontSize.h2,
      weight: FontWeight.w700,
      letterSpacing: AppFontSize.h2 * -0.02,
    ),
    h3: _style(
      family: _body,
      fontSize: AppFontSize.h3,
      height: 24 / AppFontSize.h3,
      weight: FontWeight.w700,
    ),
    body: _style(
      family: _body,
      fontSize: AppFontSize.body,
      height: 24 / AppFontSize.body,
      weight: FontWeight.w400,
    ),
    sm: _style(
      family: _body,
      fontSize: AppFontSize.sm,
      height: 20 / AppFontSize.sm,
      weight: FontWeight.w400,
    ),
    caption: _style(
      family: _body,
      fontSize: AppFontSize.caption,
      height: 16 / AppFontSize.caption,
      weight: FontWeight.w400,
    ),
    eyebrow: _style(
      family: _body,
      fontSize: AppFontSize.eyebrow,
      height: 1,
      weight: FontWeight.w700,
      letterSpacing: AppFontSize.eyebrow * 0.06,
    ),
  );

  @override
  AppTypography copyWith({
    TextStyle? display,
    TextStyle? h1,
    TextStyle? h2,
    TextStyle? h3,
    TextStyle? body,
    TextStyle? sm,
    TextStyle? caption,
    TextStyle? eyebrow,
  }) {
    return AppTypography(
      display: display ?? this.display,
      h1: h1 ?? this.h1,
      h2: h2 ?? this.h2,
      h3: h3 ?? this.h3,
      body: body ?? this.body,
      sm: sm ?? this.sm,
      caption: caption ?? this.caption,
      eyebrow: eyebrow ?? this.eyebrow,
    );
  }

  @override
  AppTypography lerp(ThemeExtension<AppTypography>? other, double t) {
    if (other is! AppTypography) return this;
    return AppTypography(
      display: TextStyle.lerp(display, other.display, t)!,
      h1: TextStyle.lerp(h1, other.h1, t)!,
      h2: TextStyle.lerp(h2, other.h2, t)!,
      h3: TextStyle.lerp(h3, other.h3, t)!,
      body: TextStyle.lerp(body, other.body, t)!,
      sm: TextStyle.lerp(sm, other.sm, t)!,
      caption: TextStyle.lerp(caption, other.caption, t)!,
      eyebrow: TextStyle.lerp(eyebrow, other.eyebrow, t)!,
    );
  }
}
