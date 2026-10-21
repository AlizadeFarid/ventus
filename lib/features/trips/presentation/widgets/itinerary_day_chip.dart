import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/theme_context_extension.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';

/// Square day selector chip (month + date, or "DAY n" when the trip is undated) used by the itinerary day strip on both the
/// full Itinerary screen and the Trip Hub preview (prototype `TripHub.jsx` →
/// DayChips). Shows a dot when the day has activities but isn't selected.
class ItineraryDayChip extends StatelessWidget {
  const ItineraryDayChip({
    super.key,
    required this.day,
    required this.active,
    required this.planned,
    required this.onTap,
    this.date,
  });

  final int day;
  final bool active;
  final bool planned;
  final VoidCallback onTap;

  /// The day's calendar date; when set the chip shows month + day number
  /// instead of "DAY n".
  final DateTime? date;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return VentusTap(
      onTap: onTap,
      child: Container(
        width: 58,
        height: 58,
        // Fill, not outline: the idle chip is sand, the active one coral.
        decoration: BoxDecoration(
          color: active ? colors.primary : colors.surfaceSand,
          borderRadius: AppRadius.brMd,
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    (date == null
                            ? context.l10n.dayLabel
                            : DateFormat.MMM(
                                context.languageCode,
                              ).format(date!))
                        .toUpperCase(),
                    style: TextStyle(
                      fontSize: AppFontSize.eyebrow,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                      color: active
                          ? colors.onPrimary.withValues(alpha: 0.85)
                          : colors.muted,
                    ),
                  ),
                  Text(
                    date == null ? '$day' : '${date!.day}',
                    style: TextStyle(
                      fontSize: AppFontSize.h3,
                      fontWeight: FontWeight.w700,
                      height: 1,
                      color: active ? colors.onPrimary : colors.ink2,
                    ),
                  ),
                ],
              ),
            ),
            if (planned && !active)
              Positioned(
                top: 7,
                right: 7,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: colors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
