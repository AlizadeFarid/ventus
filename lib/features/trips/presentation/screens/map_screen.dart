import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';

import '../../../../core/extensions/theme_context_extension.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../application/itinerary_providers.dart';
import '../../application/trip_detail_providers.dart';
import '../../application/trip_geocode_controller.dart';
import '../../domain/itinerary_item.dart';
import '../../domain/trip_stop.dart';
import '../widgets/itinerary_format.dart';
import '../widgets/map_style.dart';
import '../widgets/map_tiles.dart';
import '../widgets/module_header_row.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_spacing.dart';

/// One thing plotted on the map — either a route stop (city) or an activity
/// from the day plan. Keeping both behind one type lets the map, the bottom
/// list and the selection logic stay agnostic about where a pin came from.
class MapPoint {
  const MapPoint({
    required this.id,
    required this.name,
    required this.point,
    required this.icon,
    this.subtitle,
    this.day,
    this.isStop = false,
  });

  final String id;
  final String name;
  final LatLng point;
  final String icon;

  /// Country for a stop, time (or place text) for an activity.
  final String? subtitle;

  /// 1-based day for an activity; null for a route stop.
  final int? day;
  final bool isStop;
}

/// Map tab content.
///
/// Two layers sit on the same map: the trip's **route** (its city stops, in
/// order) and its **day plan** (every activity whose place the geocoder could
/// resolve). The day chips switch between "everything at once" and a single
/// day, where the activities are numbered and joined into that day's walking
/// line. Coordinates are filled in on the fly by [tripAutoGeocodeProvider], so
/// an AI-generated plan maps itself without the user doing anything.
class MapTabBody extends ConsumerStatefulWidget {
  const MapTabBody({super.key, required this.tripId, this.onShowInPlan});

  final String tripId;

  /// Jumps the Trip Hub to the day plan (used by a selected pin's action).
  final VoidCallback? onShowInPlan;

  @override
  ConsumerState<MapTabBody> createState() => _MapTabBodyState();
}

class _MapTabBodyState extends ConsumerState<MapTabBody> {
  /// Selected day, or null for "All".
  int? _day;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final trip = ref.watch(tripDetailProvider(widget.tripId)).asData?.value;

    ref.watch(itinerarySyncProvider(widget.tripId));
    final items =
        ref.watch(itineraryProvider(widget.tripId)).asData?.value ??
        const <ItineraryItem>[];

    // Fills in whatever coordinates are still missing, once per visit.
    final auto = ref.watch(tripAutoGeocodeProvider(widget.tripId));
    final busy =
        auto.isLoading || ref.watch(tripGeocodeControllerProvider).isLoading;

    final stops = trip?.stops ?? const <TripStop>[];
    final locatedStops = stops.where((s) => s.hasCoords).toList();
    final locatedItems = items.where((i) => i.hasCoords).toList();
    final missing =
        stops.where((s) => !s.hasCoords && s.name.trim().isNotEmpty).length +
        items.where((i) => !i.hasCoords && i.geocodeQuery.isNotEmpty).length;

    final days = (locatedItems.map((i) => i.day).toSet().toList()..sort());
    // A day that's no longer on the map (item deleted) falls back to "All".
    final activeDay = days.contains(_day) ? _day : null;

    final hasAnything = locatedStops.isNotEmpty || locatedItems.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ModuleHeaderRow(
          title: l10n.moduleMap,
          action: missing > 0 || busy
              ? _LocateAction(busy: busy, onTap: _locate)
              : null,
        ),
        if (hasAnything && days.length > 1)
          _DayChips(
            days: days,
            active: activeDay,
            onSelect: (d) => setState(() => _day = d),
          ),
        Expanded(
          child: !hasAnything
              ? _EmptyMap(busy: busy, canLocate: missing > 0, onLocate: _locate)
              : MapBody(
                  stops: locatedStops,
                  items: locatedItems,
                  day: activeDay,
                  missing: missing,
                  onLocate: _locate,
                  onShowInPlan: widget.onShowInPlan,
                ),
        ),
      ],
    );
  }

  /// Manual retry of the geocoder for everything still unlocated.
  Future<void> _locate() async {
    final l10n = context.l10n;
    try {
      final outcome = await ref
          .read(tripGeocodeControllerProvider.notifier)
          .resolveMissing(widget.tripId);
      if (!mounted) return;
      ref.invalidate(tripDetailProvider(widget.tripId));
      showVentusSnack(
        context,
        outcome.located > 0
            ? l10n.mapLocated(outcome.located)
            : l10n.mapNothingLocated,
      );
    } catch (_) {
      if (!mounted) return;
      showVentusError(context, l10n.mapLocateFailed, onRetry: _locate);
    }
  }
}

/// The live map + the bottom list, kept stateful so the shared [MapController]
/// survives rebuilds and both directions of selection (pin ↔ row) stay in sync.
class MapBody extends ConsumerStatefulWidget {
  const MapBody({
    super.key,
    required this.stops,
    required this.items,
    required this.day,
    required this.missing,
    required this.onLocate,
    this.onShowInPlan,
  });

  final List<TripStop> stops;
  final List<ItineraryItem> items;

  /// Selected day, or null for the whole trip.
  final int? day;

  /// How many places still have no coordinates (shown as a footer hint).
  final int missing;

  final Future<void> Function() onLocate;
  final VoidCallback? onShowInPlan;

  @override
  ConsumerState<MapBody> createState() => _MapBodyState();
}

class _MapBodyState extends ConsumerState<MapBody> {
  final _controller = MapController();
  final _listController = ScrollController();

  /// Index into [_points] of the pin whose card is showing, if any.
  int? _selected;

  @override
  void didUpdateWidget(MapBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.day == widget.day) return;
    // Switching days keeps the same map (so tiles aren't re-fetched) and just
    // flies the camera onto the new set of points.
    setState(() => _selected = null);
    final points = _points;
    if (points.isEmpty) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _controller.fitCamera(
        CameraFit.coordinates(
          coordinates: [for (final p in points) p.point],
          padding: const EdgeInsets.fromLTRB(60, 90, 60, 240),
          maxZoom: 14,
        ),
      );
    });
  }

  @override
  void dispose() {
    _listController.dispose();
    super.dispose();
  }

  /// What the bottom list and the numbered pins show: a single day's
  /// activities in order, or — with no day selected — the route's stops
  /// followed by every mapped activity.
  List<MapPoint> get _points {
    final day = widget.day;
    if (day != null) {
      return [
        for (final i in widget.items.where((i) => i.day == day))
          _activityPoint(i),
      ];
    }
    return [
      for (final s in widget.stops)
        MapPoint(
          id: s.id,
          name: s.name,
          point: LatLng(s.lat!, s.lon!),
          icon: VentusIcons.mapPin,
          subtitle: s.country.isEmpty ? null : s.country,
          isStop: true,
        ),
      for (final i in widget.items) _activityPoint(i),
    ];
  }

  MapPoint _activityPoint(ItineraryItem item) => MapPoint(
    id: item.id,
    name: item.title,
    point: LatLng(item.lat!, item.lon!),
    icon: activityKindIcon(item.kind),
    subtitle: _activitySubtitle(item),
    day: item.day,
  );

  String? _activitySubtitle(ItineraryItem item) {
    final time = formatStartMinutes(item.startMinutes);
    final place = item.place?.trim();
    if (time != null && place != null && place.isNotEmpty)
      return '$time · $place';
    if (time != null) return time;
    return (place != null && place.isNotEmpty) ? place : null;
  }

  /// The line drawn between points: a day's activities in order, or the route
  /// between city stops when no day is selected.
  List<LatLng> _lineFor(List<MapPoint> points) {
    if (widget.day != null) return [for (final p in points) p.point];
    final stops = [
      for (final p in points)
        if (p.isStop) p.point,
    ];
    return stops.length > 1 ? stops : const [];
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final points = _points;

    if (points.isEmpty) return _DayEmpty(onShowInPlan: widget.onShowInPlan);

    final line = _lineFor(points);
    final selected = (_selected != null && _selected! < points.length)
        ? points[_selected!]
        : null;

    return Stack(
      children: [
        FlutterMap(
          mapController: _controller,
          options: MapOptions(
            initialCameraFit: CameraFit.coordinates(
              coordinates: [for (final p in points) p.point],
              padding: const EdgeInsets.fromLTRB(60, 90, 60, 240),
              maxZoom: 14,
            ),
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
            ),
            onTap: (_, _) => setState(() => _selected = null),
          ),
          children: [
            _basemapLayer(context, ref),
            if (line.length > 1)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: line,
                    strokeWidth: 3.5,
                    color: colors.primary.withValues(alpha: 0.85),
                  ),
                ],
              ),
            MarkerLayer(
              markers: [
                for (var i = 0; i < points.length; i++)
                  Marker(
                    point: points[i].point,
                    width: 44,
                    height: 44,
                    alignment: Alignment.topCenter,
                    child: _Pin(
                      point: points[i],
                      // Numbered only where the order means something: a day's
                      // activities, and the city route.
                      label: widget.day != null || points[i].isStop
                          ? '${_orderOf(points, i)}'
                          : null,
                      selected: _selected == i,
                      onTap: () => _select(i, points.length),
                    ),
                  ),
              ],
            ),
          ],
        ),
        // OpenStreetMap requires visible attribution.
        Positioned(
          left: 8,
          bottom: 8,
          child: _AttributionChip(
            source: ref.watch(mapStyleProvider(MapBasemap.of(context))).hasValue
                ? 'OpenFreeMap'
                : 'CARTO',
          ),
        ),
        if (selected != null)
          Positioned(
            left: 14,
            right: 14,
            top: 10,
            child: _SelectedCard(
              point: selected,
              onClose: () => setState(() => _selected = null),
              onShowInPlan: selected.isStop ? null : widget.onShowInPlan,
            ),
          ),
        Align(
          alignment: Alignment.bottomCenter,
          child: _PointList(
            points: points,
            day: widget.day,
            missing: widget.missing,
            selected: _selected,
            controller: _listController,
            onLocate: widget.onLocate,
            onTap: (i) => _select(i, points.length),
          ),
        ),
      ],
    );
  }

  /// The number a pin carries: its position among stops, or within its day.
  int _orderOf(List<MapPoint> points, int index) {
    if (widget.day != null) return index + 1;
    var n = 0;
    for (var i = 0; i <= index; i++) {
      if (points[i].isStop) n++;
    }
    return n;
  }

  /// Selects a point from either side (pin tap or list row): centres the map,
  /// shows its card, and scrolls the row into view.
  void _select(int index, int total) {
    setState(() => _selected = index);
    _controller.move(_points[index].point, 13);
    if (!_listController.hasClients) return;
    const rowHeight = 52.0;
    final target = (index * rowHeight).clamp(
      0.0,
      _listController.position.maxScrollExtent,
    );
    _listController.animateTo(
      target,
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOut,
    );
  }
}

/// The sheet under the pins: OpenFreeMap vector tiles with Latin labels once
/// the style document has loaded, and the raster sheet until then — so the map
/// is never blank while a first-run style fetch is in flight, and a failed
/// fetch (offline) still leaves a usable map.
Widget _basemapLayer(BuildContext context, WidgetRef ref) {
  final style = ref.watch(mapStyleProvider(MapBasemap.of(context)));
  final loaded = style.asData?.value;
  if (loaded == null) return mapTileLayer(context);
  return VectorTileLayer(
    theme: loaded.theme,
    sprites: loaded.sprites,
    tileProviders: loaded.providers,
  );
}

/// Horizontal "All / Day 1 / Day 2 …" filter above the map.
class _DayChips extends StatelessWidget {
  const _DayChips({
    required this.days,
    required this.active,
    required this.onSelect,
  });

  final List<int> days;
  final int? active;
  final ValueChanged<int?> onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen,
          4,
          AppSpacing.screen,
          6,
        ),
        itemCount: days.length + 1,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          if (i == 0) {
            return VentusChip(
              label: l10n.mapFilterAll,
              active: active == null,
              onTap: () => onSelect(null),
            );
          }
          final day = days[i - 1];
          return VentusChip(
            label: '${l10n.dayLabel} $day',
            active: active == day,
            onTap: () => onSelect(day),
          );
        },
      ),
    );
  }
}

/// Header action: runs the geocoder for whatever is still unlocated.
class _LocateAction extends StatelessWidget {
  const _LocateAction({required this.busy, required this.onTap});

  final bool busy;
  final Future<void> Function() onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return VentusTap(
      onTap: busy ? null : onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (busy)
            VentusSpinner(size: 14, color: colors.primary)
          else
            VentusIcon(VentusIcons.mapPin, size: 16, color: colors.primary),
          const SizedBox(width: 7),
          Text(
            busy ? l10n.mapLocating : l10n.mapFindPlaces,
            style: TextStyle(
              fontSize: AppFontSize.sm,
              fontWeight: FontWeight.w700,
              color: context.primaryFill,
            ),
          ),
        ],
      ),
    );
  }
}

/// A map marker: numbered where order matters, kind-iconed otherwise.
class _Pin extends StatelessWidget {
  const _Pin({
    required this.point,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final MapPoint point;
  final String? label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    // Activities in the "All" view sit visually behind the route stops, so the
    // trip's shape still reads at a glance.
    final muted = point.day != null && label == null;
    final bg = selected
        ? colors.ink
        : (muted ? colors.surface : context.primaryFill);
    final fg = selected
        ? colors.onPrimary
        : (muted ? colors.primary : colors.onPrimary);
    final size = selected ? 36.0 : (muted ? 26.0 : 30.0);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Center(
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: bg,
            shape: BoxShape.circle,
            border: Border.all(color: colors.onPrimary, width: 2.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: label != null
              ? Text(
                  label!,
                  style: TextStyle(
                    color: fg,
                    fontSize: AppFontSize.sm,
                    fontWeight: FontWeight.w700,
                  ),
                )
              : VentusIcon(point.icon, size: 14, color: fg),
        ),
      ),
    );
  }
}

/// Floating card for the tapped pin, with a jump into the day plan.
class _SelectedCard extends StatelessWidget {
  const _SelectedCard({
    required this.point,
    required this.onClose,
    this.onShowInPlan,
  });

  final MapPoint point;
  final VoidCallback onClose;
  final VoidCallback? onShowInPlan;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppRadius.brLg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: VentusIcon(point.icon, size: 17, color: colors.primary),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  point.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: AppFontSize.body,
                    fontWeight: FontWeight.w600,
                    color: colors.ink,
                  ),
                ),
                if (point.subtitle != null)
                  Text(
                    point.day != null
                        ? '${l10n.dayLabel} ${point.day} · ${point.subtitle}'
                        : point.subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: AppFontSize.caption,
                      color: colors.muted,
                    ),
                  ),
                if (onShowInPlan != null) ...[
                  const SizedBox(height: 6),
                  VentusTap(
                    onTap: onShowInPlan,
                    child: Text(
                      l10n.mapShowInPlan,
                      style: TextStyle(
                        fontSize: AppFontSize.sm,
                        fontWeight: FontWeight.w700,
                        color: context.primaryFill,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            onPressed: onClose,
            icon: VentusIcon(VentusIcons.close, size: 16, color: colors.muted),
          ),
        ],
      ),
    );
  }
}

/// Bottom card listing what's currently plotted, with the day's walking
/// distance and a hint about anything the geocoder couldn't place.
class _PointList extends StatelessWidget {
  const _PointList({
    required this.points,
    required this.day,
    required this.missing,
    required this.selected,
    required this.controller,
    required this.onLocate,
    required this.onTap,
  });

  final List<MapPoint> points;
  final int? day;
  final int missing;
  final int? selected;
  final ScrollController controller;
  final Future<void> Function() onLocate;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    final km = day == null
        ? 0.0
        : routeLengthKm([
            for (final p in points)
              (lat: p.point.latitude, lon: p.point.longitude),
          ]);

    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 16),
      padding: const EdgeInsets.fromLTRB(6, 12, 6, 6),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppRadius.brLg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: Row(
              children: [
                VentusIcon(VentusIcons.route, size: 16, color: colors.primary),
                const SizedBox(width: 8),
                Text(
                  day == null ? l10n.mapRouteTitle : '${l10n.dayLabel} $day',
                  style: context.typography.h3.copyWith(
                    fontSize: AppFontSize.sm,
                    fontWeight: FontWeight.w700,
                    color: colors.ink,
                  ),
                ),
                const Spacer(),
                Text(
                  km >= 0.1
                      ? '${l10n.mapPlacesCount(points.length)} · '
                            '${l10n.mapDayDistance(km.toStringAsFixed(1))}'
                      : l10n.mapPlacesCount(points.length),
                  style: TextStyle(
                    fontSize: AppFontSize.caption,
                    color: colors.muted,
                  ),
                ),
              ],
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 184),
            child: ListView.builder(
              controller: controller,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: points.length,
              itemBuilder: (context, i) => _PointRow(
                order: day != null || points[i].isStop ? _orderOf(i) : null,
                point: points[i],
                active: selected == i,
                onTap: () => onTap(i),
              ),
            ),
          ),
          if (missing > 0)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 8, 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.mapMissingPlaces(missing),
                      style: TextStyle(
                        fontSize: AppFontSize.caption,
                        color: colors.muted,
                      ),
                    ),
                  ),
                  VentusTap(
                    onTap: onLocate,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      child: Text(
                        l10n.mapFindPlaces,
                        style: TextStyle(
                          fontSize: AppFontSize.caption,
                          fontWeight: FontWeight.w700,
                          color: context.primaryFill,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  int _orderOf(int index) {
    if (day != null) return index + 1;
    var n = 0;
    for (var i = 0; i <= index; i++) {
      if (points[i].isStop) n++;
    }
    return n;
  }
}

class _PointRow extends StatelessWidget {
  const _PointRow({
    required this.order,
    required this.point,
    required this.active,
    required this.onTap,
  });

  final int? order;
  final MapPoint point;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final subtitle = point.day != null && point.subtitle != null
        ? '${l10n.dayLabel} ${point.day} · ${point.subtitle}'
        : point.subtitle ??
              (point.day != null ? '${l10n.dayLabel} ${point.day}' : null);

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.brMd,
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: active ? colors.surfaceSand : null,
          borderRadius: AppRadius.brMd,
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: order != null
                  ? Text(
                      '$order',
                      style: TextStyle(
                        fontSize: AppFontSize.caption,
                        fontWeight: FontWeight.w700,
                        color: context.primaryFill,
                      ),
                    )
                  : VentusIcon(point.icon, size: 13, color: colors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    point.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: AppFontSize.sm,
                      fontWeight: FontWeight.w600,
                      color: colors.ink,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: AppFontSize.caption,
                        color: colors.muted,
                      ),
                    ),
                ],
              ),
            ),
            VentusIcon(VentusIcons.mapPin, size: 16, color: colors.muted),
          ],
        ),
      ),
    );
  }
}

/// Minimal attribution chip (required by every tile provider we use).
class _AttributionChip extends StatelessWidget {
  const _AttributionChip({required this.source});

  /// Who drew the sheet currently on screen.
  final String source;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.85),
        borderRadius: AppRadius.brSm,
      ),
      child: Text(
        '© OpenStreetMap · © $source',
        style: TextStyle(fontSize: AppFontSize.eyebrow, color: colors.muted),
      ),
    );
  }
}

/// Shown when the selected day has nothing mappable (its activities have no
/// resolvable place yet).
class _DayEmpty extends StatelessWidget {
  const _DayEmpty({this.onShowInPlan});

  final VoidCallback? onShowInPlan;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.mapDayEmpty,
              textAlign: TextAlign.center,
              style: context.typography.body.copyWith(
                fontSize: AppFontSize.sm,
                color: colors.muted,
              ),
            ),
            if (onShowInPlan != null) ...[
              const SizedBox(height: 12),
              VentusButton(
                label: l10n.mapShowInPlan,
                variant: VentusButtonVariant.ghost,
                onPressed: onShowInPlan,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Shown when nothing on the trip has a location yet — with the action that
/// actually fixes it, rather than only an explanation.
class _EmptyMap extends StatelessWidget {
  const _EmptyMap({
    required this.busy,
    required this.canLocate,
    required this.onLocate,
  });

  /// Whether the geocoder is running right now.
  final bool busy;

  /// Whether there is anything left worth looking up.
  final bool canLocate;

  final Future<void> Function() onLocate;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: busy
                  ? VentusSpinner(size: 26, color: colors.primary)
                  : VentusIcon(
                      VentusIcons.mapPin,
                      size: 30,
                      color: colors.primary,
                    ),
            ),
            const SizedBox(height: 18),
            Text(
              busy ? l10n.mapLocating : l10n.emptyMapTitle,
              textAlign: TextAlign.center,
              style: context.typography.h3.copyWith(
                fontSize: AppFontSize.h3,
                fontWeight: FontWeight.w700,
                color: colors.ink,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              canLocate ? l10n.emptyMapNoCoords : l10n.emptyMapBody,
              textAlign: TextAlign.center,
              style: context.typography.body.copyWith(
                fontSize: AppFontSize.sm,
                color: colors.muted,
              ),
            ),
            if (canLocate && !busy) ...[
              const SizedBox(height: 18),
              VentusButton(
                label: l10n.mapFindPlaces,
                iconLeft: VentusIcons.mapPin,
                onPressed: onLocate,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
