import 'package:flutter/material.dart';

/// Semantic color tokens for the "Warm Coastal" design system.
///
/// Mirrors the CSS custom properties in the design prototype (`tokens.css`),
/// exposed as a [ThemeExtension] so widgets read colors via
/// `Theme.of(context).extension<AppColors>()` (or the `context.colors`
/// shortcut). Both light and dark variants are defined here.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.bg,
    required this.surface,
    required this.surfaceSand,
    required this.ink,
    required this.ink2,
    required this.muted,
    required this.line,
    required this.lineStrong,
    required this.primary,
    required this.primaryPress,
    required this.primarySoft,
    required this.onPrimary,
    required this.sea,
    required this.seaSoft,
    required this.amber,
    required this.amberSoft,
    required this.success,
    required this.successSoft,
    required this.danger,
    required this.dangerSoft,
    required this.ring,
    required this.gradientMain,
    required this.gradientHero,
  });

  /// App background (page canvas).
  final Color bg;

  /// Card / sheet surface.
  final Color surface;

  /// Tinted "sand" surface for subtle fills. Since the app dropped outlines in
  /// favour of elevation, this is also what gives borderless controls (text
  /// fields, chips, checkboxes, secondary buttons) their shape.
  final Color surfaceSand;

  /// Primary text.
  final Color ink;

  /// Secondary text.
  final Color ink2;

  /// Muted / tertiary text and inactive icons.
  final Color muted;

  /// Hairline rules. Kept for the few places a line still earns its keep (the
  /// "or" separator, rings drawn over photos); containers separate themselves
  /// with [AppShadows.card] instead.
  final Color line;

  /// Stronger rules, and the muted tone for de-emphasised glyphs.
  final Color lineStrong;

  /// Brand primary (terracotta / clay).
  final Color primary;

  /// Pressed state of [primary].
  final Color primaryPress;

  /// Tinted primary background.
  final Color primarySoft;

  /// Foreground on top of [primary].
  final Color onPrimary;

  /// Secondary brand (sea blue) — info / links.
  final Color sea;

  /// Tinted sea background.
  final Color seaSoft;

  /// Rating / star accent.
  final Color amber;

  /// Tinted amber background.
  final Color amberSoft;

  /// Positive / success.
  final Color success;

  /// Tinted success background.
  final Color successSoft;

  /// Negative / destructive.
  final Color danger;

  /// Tinted danger background.
  final Color dangerSoft;

  /// Focus ring (already includes its translucency).
  final Color ring;

  /// Primary brand gradient (photo fallbacks, subtle accents): the warm
  /// orange → coral → rose sweep also used for the app icon.
  /// CSS: `linear-gradient(160deg, #FF8A3D 0%, #F5502F 55%, #E2365B 100%)`.
  final Gradient gradientMain;

  /// Hero / feature gradient (paywall, avatars): coral → amber.
  /// CSS: `linear-gradient(150deg, #FF5A3C 0%, #FFB547 100%)`.
  final Gradient gradientHero;

  /// The "main" brand gradient, shared across themes.
  static const Gradient _gradientMain = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF8A3D), Color(0xFFF5502F), Color(0xFFE2365B)],
    stops: [0, 0.55, 1],
  );

  /// The "hero" gradient, shared across themes.
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF5A3C), Color(0xFFFFB547)],
  );

  static const AppColors light = AppColors(
    bg: Color(0xFFF7F7F7), // neutral, matches the Rhyme reference
    surface: Color(0xFFFFFFFF),
    surfaceSand: Color(0xFFEFEFEF),
    ink: Color(0xFF1F1B18),
    ink2: Color(0xFF3D3733),
    muted: Color(0xFF6B625C),
    line: Color(0xFFE8E8E8),
    lineStrong: Color(0xFFD9D9D9),
    primary: Color(0xFFF5502F),
    // The deeper brand tone: white text on it passes WCAG AA (4.69:1), which
    // the lighter [primary] does not. Fills for buttons — see
    // `BuildContext.primaryFill`.
    primaryPress: Color(0xFFD63A1A),
    primarySoft: Color(0xFFFFE9E2),
    onPrimary: Color(0xFFFFFFFF),
    sea: Color(0xFF0B7A70),
    seaSoft: Color(0xFFE3F1EF),
    amber: Color(0xFFFFB547),
    amberSoft: Color(0xFFFFF0D4),
    success: Color(0xFF16794A),
    successSoft: Color(0xFFE0F1E8),
    danger: Color(0xFFB3261E),
    dangerSoft: Color(0xFFFBE5E3),
    ring: Color(0x33F5502F), // rgba(245,80,47,0.20)
    gradientMain: _gradientMain,
    gradientHero: heroGradient,
  );

  /// Dark palette: neutral greys, the way iOS and Material build theirs. The
  /// old values leaned warm brown (red > green > blue in every surface), which
  /// read as a yellowish tint — most visible on the nav bar and cards. Depth
  /// comes from lighter surfaces stacking on a dark canvas (bg < surface <
  /// surfaceSand), not from shadows, which vanish on dark. Text is off-white
  /// rather than pure white to avoid glare; the brand coral is the only hue.
  static const AppColors dark = AppColors(
    bg: Color(0xFF121212),
    surface: Color(0xFF1E1E1E),
    surfaceSand: Color(0xFF2A2A2A),
    ink: Color(0xFFF2F2F2),
    ink2: Color(0xFFD0D0D0),
    muted: Color(0xFF9B9B9B),
    line: Color(0xFF2C2C2C),
    lineStrong: Color(0xFF444444),
    primary: Color(0xFFFF6B4A),
    primaryPress: Color(0xFFFF8466),
    // Coral at ~12% over the surface, so a tinted chip still reads as brand
    // without turning the whole card brown.
    primarySoft: Color(0xFF3A2724),
    onPrimary: Color(0xFF1A1A1A),
    sea: Color(0xFF6FC9BC),
    seaSoft: Color(0xFF1B2E2B),
    amber: Color(0xFFFFC266),
    amberSoft: Color(0x29FFC266),
    success: Color(0xFF4ADE80),
    successSoft: Color(0xFF1C2B23),
    danger: Color(0xFFFF7A70),
    dangerSoft: Color(0xFF3A1F1D),
    ring: Color(0x4DFF6B4A), // rgba(255,107,74,0.30)
    gradientMain: _gradientMain,
    gradientHero: heroGradient,
  );

  @override
  AppColors copyWith({
    Color? bg,
    Color? surface,
    Color? surfaceSand,
    Color? ink,
    Color? ink2,
    Color? muted,
    Color? line,
    Color? lineStrong,
    Color? primary,
    Color? primaryPress,
    Color? primarySoft,
    Color? onPrimary,
    Color? sea,
    Color? seaSoft,
    Color? amber,
    Color? amberSoft,
    Color? success,
    Color? successSoft,
    Color? danger,
    Color? dangerSoft,
    Color? ring,
    Gradient? gradientMain,
    Gradient? gradientHero,
  }) {
    return AppColors(
      bg: bg ?? this.bg,
      surface: surface ?? this.surface,
      surfaceSand: surfaceSand ?? this.surfaceSand,
      ink: ink ?? this.ink,
      ink2: ink2 ?? this.ink2,
      muted: muted ?? this.muted,
      line: line ?? this.line,
      lineStrong: lineStrong ?? this.lineStrong,
      primary: primary ?? this.primary,
      primaryPress: primaryPress ?? this.primaryPress,
      primarySoft: primarySoft ?? this.primarySoft,
      onPrimary: onPrimary ?? this.onPrimary,
      sea: sea ?? this.sea,
      seaSoft: seaSoft ?? this.seaSoft,
      amber: amber ?? this.amber,
      amberSoft: amberSoft ?? this.amberSoft,
      success: success ?? this.success,
      successSoft: successSoft ?? this.successSoft,
      danger: danger ?? this.danger,
      dangerSoft: dangerSoft ?? this.dangerSoft,
      ring: ring ?? this.ring,
      gradientMain: gradientMain ?? this.gradientMain,
      gradientHero: gradientHero ?? this.gradientHero,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      bg: Color.lerp(bg, other.bg, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceSand: Color.lerp(surfaceSand, other.surfaceSand, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      ink2: Color.lerp(ink2, other.ink2, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      line: Color.lerp(line, other.line, t)!,
      lineStrong: Color.lerp(lineStrong, other.lineStrong, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      primaryPress: Color.lerp(primaryPress, other.primaryPress, t)!,
      primarySoft: Color.lerp(primarySoft, other.primarySoft, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      sea: Color.lerp(sea, other.sea, t)!,
      seaSoft: Color.lerp(seaSoft, other.seaSoft, t)!,
      amber: Color.lerp(amber, other.amber, t)!,
      amberSoft: Color.lerp(amberSoft, other.amberSoft, t)!,
      success: Color.lerp(success, other.success, t)!,
      successSoft: Color.lerp(successSoft, other.successSoft, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      dangerSoft: Color.lerp(dangerSoft, other.dangerSoft, t)!,
      ring: Color.lerp(ring, other.ring, t)!,
      gradientMain: Gradient.lerp(gradientMain, other.gradientMain, t)!,
      gradientHero: Gradient.lerp(gradientHero, other.gradientHero, t)!,
    );
  }
}
