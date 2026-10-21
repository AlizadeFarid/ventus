import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_shadows.dart';
import 'app_typography.dart';

/// Central definition of the Ventus "Warm Coastal" design system.
///
/// Assembles a [ThemeData] from the design tokens: a [ColorScheme] and
/// [TextTheme] (so stock Material widgets are on-brand by default) plus the
/// custom [ThemeExtension]s ([AppColors], [AppTypography], [AppShadows]) that
/// carry the full token set. Spacing and radius are theme-invariant constants
/// (`AppSpacing`, `AppRadius`) and are used directly.
abstract final class AppTheme {
  static ThemeData light() => _build(
    brightness: Brightness.light,
    colors: AppColors.light,
    shadows: AppShadows.light,
  );

  static ThemeData dark() => _build(
    brightness: Brightness.dark,
    colors: AppColors.dark,
    shadows: AppShadows.dark,
  );

  static ThemeData _build({
    required Brightness brightness,
    required AppColors colors,
    required AppShadows shadows,
  }) {
    final typography = AppTypography.standard;

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: colors.primary,
      onPrimary: colors.onPrimary,
      primaryContainer: colors.primarySoft,
      onPrimaryContainer: colors.primary,
      secondary: colors.sea,
      onSecondary: colors.onPrimary,
      secondaryContainer: colors.seaSoft,
      onSecondaryContainer: colors.sea,
      surface: colors.surface,
      onSurface: colors.ink,
      surfaceContainerHighest: colors.surfaceSand,
      onSurfaceVariant: colors.ink2,
      outline: colors.lineStrong,
      outlineVariant: colors.line,
      error: colors.danger,
      onError: const Color(0xFFFFFFFF),
      errorContainer: colors.dangerSoft,
      onErrorContainer: colors.danger,
    );

    // Map the token type scale onto Material slots, then tint with ink so
    // default Text() widgets render in the correct light/dark color.
    final textTheme = TextTheme(
      displayLarge: typography.display,
      displayMedium: typography.display,
      headlineLarge: typography.h1,
      headlineMedium: typography.h1,
      headlineSmall: typography.h2,
      titleLarge: typography.h3,
      titleMedium: typography.h3,
      bodyLarge: typography.body,
      bodyMedium: typography.sm,
      bodySmall: typography.caption,
      labelLarge: typography.sm,
      labelMedium: typography.caption,
      labelSmall: typography.eyebrow,
    ).apply(bodyColor: colors.ink, displayColor: colors.ink);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: colors.bg,
      canvasColor: colors.bg,
      splashFactory: InkSparkle.splashFactory,
      // Android's default page transition (fade + upward slide) reads as
      // stock Material next to this design system, and differs from iOS for
      // no reason. The Cupertino slide is the one users read as "a detail
      // opened over this screen", and it comes with the interactive
      // swipe-back edge gesture — so use it on both platforms.
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      extensions: <ThemeExtension<dynamic>>[colors, typography, shadows],
      appBarTheme: AppBarTheme(
        backgroundColor: colors.bg,
        foregroundColor: colors.ink,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: typography.h3.copyWith(color: colors.ink),
      ),
      dividerTheme: DividerThemeData(
        color: colors.line,
        thickness: 1,
        space: 1,
      ),
      cardTheme: CardThemeData(
        color: colors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.brLg),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xl),
          ),
        ),
      ),
      // Toasts used to render as stock Material: a dark grey rectangle pinned
      // to the very bottom, which clashed with Warm Coastal and, on the tabbed
      // screens, sat right on top of the bottom nav. Floating + inset lifts it
      // clear of that chrome and lets it take the card shape everything else
      // uses.
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: colors.ink,
        contentTextStyle: typography.sm.copyWith(
          color: brightness == Brightness.light
              ? const Color(0xFFF6F9F8)
              : colors.bg,
          fontWeight: FontWeight.w600,
        ),
        actionTextColor: colors.primary,
        elevation: 0,
        insetPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.brMd),
        showCloseIcon: false,
      ),
      // Same story for dialogs: without this they inherited M3's default
      // container tint and 28px radius, so a confirm sheet looked like it came
      // from a different app than the screen behind it.
      dialogTheme: DialogThemeData(
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.brXl),
        insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        titleTextStyle: typography.h3.copyWith(
          fontSize: AppFontSize.h3,
          color: colors.ink,
        ),
        contentTextStyle: typography.body.copyWith(
          fontSize: AppFontSize.sm,
          color: colors.muted,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.primary,
          textStyle: typography.sm.copyWith(fontWeight: FontWeight.w700),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.brSm),
          // 44px minimum so dialog actions clear the accessible tap target.
          minimumSize: const Size(64, 44),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colors.primary,
        linearTrackColor: colors.surfaceSand,
        circularTrackColor: Colors.transparent,
      ),
    );
  }
}
