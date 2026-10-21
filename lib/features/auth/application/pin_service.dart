import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Stores and verifies the quick-unlock PIN on-device.
///
/// The PIN never leaves the device — only a salted SHA-256 hash of it lives in
/// the platform keychain / keystore via [FlutterSecureStorage] (the hash, not
/// the raw PIN, so a Keychain/Keystore dump doesn't hand over the PIN
/// directly). [verify] also tracks failed attempts and imposes a short,
/// increasing lockout after repeated wrong guesses, since a bare 4-digit PIN
/// (10,000 combinations) is otherwise brute-forceable by anything that can
/// drive the UI.
class PinService {
  PinService([FlutterSecureStorage? storage])
    : _storage =
          storage ??
          const FlutterSecureStorage(
            iOptions: IOSOptions(
              accessibility: KeychainAccessibility.first_unlock,
            ),
          );

  final FlutterSecureStorage _storage;

  static const _hashKey = 'user_pin_hash';
  static const _saltKey = 'user_pin_salt';
  static const _attemptsKey = 'user_pin_attempts';
  static const _lockedUntilKey = 'user_pin_locked_until';

  /// Pre-hashing storage key: earlier versions stored the PIN in plaintext
  /// under this key. [_migrateLegacyIfNeeded] transparently upgrades it to a
  /// salted hash the first time it's touched, so existing users don't lose
  /// their PIN (and aren't silently dropped back to "no PIN set") just
  /// because of this security fix.
  static const _legacyPlaintextKey = 'user_pin';

  Future<void> _migrateLegacyIfNeeded() async {
    if (await _storage.read(key: _hashKey) != null) return;
    final legacy = await _storage.read(key: _legacyPlaintextKey);
    if (legacy == null) return;
    final salt = _newSalt();
    await _storage.write(key: _saltKey, value: salt);
    await _storage.write(key: _hashKey, value: _hash(legacy, salt));
    await _storage.delete(key: _legacyPlaintextKey);
  }

  /// After this many consecutive wrong guesses, a lockout kicks in.
  static const _maxAttempts = 5;

  /// Lockout duration after the (maxAttempts)th failure, doubling for every
  /// failure after that (capped) — 30s, 60s, 120s, ... up to [_maxLockout].
  static const _baseLockout = Duration(seconds: 30);
  static const _maxLockout = Duration(minutes: 5);

  Future<void> setPin(String pin) async {
    final salt = _newSalt();
    await _storage.write(key: _saltKey, value: salt);
    await _storage.write(key: _hashKey, value: _hash(pin, salt));
    await _clearAttempts();
  }

  Future<bool> hasPin() async {
    await _migrateLegacyIfNeeded();
    return (await _storage.read(key: _hashKey)) != null;
  }

  /// Seconds remaining before another [verify] attempt is accepted, or 0 if
  /// not currently locked out. UI can poll/display this after a failure.
  Future<int> lockoutSecondsRemaining() async {
    final raw = await _storage.read(key: _lockedUntilKey);
    if (raw == null) return 0;
    final until = DateTime.fromMillisecondsSinceEpoch(int.parse(raw));
    final remaining = until.difference(DateTime.now()).inSeconds;
    return remaining > 0 ? remaining : 0;
  }

  /// Checks [pin] against the stored hash. Returns false without comparing
  /// anything while locked out — repeated calls during a lockout don't reset
  /// or extend it. A correct guess resets the failure counter.
  Future<bool> verify(String pin) async {
    await _migrateLegacyIfNeeded();
    if (await lockoutSecondsRemaining() > 0) return false;

    final salt = await _storage.read(key: _saltKey);
    final storedHash = await _storage.read(key: _hashKey);
    final ok =
        salt != null && storedHash != null && _hash(pin, salt) == storedHash;

    if (ok) {
      await _clearAttempts();
      return true;
    }

    final attempts = await _recordFailedAttempt();
    if (attempts >= _maxAttempts) {
      // Cap the shift itself so this can't overflow on a very long streak of
      // failures, then cap the resulting duration at _maxLockout.
      final extra = min(attempts - _maxAttempts, 10);
      final seconds = min(
        _baseLockout.inSeconds << extra,
        _maxLockout.inSeconds,
      );
      final lockout = Duration(seconds: seconds);
      await _storage.write(
        key: _lockedUntilKey,
        value: DateTime.now().add(lockout).millisecondsSinceEpoch.toString(),
      );
    }
    return false;
  }

  Future<void> clear() async {
    await _storage.delete(key: _hashKey);
    await _storage.delete(key: _saltKey);
    await _storage.delete(key: _legacyPlaintextKey);
    await _clearAttempts();
  }

  Future<int> _recordFailedAttempt() async {
    final current =
        int.tryParse(await _storage.read(key: _attemptsKey) ?? '0') ?? 0;
    final next = current + 1;
    await _storage.write(key: _attemptsKey, value: next.toString());
    return next;
  }

  Future<void> _clearAttempts() async {
    await _storage.delete(key: _attemptsKey);
    await _storage.delete(key: _lockedUntilKey);
  }

  String _newSalt() {
    final rand = Random.secure();
    return base64UrlEncode(List<int>.generate(16, (_) => rand.nextInt(256)));
  }

  String _hash(String pin, String salt) =>
      sha256.convert(utf8.encode('$salt:$pin')).toString();

  /// True for PINs that give a false sense of security: all-same-digit
  /// (0000, 1111, ...) and the obvious ascending/descending runs. Screens
  /// that let the user choose a PIN should reject these and ask again.
  static bool isWeak(String pin) {
    if (pin.length < 4) return true;
    if (pin.split('').toSet().length == 1) return true; // e.g. 1111
    const runs = {
      '0123',
      '1234',
      '2345',
      '3456',
      '4567',
      '5678',
      '6789',
      '9876',
      '8765',
      '7654',
      '6543',
      '5432',
      '4321',
      '3210',
    };
    return runs.contains(pin);
  }
}

final pinServiceProvider = Provider<PinService>((ref) => PinService());
