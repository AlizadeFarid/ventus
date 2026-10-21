import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/theme_context_extension.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../application/tools_providers.dart';
import '../../domain/geo_city.dart';
import '../../../../core/theme/app_spacing.dart';

/// Results list for the inline city search (Weather and World clock): loading,
/// offline, empty and result states for [query], reporting the pick via
/// [onPick].
class CitySearchResults extends ConsumerWidget {
  const CitySearchResults({
    super.key,
    required this.query,
    required this.onPick,
  });

  final String query;
  final ValueChanged<GeoCity> onPick;

  Widget _message(BuildContext context, String text) => Padding(
    padding: const EdgeInsets.fromLTRB(
      AppSpacing.screen,
      16,
      AppSpacing.screen,
      0,
    ),
    child: Text(
      text,
      style: context.typography.body.copyWith(color: context.colors.muted),
    ),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final l10n = context.l10n;
    // Under 2 characters the field's hint already says what to do.
    if (query.trim().length < 2) return _message(context, l10n.searchCityHint);

    return ref
        .watch(citySearchProvider(query))
        .when(
          loading: () => const Padding(
            padding: EdgeInsets.all(24),
            child: Align(
              alignment: Alignment.topCenter,
              child: VentusSpinner(),
            ),
          ),
          error: (_, _) => _message(context, l10n.toolsOffline),
          data: (cities) => cities.isEmpty
              ? _message(context, l10n.noCitiesFound)
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screen,
                    0,
                    AppSpacing.screen,
                    24,
                  ),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  itemCount: cities.length,
                  itemBuilder: (context, i) {
                    final c = cities[i];
                    return VentusListRow(
                      leading: VentusIcon(
                        VentusIcons.mapPin,
                        size: 20,
                        color: colors.primary,
                      ),
                      title: c.name,
                      subtitle: c.country,
                      onTap: () => onPick(c),
                    );
                  },
                ),
        );
  }
}
