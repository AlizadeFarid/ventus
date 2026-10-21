import 'package:flutter/material.dart';

/// Elevation tokens, as Flutter [BoxShadow] lists.
///
/// These carry most of the visual separation in the app: surfaces are drawn
/// without outlines, so a card is told apart from the page by its shadow
/// rather than by a hairline. That only works in light mode — on a dark
/// canvas a shadow is invisible, so there the tonal step between
/// [AppColors.bg] and [AppColors.surface] does the same job, and the dark
/// values below stay deliberately restrained.
@immutable
class AppShadows extends ThemeExtension<AppShadows> {
  const AppShadows({
    required this.sm,
    required this.card,
    required this.raised,
    required this.bar,
    required this.pop,
  });

  /// Subtle separation (secondary buttons, segmented control).
  final List<BoxShadow> sm;

  /// Resting card elevation. Deliberately quiet: most surfaces in the app are
  /// cards, so if each one shouted, nothing would stand out.
  final List<BoxShadow> card;

  /// The one-step-up elevation, for the few surfaces that should lead the
  /// page (a hero summary, the featured next step).
  final List<BoxShadow> raised;

  /// Sticky chrome pinned to the bottom (nav bar, footer action bars). Casts
  /// *upward*, so the bar reads as sitting above the scrolling content — this
  /// is what replaces the old top hairline.
  final List<BoxShadow> bar;

  /// Popovers, sheets, dialogs.
  final List<BoxShadow> pop;

  static const AppShadows light = AppShadows(
    sm: [
      BoxShadow(color: Color(0x0F1F1B18), offset: Offset(0, 2), blurRadius: 8),
      BoxShadow(color: Color(0x081F1B18), offset: Offset(0, 1), blurRadius: 2),
    ],
    // Wide, faint, offset-free — sampled from the Rhyme reference.
    card: [BoxShadow(color: Color(0x0E1F1B18), blurRadius: 16)],
    // One step above `card`: same soft, wide shape, a touch stronger and
    // nudged down.
    raised: [
      BoxShadow(color: Color(0x141F1B18), offset: Offset(0, 4), blurRadius: 24),
    ],
    bar: [
      BoxShadow(
        color: Color(0x141F1B18),
        offset: Offset(0, -6),
        blurRadius: 24,
      ),
      BoxShadow(color: Color(0x0A1F1B18), offset: Offset(0, -1), blurRadius: 3),
    ],
    pop: [
      BoxShadow(
        color: Color(0x331F1B18),
        offset: Offset(0, 24),
        blurRadius: 60,
      ),
      BoxShadow(color: Color(0x141F1B18), offset: Offset(0, 4), blurRadius: 12),
    ],
  );

  static const AppShadows dark = AppShadows(
    sm: [
      BoxShadow(color: Color(0x66000000), offset: Offset(0, 1), blurRadius: 2),
    ],
    card: [
      BoxShadow(color: Color(0x4D000000), offset: Offset(0, 4), blurRadius: 14),
      BoxShadow(color: Color(0x33000000), offset: Offset(0, 1), blurRadius: 2),
    ],
    raised: [
      BoxShadow(color: Color(0x73000000), offset: Offset(0, 8), blurRadius: 24),
      BoxShadow(color: Color(0x4D000000), offset: Offset(0, 1), blurRadius: 2),
    ],
    bar: [
      BoxShadow(
        color: Color(0x8C000000),
        offset: Offset(0, -4),
        blurRadius: 16,
      ),
    ],
    pop: [
      BoxShadow(
        color: Color(0x99000000),
        offset: Offset(0, 22),
        blurRadius: 56,
      ),
      BoxShadow(color: Color(0x66000000), offset: Offset(0, 2), blurRadius: 8),
    ],
  );

  @override
  AppShadows copyWith({
    List<BoxShadow>? sm,
    List<BoxShadow>? card,
    List<BoxShadow>? raised,
    List<BoxShadow>? bar,
    List<BoxShadow>? pop,
  }) {
    return AppShadows(
      sm: sm ?? this.sm,
      card: card ?? this.card,
      raised: raised ?? this.raised,
      bar: bar ?? this.bar,
      pop: pop ?? this.pop,
    );
  }

  @override
  AppShadows lerp(ThemeExtension<AppShadows>? other, double t) {
    if (other is! AppShadows) return this;
    return AppShadows(
      sm: BoxShadow.lerpList(sm, other.sm, t)!,
      card: BoxShadow.lerpList(card, other.card, t)!,
      raised: BoxShadow.lerpList(raised, other.raised, t)!,
      bar: BoxShadow.lerpList(bar, other.bar, t)!,
      pop: BoxShadow.lerpList(pop, other.pop, t)!,
    );
  }
}
