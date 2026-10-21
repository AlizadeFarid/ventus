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
}
