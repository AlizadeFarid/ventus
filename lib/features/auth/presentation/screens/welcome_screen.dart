import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/theme_context_extension.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/storage/app_storage.dart';
import '../../../../core/theme/app_overlay.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/widgets.dart';

/// Where the bundled hero photo lives. Drop a portrait JPG here; until it
/// exists the screen falls back to the remote copy, then to the gradient.
const _heroAsset = 'assets/images/welcome.jpg';

/// Welcome · variant A (photo-forward), from the prototype `Auth.jsx`.
///
/// A full-bleed hero photo with a darkening gradient, the wordmark, an
/// editorial headline and the two entry actions.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final remoteHero = AppStorage.publicUrl(
      StorageBuckets.publicAssets,
      'welcome.jpg',
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Shown behind the photo and whenever there is no photo at all: a
            // warm ink → deep coral sweep that stays inside the palette (the
            // old teal → coral blend muddied to olive-brown in the middle).
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF3A2A24), Color(0xFF1F1B18)],
                ),
              ),
            ),
            Image.asset(
              _heroAsset,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => remoteHero == null
                  ? const SizedBox.shrink()
                  : RetryNetworkImage(url: remoteHero, fit: BoxFit.cover),
            ),
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
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screen,
                  AppSpacing.s3,
                  AppSpacing.screen,
                  AppSpacing.s8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const VentusLogo(size: 26, color: AppOverlay.onPhoto),
                    const Spacer(),
                    const _Headline(),
                    const SizedBox(height: AppSpacing.s6),
                    VentusButton(
                      label: context.l10n.getStarted,
                      iconRight: VentusIcons.arrowRight,
                      variant: VentusButtonVariant.onPhoto,
                      size: VentusButtonSize.lg,
                      full: true,
                      // push (not go) so the form screens keep a back stack.
                      onPressed: () => context.push(AppRoutes.createAccount),
                    ),
                    const SizedBox(height: AppSpacing.s3),
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
  const _Headline();

  @override
  Widget build(BuildContext context) {
    final type = context.typography;
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.welcomeTagline,
          style: type.eyebrow.copyWith(color: AppOverlay.onPhotoMuted),
        ),
        const SizedBox(height: AppSpacing.s3),
        Text(
          l10n.welcomeHeadline,
          style: type.display.copyWith(color: AppOverlay.onPhoto),
        ),
        const SizedBox(height: AppSpacing.s3),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: Text(
            l10n.welcomeSubtitle,
            style: type.body.copyWith(color: AppOverlay.onPhotoStrong),
          ),
        ),
      ],
    );
  }
}

/// Frosted secondary action. Same height and pill shape as the primary CTA
/// above it, with the label set exactly like a [VentusButton] label.
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
            height: AppSizes.controlLg,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppOverlay.glassFill,
              borderRadius: AppRadius.brFull,
            ),
            child: Text(
              label,
              style: context.typography.body.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: AppFontSize.body * -0.01,
                height: 1,
                color: AppOverlay.onPhoto,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
