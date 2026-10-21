import 'dart:math';

final _random = Random();

/// A compact, collision-resistant id for client-generated rows (trips, stops).
///
/// Combines a microsecond timestamp with random hex so two creations in the
/// same instant still differ. Returned as text — matches the `text primary key`
/// columns used by the local Drift and remote Supabase tables.
String newId() {
  final ts = DateTime.now().microsecondsSinceEpoch.toRadixString(16);
  final suffix = List.generate(
    6,
    (_) => _random.nextInt(16).toRadixString(16),
  ).join();
  return '$ts$suffix';
}
