import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/theme_context_extension.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../trips/application/create_trip_controller.dart';
import '../../../trips/presentation/widgets/trip_photo.dart';
import '../../application/destinations_providers.dart';
import '../../application/saved_controller.dart';
import '../../application/saved_providers.dart';
import '../../domain/destination.dart';
import '../saved_format.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';

/// Expanded height of the collapsing hero.
const double _kHeroHeight = 300;

/// A destination's detail (prototype `Explore.jsx` → DestinationDetail): a
/// collapsing hero image, quick facts (currency / language / best time /
/// timezone), an "about" description, an Ask-Ventus planner shortcut, "good to
/// know" tips, and a "plan a trip here" action. Reached from Explore + Saved.
///
/// The hero collapses on scroll while the back / heart controls stay pinned and
/// the title fades into the bar (mirrors the trip detail hub). Sections render
/// only when the destination has data, so sparse destinations degrade
/// gracefully instead of showing empty headers.
class PlaceDetailScreen extends ConsumerStatefulWidget {
  const PlaceDetailScreen({super.key, required this.id});

  final String id;

  @override
  ConsumerState<PlaceDetailScreen> createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends ConsumerState<PlaceDetailScreen> {
  final ScrollController _scroll = ScrollController();

  /// 0 = hero fully expanded, 1 = collapsed to the toolbar. Drives the cover
  /// wipe-to-surface and the pinned title fade.
  final ValueNotifier<double> _collapse = ValueNotifier<double>(0);

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  void _onScroll() {
    final distance = _kHeroHeight - kToolbarHeight;
    _collapse.value = (_scroll.offset / distance).clamp(0.0, 1.0);
  }

  @override
  void dispose() {
    _scroll.removeListener(_onScroll);
    _scroll.dispose();
    _collapse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final items =
        ref.watch(destinationsProvider).asData?.value ?? const <Destination>[];
    Destination? d;
    for (final item in items) {
      if (item.id == widget.id) {
        d = item;
        break;
      }
    }

    if (d == null) {
      return Scaffold(
        backgroundColor: colors.bg,
        appBar: VentusAppBar(title: l10n.exploreTitle),
        body: Center(
          child: Text(l10n.exploreEmpty, style: TextStyle(color: colors.muted)),
        ),
      );
    }

    final lang = context.languageCode;
    final saved = ref.watch(savedIdsProvider).contains(d.id);
    final description = d.descriptionFor(lang);

    return Scaffold(
      backgroundColor: colors.bg,
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              controller: _scroll,
              slivers: [
                _heroAppBar(context, d, saved, lang),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Quick facts.
                      if (d.hasFacts) _FactsRow(destination: d, lang: lang),

                      // About.
                      if (description.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.screen,
                            20,
                            AppSpacing.screen,
                            0,
                          ),
                          child: _ExpandableText(text: description),
                        ),

                      // Ask Ventus → planner shortcut.
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.screen,
                          16,
                          AppSpacing.screen,
                          0,
                        ),
                        child: VentusAiPill(
                          label: l10n.destAskPlan,
                          onTap: () => _planTrip(context, ref, d!, lang),
                        ),
                      ),

                      // Good to know.
                      if (d.tips.isNotEmpty) ...[
                        VentusSectionHeader(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.screen,
                            22,
                            AppSpacing.screen,
                            12,
                          ),
                          title: l10n.destGoodToKnow,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.screen,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: colors.surface,
                              borderRadius: AppRadius.brLg,
                              boxShadow: context.shadows.card,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              children: [
                                for (var i = 0; i < d.tips.length; i++)
                                  _TipRow(
                                    tip: d.tips[i],
                                    lang: lang,
                                    last: i == d.tips.length - 1,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 18),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Action bar.
          Container(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screen,
              12,
              AppSpacing.screen,
              20,
            ),
            decoration: BoxDecoration(
              color: colors.bg,
              boxShadow: context.shadows.bar,
            ),
            child: SafeArea(
              top: false,
              child: VentusButton(
                label: l10n.planTripHere,
                full: true,
                iconLeft: VentusIcons.plus,
                onPressed: () => _planTrip(context, ref, d!, lang),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Collapsing hero: the photo + name scroll away while the back / heart
  /// controls stay pinned and the name fades into the bar.
  Widget _heroAppBar(
    BuildContext context,
    Destination d,
    bool saved,
    String lang,
  ) {
    final colors = context.colors;
    return SliverAppBar(
      pinned: true,
      expandedHeight: _kHeroHeight,
      automaticallyImplyLeading: false,
      backgroundColor: colors.bg,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 2,
      shadowColor: Colors.black26,
      centerTitle: true,
      leadingWidth: 64,
      leading: Padding(
        padding: const EdgeInsets.only(left: 18),
        child: Align(
          alignment: Alignment.centerLeft,
          child: VentusHeroIconButton(
            icon: VentusIcons.arrowLeft,
            collapse: _collapse,
            onTap: () => Navigator.of(context).maybePop(),
          ),
        ),
      ),
      title: ValueListenableBuilder<double>(
        valueListenable: _collapse,
        builder: (context, t, _) => Opacity(
          // Fade the title in only over the second half of the collapse.
          opacity: ((t - 0.5) * 2).clamp(0.0, 1.0),
          child: Text(
            d.nameFor(lang),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: AppFontSize.h3,
              fontWeight: FontWeight.w700,
              color: colors.ink,
            ),
          ),
        ),
      ),
      actions: [
        VentusHeroIconButton(
          icon: saved ? VentusIcons.heartFill : VentusIcons.heart,
          collapse: _collapse,
          activeColor: saved ? colors.primary : null,
          onTap: () => ref
              .read(savedControllerProvider.notifier)
              .toggle(savedPlaceFrom(d, lang)),
        ),
        const SizedBox(width: 18),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: _HeroBackground(
          destination: d,
          lang: lang,
          collapse: _collapse,
        ),
      ),
    );
  }

  /// Seeds the Create Trip flow with this destination as the first stop.
  void _planTrip(
    BuildContext context,
    WidgetRef ref,
    Destination d,
    String lang,
  ) {
    final controller = ref.read(createTripControllerProvider.notifier);
    controller.start(CreateTripEntry.manual);
    controller.addStop(
      DraftStop(
        name: d.nameFor(lang),
        country: d.countryFor(lang),
        imageUrl: d.imageUrl,
      ),
    );
    context.push(AppRoutes.createTrip, extra: const CreateTripSeeded());
  }
}

/// Full-bleed hero background for the collapsing app bar: gradient over the
/// photo, the destination name + country, and a wipe-to-background overlay so
/// the pinned toolbar reads cleanly once collapsed.
class _HeroBackground extends StatelessWidget {
  const _HeroBackground({
    required this.destination,
    required this.lang,
    required this.collapse,
  });

  final Destination destination;
  final String lang;
  final ValueListenable<double> collapse;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DestinationPhotoHero(
      id: destination.id,
      imageUrl: destination.imageUrl,
      child: TripPhoto(
        imageUrl: destination.imageUrl,
        child: Stack(
          children: [
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x731F1B18),
                      Color(0x001F1B18),
                      Color(0x8C1F1B18),
                    ],
                    stops: [0, 0.35, 1],
                  ),
                ),
              ),
            ),
            Positioned(
              left: AppSpacing.screen,
              right: AppSpacing.screen,
              bottom: 42,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    destination.nameFor(lang),
                    style: const TextStyle(
                      fontSize: AppFontSize.h1,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.8,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      VentusIcon(
                        VentusIcons.mapPin,
                        size: 14,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          destination.countryFor(lang),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: AppFontSize.sm,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Page-coloured sheet edge overlapping the photo, so the content
            // reads as a card rising over it instead of a hard horizontal cut.
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 24,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.bg,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppRadius.xl),
                  ),
                ),
              ),
            ),
            // Wipe to the background colour as it collapses so the pinned toolbar
            // (with the fading title) reads on a clean background.
            Positioned.fill(
              child: ValueListenableBuilder<double>(
                valueListenable: collapse,
                builder: (context, t, _) {
                  final a = ((t - 0.35) / 0.65).clamp(0.0, 1.0);
                  return IgnorePointer(
                    child: ColoredBox(color: colors.bg.withValues(alpha: a)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The currency / language / best-time / timezone card. Only present facts
/// are shown, laid out as a 2-column wrap so each cell has room for longer
/// values (e.g. a full language name) without truncating.
class _FactsRow extends StatelessWidget {
  const _FactsRow({required this.destination, required this.lang});

  final Destination destination;
  final String lang;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    final facts = <({String icon, String label, String value})>[];
    final currency = destination.currencyFor(lang);
    if (currency.isNotEmpty) {
      facts.add((
        icon: VentusIcons.wallet,
        label: l10n.factCurrency,
        value: currency,
      ));
    }
    final language = destination.languageFor(lang);
    if (language.isNotEmpty) {
      facts.add((
        icon: VentusIcons.globe,
        label: l10n.factLanguage,
        value: language,
      ));
    }
    final bestTime = destination.bestTimeFor(lang);
    if (bestTime.isNotEmpty) {
      facts.add((
        icon: VentusIcons.sun,
        label: l10n.factBestTime,
        value: bestTime,
      ));
    }
    final tz = destination.timezone;
    if (tz != null && tz.isNotEmpty) {
      facts.add((icon: VentusIcons.clock, label: l10n.factTimezone, value: tz));
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        16,
        AppSpacing.screen,
        0,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceSand,
        borderRadius: AppRadius.brLg,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          const gap = 16.0;
          final cellWidth = (constraints.maxWidth - gap) / 2;
          return Wrap(
            spacing: gap,
            runSpacing: 16,
            children: [
              for (final f in facts)
                SizedBox(
                  width: cellWidth,
                  child: _FactCell(
                    icon: f.icon,
                    value: f.value,
                    label: f.label,
                    colors: colors,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

/// One fact cell: a filled icon badge beside a left-aligned value/label pair.
class _FactCell extends StatelessWidget {
  const _FactCell({
    required this.icon,
    required this.value,
    required this.label,
    required this.colors,
  });

  final String icon;
  final String value;
  final String label;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: colors.surface,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: VentusIcon(icon, size: 16, color: colors.primary),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: AppFontSize.sm,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.1,
                  color: colors.ink,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: AppFontSize.eyebrow,
                  fontWeight: FontWeight.w600,
                  color: colors.muted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TipRow extends StatelessWidget {
  const _TipRow({required this.tip, required this.lang, required this.last});

  final DestinationTip tip;
  final String lang;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final body = tip.bodyFor(lang);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 1),
                child: VentusLeadIcon(tip.icon),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tip.titleFor(lang),
                      style: TextStyle(
                        fontSize: AppFontSize.body,
                        fontWeight: FontWeight.w600,
                        color: colors.ink,
                      ),
                    ),
                    if (body.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        body,
                        style: TextStyle(
                          fontSize: AppFontSize.sm,
                          height: 1.4,
                          color: colors.muted,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!last) Container(height: 1, color: colors.line),
      ],
    );
  }
}

/// Body copy clamped to four lines with a "Read more" toggle, shown only when
/// the text actually overflows.
class _ExpandableText extends StatefulWidget {
  const _ExpandableText({required this.text});

  final String text;

  @override
  State<_ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<_ExpandableText> {
  static const _maxLines = 4;
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final style = TextStyle(
      fontSize: AppFontSize.body,
      height: 1.6,
      color: colors.ink2,
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        final painter = TextPainter(
          text: TextSpan(text: widget.text, style: style),
          maxLines: _maxLines,
          textDirection: Directionality.of(context),
        )..layout(maxWidth: constraints.maxWidth);
        final overflows = painter.didExceedMaxLines;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedSize(
              duration: const Duration(milliseconds: 180),
              alignment: Alignment.topCenter,
              child: Text(
                widget.text,
                maxLines: _expanded ? null : _maxLines,
                overflow: _expanded ? TextOverflow.visible : TextOverflow.fade,
                style: style,
              ),
            ),
            if (overflows)
              VentusTap(
                onTap: () => setState(() => _expanded = !_expanded),
                padding: const EdgeInsets.only(top: 6, bottom: 4),
                child: Text(
                  _expanded ? l10n.readLess : l10n.readMore,
                  style: TextStyle(
                    fontSize: AppFontSize.sm,
                    fontWeight: FontWeight.w700,
                    color: context.primaryFill,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
