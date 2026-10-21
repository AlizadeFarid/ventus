import 'package:flutter/material.dart';

import '../../core/extensions/theme_context_extension.dart';
import '../../core/l10n/l10n_extension.dart';
import '../../core/theme/app_radius.dart';
import 'ventus_icon.dart';
import 'ventus_tap.dart';

/// The four primary destinations in the bottom bar. The raised center "+"
/// (new trip) is a separate action, not a destination.
enum VentusTab { home, trips, tools, profile }

/// Bottom tab bar with a raised center action (prototype `BottomNav.jsx`).
class VentusBottomNav extends StatelessWidget {
  const VentusBottomNav({
    super.key,
    required this.active,
    required this.onSelect,
    this.onAdd,
  });

  final VentusTab active;
  final ValueChanged<VentusTab> onSelect;
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    // A floating pill rather than an edge-to-edge bar: the page background
    // shows around it and the shadow, not a divider, separates it from content.
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.only(bottom: 8),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 6, 16, 0),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: AppRadius.brXl,
          boxShadow: context.shadows.pop,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _Tab(
              icon: VentusIcons.home,
              label: l10n.navHome,
              active: active == VentusTab.home,
              onTap: () => onSelect(VentusTab.home),
            ),
            _Tab(
              icon: VentusIcons.briefcase,
              label: l10n.navTrips,
              active: active == VentusTab.trips,
              onTap: () => onSelect(VentusTab.trips),
            ),
            _AddButton(onTap: onAdd),
            _Tab(
              icon: VentusIcons.grid,
              label: l10n.navTools,
              active: active == VentusTab.tools,
              onTap: () => onSelect(VentusTab.tools),
            ),
            _Tab(
              icon: VentusIcons.user,
              label: l10n.navProfile,
              active: active == VentusTab.profile,
              onTap: () => onSelect(VentusTab.profile),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    // Active: the darkest ink (higher contrast than the muted idle tone, which
    // coral is not), a heavier stroke, and a small coral dot underneath — so
    // the cue survives without a background disc and never competes with the
    // centre "+".
    final color = active ? colors.ink : colors.muted;

    // Icons only, equal widths: the bar stays balanced around the centre "+".
    // The label is kept for screen readers.
    return Expanded(
      child: VentusTap(
        onTap: onTap,
        semanticLabel: label,
        excludeChildSemantics: true,
        child: SizedBox(
          height: 48,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              VentusIcon(icon, size: 24, color: color, filled: active),
              const SizedBox(height: 5),
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                width: active ? 5 : 0,
                height: active ? 5 : 0,
                decoration: BoxDecoration(
                  color: context.primaryFill,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return VentusTap(
      onTap: onTap,
      semanticLabel: context.l10n.createSheetTitle,
      child: Container(
        // A circle like the active tab's disc, a touch larger, so the two read
        // as one family while the fill and glow keep this the primary action.
        width: 52,
        height: 52,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: context.primaryFill,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: context.primaryFill.withValues(alpha: 0.32),
              offset: const Offset(0, 5),
              blurRadius: 14,
            ),
          ],
        ),
        child: VentusIcon(
          VentusIcons.plus,
          size: 24,
          stroke: 2.4,
          color: colors.onPrimary,
        ),
      ),
    );
  }
}
