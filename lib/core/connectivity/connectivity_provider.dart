import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Whether the device currently has any network interface up.
///
/// Ventus is local-first: trips, itineraries, checklists, budgets and saved
/// places all read and write to Drift, so losing the network degrades the app
/// rather than breaking it. What was missing was *telling the user* — an
/// upload would fail, a Discover row would come back empty, and there was no
/// way to tell "nothing here" from "you're offline".
///
/// This is a reachability signal, not a guarantee: a connected Wi-Fi network
/// with no route to the internet still reports online. It is used only to show
/// a banner, never to gate a write — writes always go to Drift first and sync
/// later.
final isOnlineProvider = StreamProvider<bool>((ref) async* {
  final connectivity = Connectivity();
  bool online(List<ConnectivityResult> results) =>
      results.any((r) => r != ConnectivityResult.none);

  yield online(await connectivity.checkConnectivity());
  yield* connectivity.onConnectivityChanged.map(online);
});
