import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/extensions/theme_context_extension.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../shared/widgets/widgets.dart';

/// Maps apps Ventus offers. Only the ones installed on the phone are listed;
/// each also needs its scheme / package declared in Info.plist and
/// AndroidManifest.xml, or it can never be detected.
const _mapApps = <MapApp>[
  MapApp.apple,
  MapApp.google,
  MapApp.waze,
  MapApp.yandexMaps,
];

/// A taxi app that can be handed a destination.
class _TaxiApp {
  const _TaxiApp(this.name, this.probe, this.link);

  final String name;

  /// A bare scheme URL used only to ask "is this app installed?".
  final Uri probe;

  /// The deep link that opens the app with the destination filled in.
  final Uri Function(double lat, double lon, String name) link;
}

final _taxiApps = <_TaxiApp>[
  _TaxiApp(
    'Uber',
    Uri.parse('uber://'),
    (lat, lon, name) => Uri.parse(
      'uber://?action=setPickup&pickup=my_location'
      '&dropoff[latitude]=$lat&dropoff[longitude]=$lon'
      '&dropoff[nickname]=${Uri.encodeComponent(name)}',
    ),
  ),
  _TaxiApp(
    'Yandex Go',
    Uri.parse('yandextaxi://'),
    (lat, lon, name) =>
        Uri.parse('yandextaxi://route?end-lat=$lat&end-lon=$lon'),
  ),
];

/// Opens [place] in the user's maps app, or hands it to a taxi app.
///
/// Uses the activity's coordinates when the geocoder has resolved them, and a
/// text search otherwise. Lists only apps that are actually installed; if none
/// are found it falls back to the system's default map so the tap never does
/// nothing.
Future<void> showOpenInMapsSheet(
  BuildContext context, {
  required String place,
  double? lat,
  double? lon,
}) async {
  final hasCoords = lat != null && lon != null;
  final request = MapLauncher.marker(
    hasCoords ? .coords(lat, lon, title: place) : .search(place),
  );

  List<SupportedMap> maps = const [];
  try {
    maps = (await request.getSupportedMaps(
      _mapApps,
    )).where((m) => m.isInstalled).toList();
  } catch (_) {
    // Detection failed: fall through to the default-map fallback below.
  }

  final taxis = <_TaxiApp>[];
  if (hasCoords) {
    for (final taxi in _taxiApps) {
      try {
        if (await canLaunchUrl(taxi.probe)) taxis.add(taxi);
      } catch (_) {}
    }
  }
  if (!context.mounted) return;

  if (maps.isEmpty && taxis.isEmpty) {
    await _launch(context, () => request.show());
    return;
  }

  await showVentusSheet<void>(
    context,
    isScrollControlled: false,
    builder: (sheetContext) {
      final l10n = sheetContext.l10n;
      void close() => Navigator.of(sheetContext).pop();
      return VentusSheetFrame(
        title: place,
        maxHeightFactor: 0.7,
        child: ListView(
          shrinkWrap: true,
          children: [
            VentusSectionLabel(
              l10n.openInMaps,
              padding: const EdgeInsets.fromLTRB(4, 0, 4, 4),
            ),
            for (final map in maps)
              VentusListRow(
                title: map.name,
                leading: ClipRRect(
                  borderRadius: AppRadius.brSm,
                  child: Image.memory(map.iconBytes, width: 34, height: 34),
                ),
                onTap: () {
                  close();
                  _launch(context, () => map.show());
                },
              ),
            if (taxis.isNotEmpty) ...[
              VentusSectionLabel(
                l10n.taxiSection,
                padding: const EdgeInsets.fromLTRB(4, 14, 4, 4),
              ),
              for (final taxi in taxis)
                VentusListRow(
                  title: taxi.name,
                  leading: VentusLeadIcon(
                    VentusIcons.car,
                    size: 22,
                    color: sheetContext.colors.ink2,
                  ),
                  onTap: () {
                    close();
                    _launch(
                      context,
                      () => launchUrl(
                        taxi.link(lat!, lon!, place),
                        mode: LaunchMode.externalApplication,
                      ),
                    );
                  },
                ),
            ],
          ],
        ),
      );
    },
  );
}

Future<void> _launch(
  BuildContext context,
  Future<Object?> Function() open,
) async {
  try {
    await open();
  } catch (_) {
    if (context.mounted) {
      showVentusError(context, context.l10n.somethingWentWrong);
    }
  }
}
