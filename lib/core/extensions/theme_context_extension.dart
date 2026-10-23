import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_shadows.dart';
import '../theme/app_typography.dart';

/// Ergonomic access to the design-system [ThemeExtension]s.
///
/// Lets widgets read tokens as `context.colors.primary`,
/// `context.typography.h1`, `context.shadows.card` instead of the verbose
/// `Theme.of(context).extension<AppColors>()!`. The extensions are guaranteed
/// to be present because [AppTheme] always registers them.
extension ThemeContextX on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;

  AppTypography get typography => Theme.of(this).extension<AppTypography>()!;

  AppShadows get shadows => Theme.of(this).extension<AppShadows>()!;

  /// Fill for solid brand buttons: the deeper tone in light mode so white text
  /// reaches AA contrast, the standard primary in dark where the text is dark.
  Color get primaryFill => isDark ? colors.primary : colors.primaryPress;

  /// Convenience flag for branching on the active brightness.
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  /// Colour of the one focus treatment used by every text input: the brand
  /// fill tone, softened, so a focused field is clearly marked without a loud
  /// coral outline.
  Color get focusColor => primaryFill.withValues(alpha: 0.6);

  /// Focus treatment for input containers: a single 1px line drawn as a shadow
  /// (so, unlike a real border, it never shifts the field's contents).
  List<BoxShadow> get focusRing => [
    BoxShadow(color: focusColor, spreadRadius: 1),
  ];

  /// Same shape as [focusRing], in the error colour.
  List<BoxShadow> get errorRing => [
    BoxShadow(color: colors.danger, spreadRadius: 1),
  ];
}
