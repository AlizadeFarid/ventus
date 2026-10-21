import 'package:flutter/material.dart';

import '../../core/extensions/theme_context_extension.dart';
import '../../core/l10n/l10n_extension.dart';
import '../../core/theme/app_radius.dart';
import 'ventus_icon.dart';
import 'ventus_sheet.dart';
import 'ventus_tap.dart';
import '../../core/theme/app_typography.dart';

/// Which card the user tapped in [showCreateTripSheet]. Kept free of any
/// feature import (e.g. `CreateTripEntry`) so this stays a reusable,
/// presentation-only shared widget; callers map the choice to whatever their
/// own create-trip flow expects.
enum CreateTripChoice { ai, manual }

/// Bottom sheet shown from the [+] action: choose AI-assisted vs manual trip
/// creation (prototype state E). Returns the user's choice, or null if they
/// dismissed the sheet without picking.
Future<CreateTripChoice?> showCreateTripSheet(BuildContext context) {
  return showVentusSheet<CreateTripChoice>(
    context,
    backgroundColor: context.colors.bg,
    builder: (_) => const _CreateTripSheet(),
  );
}

class _CreateTripSheet extends StatelessWidget {
  const _CreateTripSheet();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    // The bottom safe-area inset is padding *inside* the sheet so its fill
    // reaches the screen edge instead of leaving a transparent strip.
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        12 + MediaQuery.paddingOf(context).bottom,
      ),
      decoration: BoxDecoration(
        color: colors.bg,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.xl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: colors.lineStrong,
                borderRadius: AppRadius.brFull,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.createSheetTitle,
                  style: context.typography.h1.copyWith(
                    fontSize: AppFontSize.h2,
                    color: colors.ink,
                  ),
                ),
              ),
              VentusTap(
                onTap: () => Navigator.of(context).pop(),
                semanticLabel: l10n.sheetClose,
                child: Container(
                  width: 34,
                  height: 34,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colors.surfaceSand,
                    shape: BoxShape.circle,
                  ),
                  child: VentusIcon(
                    VentusIcons.close,
                    size: 16,
                    color: colors.ink2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            l10n.createSheetSubtitle,
            style: TextStyle(fontSize: AppFontSize.sm, color: colors.muted),
          ),
          const SizedBox(height: 16),
          _ChoiceCard(
            icon: VentusIcons.sparkle,
            iconBg: colors.primarySoft,
            iconColor: colors.primary,
            title: l10n.planWithAi,
            badge: l10n.createAiBadge,
            body: l10n.createAiBody,
            highlighted: true,
            onTap: () => Navigator.of(context).pop(CreateTripChoice.ai),
          ),
          const SizedBox(height: 10),
          _ChoiceCard(
            icon: VentusIcons.route,
            iconBg: colors.surfaceSand,
            iconColor: colors.ink2,
            title: l10n.planNewTrip,
            body: l10n.createManualBody,
            onTap: () => Navigator.of(context).pop(CreateTripChoice.manual),
          ),
        ],
      ),
    );
  }
}

class _ChoiceCard extends StatelessWidget {
  const _ChoiceCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.body,
    required this.onTap,
    this.badge,
    this.highlighted = false,
  });

  final String icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String? badge;
  final String body;
  final bool highlighted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return VentusTap(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: AppRadius.brLg,
          border: Border.all(
            color: highlighted ? colors.primary : colors.line,
            width: highlighted ? 1.5 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 46,
              height: 46,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: AppRadius.brSm,
              ),
              child: VentusIcon(icon, size: 22, color: iconColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: AppFontSize.body,
                            fontWeight: FontWeight.w600,
                            color: colors.ink,
                          ),
                        ),
                      ),
                      if (badge != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: colors.amberSoft,
                            borderRadius: AppRadius.brFull,
                          ),
                          child: Text(
                            badge!,
                            style: TextStyle(
                              fontSize: AppFontSize.eyebrow,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.4,
                              color: colors.amber,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    body,
                    style: TextStyle(
                      fontSize: AppFontSize.sm,
                      height: 1.35,
                      color: colors.muted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
