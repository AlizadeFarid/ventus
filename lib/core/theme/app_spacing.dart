/// 4-based spacing scale from `tokens.css`.
///
/// Theme-invariant, so exposed as plain compile-time constants rather than a
/// [ThemeExtension]. Use for padding, gaps and margins, e.g.
/// `EdgeInsets.all(AppSpacing.s4)`.
abstract final class AppSpacing {
  static const double s1 = 4;
  static const double s2 = 8;
  static const double s3 = 12;
  static const double s4 = 16;
  static const double s5 = 20;
  static const double s6 = 24;
  static const double s8 = 32;
  static const double s10 = 40;
  static const double s12 = 48;
  static const double s16 = 64;

  /// Horizontal page gutter shared by every screen.
  static const double screen = 16;
}
