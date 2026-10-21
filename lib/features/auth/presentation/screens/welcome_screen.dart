import '../../../../core/theme/app_sizes.dart';
import 'dart:ui';
import '../../../../core/theme/app_overlay.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/theme_context_extension.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/storage/app_storage.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/theme/app_typography.dart';

/// Welcome · variant A (photo-forward), from the prototype `Auth.jsx`.
///
/// A full-bleed hero photo with a darkening gradient, the wordmark, an
/// editorial headline and the two entry actions.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Brand hero from the public-assets bucket; null offline/dev → the gradient
    // below shows on its own.
    final hero = AppStorage.publicUrl(
      StorageBuckets.publicAssets,
      'welcome.jpg',
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Fallback gradient behind the photo (and while it loads / fails).
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [context.colors.sea, context.colors.primary],
                ),
              ),
            ),
            if (hero != null) RetryNetworkImage(url: hero, fit: BoxFit.cover),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0, 0.32, 0.64, 1],
                  colors: [
                    Color(0x471F1B18),
                    Color(0x001F1B18),
                    Color(0x731F1B18),
                    Color(0xD11F1B18),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(26, 12, 26, 38),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const VentusLogo(
                      size: 22,
                      color: Color(0xFFFFFFFF),
                      // Mark left null → defaults to the theme primary.
                    ),
                    const Spacer(),
                    _Headline(),
                    const SizedBox(height: 22),
                    VentusButton(
                      label: context.l10n.getStarted,
                      iconRight: VentusIcons.arrowRight,
                      full: true,
                      // push (not go) so the form screens keep a back stack.
                      onPressed: () => context.push(AppRoutes.createAccount),
                    ),
                    const SizedBox(height: 12),
                    _GlassButton(
                      label: context.l10n.haveAccount,
                      onTap: () => context.push(AppRoutes.signIn),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Headline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final type = context.typography;
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.welcomeTagline,
          style: type.eyebrow.copyWith(
            fontSize: AppFontSize.caption,
            fontWeight: FontWeight.w700,
            letterSpacing: 12 * 0.14,
            color: AppOverlay.onPhotoMuted,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.welcomeHeadline,
          style: type.display.copyWith(
            fontSize: AppFontSize.display,
            height: 42 / 38,
            letterSpacing: 38 * -0.03,
            color: const Color(0xFFFFFFFF),
          ),
        ),
        const SizedBox(height: 14),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Text(
            l10n.welcomeSubtitle,
            style: type.body.copyWith(
              height: 23 / 16,
              color: AppOverlay.onPhotoMuted,
            ),
          ),
        ),
      ],
    );
  }
}

/// Translucent, blurred "glass" secondary button unique to the welcome screen.
class _GlassButton extends StatelessWidget {
  const _GlassButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VentusTap(
      onTap: onTap,
      semanticLabel: label,
      child: ClipRRect(
        borderRadius: AppRadius.brFull,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Container(
            // Same height and pill shape as the primary CTA above it, so the
            // two read as one pair. Frosted fill only, no outline.
            height: AppSizes.controlMd,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppOverlay.glassFill,
              borderRadius: AppRadius.brFull,
            ),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: AppFontSize.body,
                fontWeight: FontWeight.w600,
                color: Color(0xFFFFFFFF),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
