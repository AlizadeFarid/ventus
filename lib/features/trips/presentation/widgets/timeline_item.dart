import 'package:flutter/material.dart';

import '../../../../core/extensions/theme_context_extension.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/theme/app_typography.dart';

/// One row of an itinerary timeline (prototype `TripHub.jsx` → TimelineItem):
/// a time gutter, an icon node with a connecting line, and a card with the
/// activity title and place. Tapping opens the edit sheet (when [onTap] is set).
class TimelineItem extends StatelessWidget {
  const TimelineItem({
    super.key,
    required this.time,
    required this.icon,
    required this.title,
    this.place,
    this.last = false,
    this.onTap,
    this.onOpenMap,
  });

  /// Formatted start time (e.g. "11:40"), or null/empty when the activity has
  /// no fixed time — then [emptyTime] is shown in the gutter.
  final String? time;
  final String icon;
  final String title;
  final String? place;
  final bool last;
  final VoidCallback? onTap;

  /// When set, a small map button sits at the card's end and opens the place
  /// in a maps app. Its own tap target, so it never triggers [onTap].
  final VoidCallback? onOpenMap;

  /// Placeholder shown in the time gutter for untimed activities.
  final String emptyTime = '—';

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 46,
            child: Padding(
              padding: const EdgeInsets.only(top: 14),
              child: Text(
                (time != null && time!.isNotEmpty) ? time! : emptyTime,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: AppFontSize.sm,
                  fontWeight: FontWeight.w600,
                  color: colors.muted,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 34,
            child: Column(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  margin: const EdgeInsets.only(top: 8),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colors.primarySoft,
                    shape: BoxShape.circle,
                  ),
                  child: VentusIcon(icon, size: 17, color: colors.primary),
                ),
                if (!last)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.only(top: 4),
                      color: colors.line,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: last ? 0 : 14),
              child: VentusTap(
                onTap: onTap,
                child: Container(
                  // One minimum height for every row, so cards with and without
                  // the map button line up (32 button + 2 * 10 padding).
                  constraints: const BoxConstraints(minHeight: 52),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: AppRadius.brLg,
                    boxShadow: context.shadows.card,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                fontSize: AppFontSize.sm,
                                fontWeight: FontWeight.w600,
                                color: colors.ink,
                                letterSpacing: -0.1,
                              ),
                            ),
                            if (place != null && place!.isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  VentusIcon(
                                    VentusIcons.mapPin,
                                    size: 13,
                                    color: colors.muted,
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      place!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: AppFontSize.sm,
                                        color: colors.muted,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (onOpenMap != null) ...[
                        const SizedBox(width: 8),
                        VentusTap(
                          onTap: onOpenMap,
                          semanticLabel: context.l10n.openInMaps,
                          child: Container(
                            width: 32,
                            height: 32,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: colors.surfaceSand,
                              shape: BoxShape.circle,
                            ),
                            child: VentusIcon(
                              VentusIcons.compass,
                              size: 17,
                              color: colors.primary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
