import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// The notification switches shown on the Notification settings screen, grouped
/// into Trip activity / Travel alerts / Ventus (see `NotifSettings` in the
/// prototype). These are stored preferences, ready for when push delivery is
/// wired; each maps to a title/description in the screen.
enum NotificationKind {
  // Trip activity
  collaboratorChanges,
  itineraryUpdates,
  checklistReminders,
  // Travel alerts
  weatherChanges,
  documentExpiry,
  checkInDeparture,
  // Ventus
  travelTips,
  productNews,
}

/// User's notification switches, persisted on-device as a single JSON map (like
/// the other `core/preferences` providers). Defaults follow the prototype:
/// trip activity + travel alerts on, marketing (Ventus section) off. Missing
/// keys fall back to the default so adding a new [NotificationKind] is safe.
class NotificationPrefsController
    extends Notifier<Map<NotificationKind, bool>> {
  static const _key = 'pref_notifications';
  final _storage = const FlutterSecureStorage();

  /// Off by default — the rest default on.
  static const _offByDefault = {
    NotificationKind.travelTips,
    NotificationKind.productNews,
  };

  static Map<NotificationKind, bool> get _defaults => {
    for (final k in NotificationKind.values) k: !_offByDefault.contains(k),
  };

  @override
  Map<NotificationKind, bool> build() {
    _hydrate();
    return _defaults;
  }

  Future<void> _hydrate() async {
    final raw = await _storage.read(key: _key);
    if (raw == null) return;
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final merged = _defaults;
      for (final k in NotificationKind.values) {
        final v = decoded[k.name];
        if (v is bool) merged[k] = v;
      }
      state = merged;
    } catch (_) {
      // Corrupt value — keep defaults.
    }
  }

  Future<void> toggle(NotificationKind kind) async {
    final next = Map<NotificationKind, bool>.from(state);
    next[kind] = !(next[kind] ?? true);
    state = next;
    await _persist(next);
  }

  Future<void> _persist(Map<NotificationKind, bool> prefs) async {
    final json = jsonEncode({
      for (final e in prefs.entries) e.key.name: e.value,
    });
    await _storage.write(key: _key, value: json);
  }
}

final notificationPrefsProvider =
    NotifierProvider<NotificationPrefsController, Map<NotificationKind, bool>>(
      NotificationPrefsController.new,
    );
