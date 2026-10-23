import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/env.dart';
import 'core/l10n/locale_provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_mode_provider.dart';
import 'l10n/app_localizations.dart';
import 'shared/widgets/splash_gate.dart';

/// Root widget of the Ventus app.
///
/// Wires together the design system ([AppTheme]) and declarative navigation
/// ([appRouter]). Theme is driven by the system light/dark setting for now;
/// a user-controlled override can be added later via a Riverpod provider.
class VentusApp extends ConsumerWidget {
  const VentusApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    // In debug, if Supabase isn't configured the app silently uses the
    // in-memory fake auth. Surface that loudly so it's never mistaken for the
    // real backend (e.g. duplicate-email checks won't apply).
    final showFakeBanner = kDebugMode && !Env.isConfigured;

    return MaterialApp.router(
      title: 'Ventus',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routerConfig: router,
      builder: (context, child) {
        // Honour the OS text-size setting, but bound it.
        //
        // The design uses fixed type sizes and a few fixed-height controls, so
        // an unbounded scale (iOS accessibility sizes go past 3x) clipped
        // labels and overflowed rows. Clamping to 1.3 keeps large-text users
        // supported — which is the setting almost all of them actually use —
        // without shipping a layout that visibly breaks at the extremes. The
        // 0.85 floor stops the UI shrinking to the point of being unreadable.
        Widget content = MediaQuery.withClampedTextScaling(
          minScaleFactor: 0.85,
          maxScaleFactor: 1.3,
          child: child ?? const SizedBox(),
        );
        // Tapping anywhere that isn't a control closes the keyboard — on every
        // screen and sheet, instead of each one wiring its own backdrop.
        content = GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: content,
        );
        // Status-bar icons follow the theme: dark glyphs on the light canvas,
        // light glyphs on the dark one. Without this the style set by the
        // photo-backed Welcome screen (white icons) stuck around after
        // leaving it, leaving the clock invisible on every light screen.
        // Screens with a photo behind the status bar (Welcome) still set their
        // own region, and the nearest one wins.
        final isDark = Theme.of(context).brightness == Brightness.dark;
        content = AnnotatedRegion<SystemUiOverlayStyle>(
          value:
              (isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark)
                  .copyWith(statusBarColor: Colors.transparent),
          child: content,
        );
        if (showFakeBanner) {
          content = Banner(
            message: 'FAKE AUTH',
            location: BannerLocation.topStart,
            color: const Color(0xFFC0492F),
            child: content,
          );
        }
        return SplashGate(child: content);
      },
    );
  }
}
