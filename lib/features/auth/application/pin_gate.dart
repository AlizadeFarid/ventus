import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pin_service.dart';

/// Tracks whether the app must show the quick-unlock PIN screen right now.
///
/// The PIN is a *convenience* lock (data already lives on-device), enforced on
/// cold start: a signed-in user who set a PIN unlocks once per app launch, then
/// navigates freely for the rest of the session. Because [PinService.hasPin] is
/// async but the router's redirect is synchronous, this holds the resolved
/// state as a [ChangeNotifier] the router can read and listen to.
class PinGate extends ChangeNotifier {
  PinGate(this._service) {
    _load();
  }

  final PinService _service;

  bool _ready = false;
  bool _hasPin = false;
  bool _unlocked = false;

  /// Whether a signed-in user must pass the unlock screen before continuing.
  ///
  /// True while we're still resolving [hasPin] (so content never flashes before
  /// a lock), or once we know a PIN exists and this session isn't unlocked yet.
  bool get mustUnlock => !_ready || (_hasPin && !_unlocked);

  Future<void> _load() async {
    try {
      _hasPin = await _service.hasPin();
    } catch (_) {
      _hasPin = false; // fail open — a convenience lock shouldn't trap the user
    }
    _ready = true;
    notifyListeners();
  }

  /// Marks this session as unlocked (correct PIN entered).
  void unlock() {
    if (_unlocked) return;
    _unlocked = true;
    notifyListeners();
  }

  /// Re-reads whether a PIN exists after it was set/changed, and treats the
  /// session as unlocked (the user just proved themselves by setting it).
  Future<void> refresh() async {
    try {
      _hasPin = await _service.hasPin();
    } catch (_) {
      _hasPin = false;
    }
    _ready = true;
    _unlocked = true;
    notifyListeners();
  }

  /// Re-locks so the next session must enter the PIN again (e.g. on sign-out).
  void relock() {
    if (!_unlocked) return;
    _unlocked = false;
    notifyListeners();
  }
}

/// Single app-wide [PinGate]. Held as a plain provider (not watched for rebuild)
/// — the router reads it and listens via its `refreshListenable`.
final pinGateProvider = Provider<PinGate>((ref) {
  final gate = PinGate(ref.watch(pinServiceProvider));
  ref.onDispose(gate.dispose);
  return gate;
});
