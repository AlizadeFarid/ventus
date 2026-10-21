import 'dart:async';

import 'package:flutter/foundation.dart';

/// Adapts a [Stream] into a [Listenable] so GoRouter re-evaluates its redirects
/// whenever the stream emits — used to refresh routing on auth-state changes.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
