import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_overlay.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/extensions/theme_context_extension.dart';
import '../../../../../../core/l10n/l10n_extension.dart';
import '../../../../../../core/theme/app_radius.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../shared/widgets/widgets.dart';
import '../../../../../explore/application/destinations_providers.dart';
import '../../../../../places/application/place_search_providers.dart';
import '../../../../../places/domain/place_suggestion.dart';
import '../../../../application/ai_planner_providers.dart';
import '../../../../application/create_trip_controller.dart';
import '../../../../domain/ai_planner_repository.dart';
import '../../../widgets/trip_photo.dart';
import '../create_chrome.dart';
import '../../../../../../core/theme/app_typography.dart';

/// Step 1 — pick one or more destinations. Shows the search-led (manual) entry
/// or the AI-led description entry depending on [CreateTripState.entry].
class DestinationStep extends ConsumerStatefulWidget {
  const DestinationStep({
    super.key,
    required this.onContinue,
    required this.onLead,
    required this.onJump,
  });

  final VoidCallback onContinue;
  final VoidCallback onLead;

  /// Jumps straight to a later step (by index) — used after the AI has already
  /// answered the steps in between.
  final ValueChanged<int> onJump;

  @override
  ConsumerState<DestinationStep> createState() => _DestinationStepState();
}

class _DestinationStepState extends ConsumerState<DestinationStep> {
  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();
  final _aiController = TextEditingController();
  final _aiScrollController = ScrollController();
  String _query = '';
  bool _aiLoading = false;

  @override
  void initState() {
    super.initState();
    _aiController.addListener(_onAiTextChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    _aiController.removeListener(_onAiTextChanged);
    _aiController.dispose();
    _aiScrollController.dispose();
    super.dispose();
  }

  void _onAiTextChanged() => setState(() {});

  void _addStop(DraftStop stop) {
    ref.read(createTripControllerProvider.notifier).addStop(stop);
    _searchController.clear();
    setState(() => _query = '');
  }

  Future<void> _parseAi() async {
    final text = _aiController.text.trim();
    final l10n = context.l10n;
    if (text.isEmpty) {
      showVentusError(context, l10n.aiNeedDescription);
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _aiLoading = true);
    try {
      final parsed = await ref
          .read(aiPlannerRepositoryProvider)
          .parseTrip(text, language: context.languageCode);
      if (!mounted) return;
      final controller = ref.read(createTripControllerProvider.notifier);
      controller.applyParsed(parsed);
      // The description already answered who's going and where, so skip the
      // Travelers step. With dates it's ready to review; without them the only
      // thing left to ask is the dates.
      widget.onJump(ref.read(createTripControllerProvider).hasDates ? 3 : 2);
    } on AiPlannerException catch (e) {
      if (!mounted) return;
      showVentusError(
        context,
        _parseErrorMessage(l10n, e.code),
        onRetry: _parseAi,
      );
    } finally {
      if (mounted) setState(() => _aiLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = ref.watch(createTripControllerProvider);
    final isAi = state.entry == CreateTripEntry.ai;
    final aiHasText = _aiController.text.trim().isNotEmpty;

    return CreateStepScaffold(
      header: CreateStepHeader(
        step: 1,
        leadIsClose: true,
        onLead: widget.onLead,
      ),
      body: isAi
          ? _AiBody(
              controller: _aiController,
              scrollController: _aiScrollController,
              loading: _aiLoading,
              onParse: _parseAi,
            )
          : _manualBody(state),
      footer: VentusButton(
        label: l10n.continueAction,
        full: true,
        loading: isAi && _aiLoading,
        iconRight: VentusIcons.arrowRight,
        onPressed: isAi
            ? (_aiLoading || !aiHasText ? null : _parseAi)
            : (state.hasStops ? widget.onContinue : null),
      ),
    );
  }

  Widget _manualBody(CreateTripState state) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CreateStepTitle(
          title: l10n.whereTo,
          subtitle: l10n.destinationSubtitle,
        ),
        VentusSearchField(
          controller: _searchController,
          focusNode: _searchFocus,
          hintText: l10n.searchCityCountry,
          onChanged: (v) => setState(() => _query = v),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: _query.trim().isEmpty
              ? _DefaultView(
                  stops: state.stops,
                  onAdd: _addStop,
                  onAddStopTap: _searchFocus.requestFocus,
                  onRemove: (i) => ref
                      .read(createTripControllerProvider.notifier)
                      .removeStopAt(i),
                )
              : _ResultsView(query: _query.trim(), onAdd: _addStop),
        ),
      ],
    );
  }
}

/// Empty-query view: the current route card plus a "Popular right now" row.
class _DefaultView extends ConsumerWidget {
  const _DefaultView({
    required this.stops,
    required this.onAdd,
    required this.onAddStopTap,
    required this.onRemove,
  });

  final List<DraftStop> stops;
  final ValueChanged<DraftStop> onAdd;
  final VoidCallback onAddStopTap;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final lang = context.languageCode;
    final popular = ref.watch(destinationsProvider).asData?.value ?? const [];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (stops.isNotEmpty)
            _RouteCard(
              stops: stops,
              onAddStopTap: onAddStopTap,
              onRemove: onRemove,
            ),
          if (popular.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 24, 0, 12),
              child: Text(
                l10n.popularRightNow.toUpperCase(),
                style: TextStyle(
                  fontSize: AppFontSize.sm,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.78,
                  color: context.colors.muted,
                ),
              ),
            ),
            SizedBox(
              height: 132,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: popular.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, i) {
                  final d = popular[i];
                  return _SuggestCard(
                    name: d.nameFor(lang),
                    country: d.countryFor(lang),
                    imageUrl: d.imageUrl,
                    onTap: () => onAdd(
                      DraftStop(
                        name: d.nameFor(lang),
                        country: d.countryFor(lang),
                        imageUrl: d.imageUrl,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

/// Typing view: live place-search results (free OSM autocomplete) with the
/// matched text highlighted, plus an "Add «query»" row so any place can be added
/// as a custom stop even when the search is empty or fails.
class _ResultsView extends ConsumerWidget {
  const _ResultsView({required this.query, required this.onAdd});

  final String query;
  final ValueChanged<DraftStop> onAdd;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    // Below the threshold: invite more typing, but still allow a manual add.
    if (query.length < kPlaceSearchMinChars) {
      return ListView(
        padding: EdgeInsets.zero,
        children: [
          _header(context, l10n.keepTyping),
          _card(context, [_customAddRow(context, last: true)]),
        ],
      );
    }

    final async = ref.watch(placeSuggestionsProvider(query));
    final results = async.asData?.value ?? const <PlaceSuggestion>[];
    final loading = async.isLoading;
    final failed = async.hasError && !loading;
    final hasExact = results.any(
      (s) => s.name.toLowerCase() == query.toLowerCase(),
    );

    // Build the row list first so the final one can drop its divider cleanly.
    final entries = <Widget Function(bool last)>[
      for (final s in results)
        (last) => _SuggestRow(
          name: s.name,
          country: s.country,
          query: query,
          last: last,
          onTap: () => onAdd(
            DraftStop(name: s.name, country: s.country, lat: s.lat, lon: s.lon),
          ),
        ),
      if (failed && results.isEmpty)
        (last) => _MessageRow(text: l10n.searchPlacesFailed),
      if (!hasExact) (last) => _customAddRow(context, last: last),
    ];

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        _header(
          context,
          loading
              ? l10n.searchingPlaces
              : l10n.placesMatch(results.length, query),
          showSpinner: loading,
        ),
        if (entries.isNotEmpty)
          _card(context, [
            for (var i = 0; i < entries.length; i++)
              entries[i](i == entries.length - 1),
          ]),
      ],
    );
  }

  Widget _header(
    BuildContext context,
    String text, {
    bool showSpinner = false,
  }) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 0, 2, 8),
      child: Row(
        children: [
          if (showSpinner) ...[
            VentusSpinner(size: 13, color: colors.muted),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Text(
              text,
              style: TextStyle(fontSize: AppFontSize.sm, color: colors.muted),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(BuildContext context, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: AppRadius.brMd,
        boxShadow: context.shadows.card,
      ),
      child: Column(children: children),
    );
  }

  Widget _customAddRow(BuildContext context, {required bool last}) {
    return _SuggestRow(
      icon: VentusIcons.plus,
      name: context.l10n.addPlace(query),
      country: '',
      query: '',
      last: last,
      onTap: () => onAdd(DraftStop(name: query, country: '')),
    );
  }
}

/// A plain message row inside the results card (e.g. a search failure note).
class _MessageRow extends StatelessWidget {
  const _MessageRow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Text(
        text,
        style: TextStyle(fontSize: AppFontSize.sm, color: context.colors.muted),
      ),
    );
  }
}

/// The route card listing current stops with a trailing "add" affordance.
class _RouteCard extends StatelessWidget {
  const _RouteCard({
    required this.stops,
    required this.onAddStopTap,
    required this.onRemove,
  });

  final List<DraftStop> stops;
  final VoidCallback onAddStopTap;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppRadius.brLg,
        boxShadow: context.shadows.card,
      ),
      child: Column(
        children: [
          for (var i = 0; i < stops.length; i++)
            _StopRow(
              name: stops[i].name,
              country: stops[i].country,
              last: false,
              onRemove: () => onRemove(i),
            ),
          VentusTap(
            onTap: onAddStopTap,
            child: Row(
              children: [
                SizedBox(
                  width: 22,
                  child: Center(
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: colors.primarySoft,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    context.l10n.addAnotherStop,
                    style: context.typography.sm.copyWith(
                      fontWeight: FontWeight.w600,
                      color: context.primaryFill,
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
}

/// One stop in the route card: timeline dot, name/country, and a remove button.
class _StopRow extends StatelessWidget {
  const _StopRow({
    required this.name,
    required this.country,
    required this.last,
    required this.onRemove,
  });

  final String name;
  final String country;
  final bool last;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 22,
            child: Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.only(top: 6),
                  decoration: BoxDecoration(
                    color: colors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: colors.surface, width: 2.5),
                    boxShadow: [
                      BoxShadow(
                        color: colors.primary,
                        spreadRadius: 1.5,
                        blurRadius: 0,
                      ),
                    ],
                  ),
                ),
                if (!last)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.only(top: 4),
                      color: colors.lineStrong,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 1, bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: AppFontSize.body,
                      fontWeight: FontWeight.w600,
                      color: colors.ink,
                      letterSpacing: -0.16,
                    ),
                  ),
                  if (country.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 1),
                      child: Text(
                        country,
                        style: TextStyle(
                          fontSize: AppFontSize.sm,
                          color: colors.muted,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          VentusTap(
            onTap: onRemove,
            child: Padding(
              padding: const EdgeInsets.only(top: 2, left: 4),
              child: VentusIcon(
                VentusIcons.close,
                size: 16,
                color: colors.muted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Small image card in the "Popular right now" row.
class _SuggestCard extends StatelessWidget {
  const _SuggestCard({
    required this.name,
    required this.country,
    required this.imageUrl,
    required this.onTap,
  });

  final String name;
  final String country;
  final String? imageUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VentusTap(
      onTap: onTap,
      child: TripPhoto(
        imageUrl: imageUrl,
        width: 116,
        height: 132,
        borderRadius: AppRadius.brMd,
        child: Stack(
          children: [
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x001F1B18), Color(0xBD1F1B18)],
                    stops: [0.42, 1],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 9,
              right: 9,
              child: Container(
                width: 26,
                height: 26,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppOverlay.onPhotoStrong,
                  shape: BoxShape.circle,
                ),
                child: VentusIcon(
                  VentusIcons.plus,
                  size: 16,
                  stroke: 2.2,
                  color: context.colors.primary,
                ),
              ),
            ),
            Positioned(
              left: 11,
              right: 11,
              bottom: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    country.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: AppFontSize.eyebrow,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.45,
                      color: AppOverlay.onPhotoMuted,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: AppFontSize.body,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: -0.15,
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

/// A search result row with the matched substring highlighted.
class _SuggestRow extends StatelessWidget {
  const _SuggestRow({
    this.icon = VentusIcons.mapPin,
    required this.name,
    required this.country,
    required this.query,
    required this.last,
    required this.onTap,
  });

  final String icon;
  final String name;
  final String country;
  final String query;
  final bool last;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return VentusTap(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                VentusLeadIcon(icon),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Highlighted(
                        text: name,
                        query: query,
                        base: TextStyle(
                          fontSize: AppFontSize.body,
                          fontWeight: FontWeight.w600,
                          color: colors.ink,
                          letterSpacing: -0.16,
                        ),
                        highlight: TextStyle(
                          color: context.primaryFill,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      if (country.isNotEmpty)
                        Text(
                          country,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: AppFontSize.sm,
                            color: colors.muted,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (!last) Container(height: 1, color: colors.line),
        ],
      ),
    );
  }
}

/// Renders [text] with the first case-insensitive occurrence of [query] styled
/// with [highlight].
class _Highlighted extends StatelessWidget {
  const _Highlighted({
    required this.text,
    required this.query,
    required this.base,
    required this.highlight,
  });

  final String text;
  final String query;
  final TextStyle base;
  final TextStyle highlight;

  @override
  Widget build(BuildContext context) {
    final idx = query.isEmpty
        ? -1
        : text.toLowerCase().indexOf(query.toLowerCase());
    if (idx < 0) {
      return Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: base,
      );
    }
    return Text.rich(
      TextSpan(
        style: base,
        children: [
          TextSpan(text: text.substring(0, idx)),
          TextSpan(
            text: text.substring(idx, idx + query.length),
            style: highlight,
          ),
          TextSpan(text: text.substring(idx + query.length)),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

/// AI-led entry (prototype `CreateDestinationAI`): the user describes the trip
/// in free text and the sparkle button parses it (via the Gemini-backed
/// `parse-trip` function) into stops + dates + travellers, then advances the
/// flow pre-filled. Tappable example chips below the field seed the text for
/// users unsure what to write.
class _AiBody extends StatelessWidget {
  const _AiBody({
    required this.controller,
    required this.scrollController,
    required this.loading,
    required this.onParse,
  });

  final TextEditingController controller;
  final ScrollController scrollController;
  final bool loading;

  /// Parses the current text (shared by the sparkle button and the footer
  /// "Davam et" button once there's text to parse).
  final VoidCallback onParse;

  /// Fills the text field with a tapped example prompt, cursor at the end.
  void _fillExample(String text) {
    controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CreateStepTitle(title: l10n.aiTitle, subtitle: l10n.aiSubtitle),
          Container(
            height: 180,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: AppRadius.brLg,
              border: Border.all(color: colors.primary, width: 1.5),
              boxShadow: [
                BoxShadow(color: colors.ring, blurRadius: 0, spreadRadius: 3),
              ],
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Scrollbar(
                    controller: scrollController,
                    thumbVisibility: false,
                    child: TextField(
                      controller: controller,
                      scrollController: scrollController,
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      enabled: !loading,
                      textInputAction: TextInputAction.newline,
                      maxLength: 500,
                      style: TextStyle(
                        fontSize: AppFontSize.body,
                        height: 23 / 16,
                        fontWeight: FontWeight.w500,
                        color: colors.ink,
                      ),
                      decoration: InputDecoration(
                        isCollapsed: true,
                        border: InputBorder.none,
                        counterText: '',
                        // Right gutter clears the text from under the sparkle
                        // button; the scrollbar track can run behind it.
                        contentPadding: const EdgeInsets.only(right: 46),
                        hintText: l10n.aiPromptHint,
                        hintStyle: TextStyle(
                          fontSize: AppFontSize.body,
                          height: 23 / 16,
                          fontWeight: FontWeight.w500,
                          color: colors.muted,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: VentusTap(
                    onTap: loading ? null : onParse,
                    child: Container(
                      width: 34,
                      height: 34,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: colors.primary,
                        borderRadius: AppRadius.brSm,
                      ),
                      child: loading
                          ? VentusSpinner(size: 16, color: colors.onPrimary)
                          : VentusIcon(
                              VentusIcons.sparkle,
                              size: 18,
                              color: colors.onPrimary,
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (loading) ...[
            const SizedBox(height: 12),
            Text(
              l10n.aiReadingTrip,
              style: TextStyle(fontSize: AppFontSize.sm, color: colors.muted),
            ),
          ] else ...[
            const SizedBox(height: 20),
            Text(
              l10n.aiExamplesLabel.toUpperCase(),
              style: TextStyle(
                fontSize: AppFontSize.sm,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.78,
                color: colors.muted,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                VentusChip(
                  label: l10n.aiExampleRomanticLabel,
                  onTap: () => _fillExample(l10n.aiExampleRomanticText),
                ),
                VentusChip(
                  label: l10n.aiExampleFamilyLabel,
                  onTap: () => _fillExample(l10n.aiExampleFamilyText),
                ),
                VentusChip(
                  label: l10n.aiExampleFriendsLabel,
                  onTap: () => _fillExample(l10n.aiExampleFriendsText),
                ),
                VentusChip(
                  label: l10n.aiExampleSoloLabel,
                  onTap: () => _fillExample(l10n.aiExampleSoloText),
                ),
                VentusChip(
                  label: l10n.aiExampleCityLabel,
                  onTap: () => _fillExample(l10n.aiExampleCityText),
                ),
                VentusChip(
                  label: l10n.aiExampleWinterLabel,
                  onTap: () => _fillExample(l10n.aiExampleWinterText),
                ),
              ],
            ),
          ],
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

/// Maps an [AiPlannerErrorCode] to a localised message for the parse flow.
String _parseErrorMessage(AppLocalizations l10n, AiPlannerErrorCode? code) {
  switch (code) {
    case AiPlannerErrorCode.notConfigured:
      return l10n.aiPlanUnavailable;
    case AiPlannerErrorCode.network:
      return l10n.aiPlanNetworkError;
    case AiPlannerErrorCode.empty:
      return l10n.aiParseEmpty;
    case AiPlannerErrorCode.unknown:
    case null:
      return l10n.aiParseFailed;
  }
}
